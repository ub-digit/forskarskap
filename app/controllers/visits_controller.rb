class VisitsController < ApplicationController
  $type = ""
  
  def new
    @type = $type
  end
  
  
  
  def create

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
