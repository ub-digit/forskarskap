class VisitsController < ApplicationController
  
  def create
    @person = Person.find(params[:person_id])
    @visit = @person.visits.create()
    @visit.date = Date.today
  end
  
end
