class VisitsController < ApplicationController
  $message = ""
  
  def new
    @message = $message
  end
  
  
  
  def create

    if params[:cardnbr].present?
      @person = Person.where(cardnbr: params[:cardnbr]).take
      
      if @person != nil
        
        if @person.locker_id != nil
        
          @duplicate = Visit.where(["date = ? and person_id = ?", Date.today, @person.id]).take

          if @duplicate
            $message = "Du har redan registrerat ditt besök för idag"
          else
            @visit = @person.visits.new
            @visit.date = Date.today
            @visit.save
            $message = "Ditt besök är nu registrerat"
          end
          
        else
          $message = "Ett fel uppstod. Detta lånekort har inte ett forskarskåp registrerat. Vänligen kontakta ansvarig personal"
        end

      else
        $message = "Ett fel uppstod. Detta lånekort finns inte registerat i systemet"
      end

    else
      $message = "Ett fel uppstod. Detta lånekort finns inte registerat i systemet"
    end
    
    redirect_to action: :new
  end
  

  
end
