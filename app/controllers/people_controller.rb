class PeopleController < ApplicationController
  
  
  
  def index
    @people = Person.all

    if params[:search]
      
      if params[:search_by] == "Namn"
        @people = Person.search_name(params[:search]).order(:name)
      elsif params[:search_by] == "Personnummer"
        @people = Person.search_personnbr(params[:search]).order(:personnbr)
      elsif params[:search_by] == "Lånekortsnummer"
        @people = Person.search_cardnbr(params[:search]).order(:cardnbr)
      else
        @people = Person.all.order(:name)
      end
      
    else
      
      if params[:search_by] == "Namn"
        @people = Person.all.order(:name)
      elsif params[:search_by] == "Personnummer"
        @people = Person.all.order(:personnbr)
      elsif params[:search_by] == "Lånekortsnummer"
        @people = Person.all.order(:cardnbr)
      else
        @people = Person.all.order(:name)
      end
      
    end
 
  end
  
  
  
  
  
  def show
    @person = Person.find(params[:id])
  end
  
  def new
    @person=Person.new
  end
  
  def edit
    @person = Person.find(params[:id])
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
    @person.destroy
    
    redirect_to people_path
  end
  
  private
    def person_params
      params.require(:person).permit(:name, :personnbr, :cardnbr)
    end
end
