class VisitsController < ApplicationController
  protect_from_forgery prepend: true
  
  $type = ""
  
  def new
    @type = $type
  end
  
  
  
  def create
    
    #Visit is created by 
    if params[:date_year].present?
      
      puts "KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKEEEEEEEEEEEEEEEEEEEEEEEE"
      puts params[:date_year] 
      
      @person = Person.find(params[:person_id])
      @year = params[:date_year].to_i
      @month = params[:date_month].to_i
      @day = params[:date_day].to_i
      if @year
        if @person 
          @visit = @person.visits.new
          @visit.date = Date.new(@year, @month, @day)
          @visit.save
        end
        
      end
      redirect_to people_path


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

      redirect_to action: :new
    end
    
  end

  
end
