class PeopleController < ApplicationController
  $search_by = ""
  $search = ""
  
  
  def index
    @people = Person.all
    
    if params[:search_by]
      $search_by = params[:search_by]
    end
    if params[:search]
      $search = params[:search]
    end
    
    @search_by = $search_by
    @search = $search
    
    
    if params[:search].blank?
      if $search_by == "Namn"
        @found = Person.all.order(:name) 
      elsif $search_by == "Personnummer"
        @people = Person.all.order(:personnbr)
      elsif $search_by == "Lånekortsnummer"
        @people = Person.all.order(:cardnbr)
      else
        @people = Person.all.order(:locker_id)
      end
      
    else

      if $search_by == "Namn"
        @people = Person.search_name(params[:search]).order(:name)
      elsif $search_by == "Personnummer"
        @people = Person.search_personnbr(params[:search]).order(:personnbr)
      elsif $search_by == "Lånekortsnummer"
        @people = Person.search_cardnbr(params[:search]).order(:cardnbr)
      elsif $search_by == "Forskarskåp"
        @people = Person.search_locker(params[:search])
      end
        
    end
    
    if params[:show]
      @selected = Person.find(params[:show])
      @locker = Locker.where(id: @selected.locker_id).first
      @nbrOfVisits = @selected.visits.count
    end

  end
  
  
  #def show
  #  @person = Person.find(params[:id])
  #  @locker = Locker.where(id: @person.locker_id).first
  #  @nbrOfVisits = @person.visits.count
  #end
  
  def new
    @person=Person.new
    @available = Locker.listAvailable()
  end
  
  def edit
    @person = Person.find(params[:id])
    @available = Locker.listAvailable()
  end
  
  def create
    @person = Person.new(person_params)
    @person.registrationDate = Date.today
 
    if @person.save
      redirect_to @person
    else
      render 'new'
    end
  end
  
  
  def update
    @person = Person.find(params[:id])
 
    if @person.update(person_params)
      redirect_to @person
    else
      render 'edit'
    end
  end
  
  
  def destroy
    @person = Person.find(params[:id])
    
    @person.visits.each do |visit|
      visit.destroy
    end
        
    @person.delete
    
    redirect_to people_path
  end
  
  
  private
    def person_params
      params.require(:person).permit(:name, :personnbr, :cardnbr, :locker_id)
    end
end
