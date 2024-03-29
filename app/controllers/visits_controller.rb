class VisitsController < ApplicationController
  protect_from_forgery prepend: true
  
  $type = ""
  
  def new
    
    @type = $type
    puts request.remote_ip

   #Removed the if statement below when dockerizing. It will be handled at the web server level instead.
   #if request.remote_ip != "127.0.0.1" && request.remote_ip != "130.241.18.64" && request.remote_ip != "130.241.35.135" && request.remote_ip != "130.241.19.19"
   #  raise ActionController::RoutingError.new('Denied Access')
   #end

  end
  
  def index
    
    if !params[:date].blank?
      begin
        @date = Date.parse(params[:date])
        @nbrVisits =  Visit.where(["date = ?", @date]).count
         
      rescue ArgumentError
        @error = "Vänligen skriv datumet i formen ÅÅÅÅMMDD"
      end
    end
    
    
    if !params[:start_date].blank? && !params[:end_date].blank?
      begin
        @startDate = Date.parse(params[:start_date])
        @endDate = Date.parse(params[:end_date])
        @maxAmount = 0;
        @current = @startDate
        
        while @current < @endDate
          @amount =  Visit.where(["date = ?", @current]).count
          if @amount > @maxAmount
            @maxAmount = @amount
          end
          @current = @current + 1.day
        end
      rescue ArgumentError
        @error = "Vänligen skriv datumet i formen ÅÅÅÅMMDD"
      end
    end
    
    
    
    if !params[:start_date_tot].blank? && !params[:end_date_tot].blank?
      begin
        @startDate = Date.parse(params[:start_date_tot])
        @endDate = Date.parse(params[:end_date_tot])
        @tot = 0;
        @current = @startDate
        
        while @current < @endDate
          @tot = @tot + Visit.where(["date = ?", @current]).count
          @current = @current + 1.day
        end
      rescue ArgumentError
        @error = "Vänligen skriv datumet i formen ÅÅÅÅMMDD"
      end
    end
    
  end
  
  
  
  
  
  def create
    
    
    #Visit is created by admin with a given date and person id
    if params[:person_id].present?
      @person = Person.find(params[:person_id])
      @year = params[:date_year].to_i
      @month = params[:date_month].to_i
      @day = params[:date_day].to_i
      
      if @year != 0 && @month != 0 && @day != 0
        if @person 
          @visit = @person.visits.new
          @visit.date = Date.new(@year, @month, @day)
          @visit.save
        end
        
      end
      redirect_to people_path

      
    #Visit is created by user with given cardnumber, and date is today
    else

      if params[:cardnbr].present?
        @person = Person.findGundaPerson(params[:cardnbr])

        if @person != nil
          if @person.locker_id != nil

            @duplicate = Visit.where(["date = ? and person_id = ?", Date.today, @person.id]).take

            if @duplicate
              $type = "redundant"

            else
              @visit = @person.visits.new
              @visit.date = Date.today
              @visit.save
              $type = "confirmation"
            end

          else
            $type = "noLockerError"
          end

        else
          $type = "error"
        end

      else
        $type = "error"
      end

      redirect_to ''
    end
    
  end
  
  
  def destroy
    @visit = Visit.find(params[:id])  
    @visit.delete
    redirect_to people_path
  end

  
end
