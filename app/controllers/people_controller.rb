class PeopleController < ApplicationController
  http_basic_authenticate_with name: "admin", password: "Ren4strom"
  
  #To keep the search results and the description of a person showing even if you reload the page
  $search_by = ""
  $search = ""
  $selected
  
  
  
  def index
    @people = Person.all

    #If a search was made, the search-by parameter is updated
    if params[:search_by]
      $search_by = params[:search_by]
    end
    
    #If a search was made, the search-parameter is updated
    if params[:search]
      $search = params[:search]
    end
    
    #If a new person is selected, which one is shown is updated
    if params[:show]
      $selected = params[:show]
    end
    
    #The parameters sent to the html-file is given  a value
    @search_by = $search_by
    @search = $search
    
    #The parameters sent to the html file for which person is shown is given a value
    if Person.exists?($selected) #Since if a person is removed they're still set as $selected
      @selected = Person.find($selected)
      @visits = @selected.visits.sort_by &:date
      @selectedLocker = Locker.where(id: @selected.locker_id).first
      @nbrOfVisits = @selected.visits.count
      @countingFrom = Date.today - 30
      @visitsThisMonth = Visit.where('person_id = ? AND date > ?', @selected.id, @countingFrom).count
    end

    
    #Sets which people the index is supposed to display
    if $search.blank? #If the search is blank, all people are shown, sorted according to the search-by parameter
      if $search_by == "Namn"
        @people = Person.all.order(:name)  
      elsif $search_by == "Personnummer"
        @people = Person.all.order(:personnbr)
      elsif $search_by == "Lånekortsnummer"
        @people = Person.all.order(:cardnbr)
      elsif $search_by == "Antal besök"
        @p = Person.all
        @people = @p.sort { |x,y| x.visits.count <=> y.visits.count }
      else
        @people = Person.all.order(:locker_id)
      end
      
    else #Otherwise a search is done on and sorted by the search-by parameter

      if $search_by == "Namn"
        @people = Person.search_name($search).order(:name)
      elsif $search_by == "Personnummer"
        @people = Person.search_personnbr($search).order(:personnbr)
      elsif $search_by == "Lånekortsnummer"
        @people = Person.search_cardnbr($search).order(:cardnbr)
      elsif $search_by == "Forskarskåp"
        @people = Person.search_locker($search)
      else
        if $search == "0"
          @p = Person.all
          @people = @p.sort { |x,y| x.visits.count <=> y.visits.count }
        else
          @nbrOfMonths = $search.to_i
          @p = Person.all
          if @nbrOfMonths > 0
            @people = @p.sort { |x,y| countInterval(x, @nbrOfMonths) <=> countInterval(y, @nbrOfMonths) }
          else
            @people = nil;
          end
        end
      end
        
    end
    
    @nbrOfPeople = Person.all.count
  end
  
  #Help method that counts the number of visits a person has during the last given number of months
  def countInterval(person, nbrOfMonths)
    @count = 0;
    @date = Date.today - 30*nbrOfMonths
    person.visits.each do |visit|
      if visit.date > @date
        @count = @count+1
      end
    end
    return @count;
  end
  
  
  
  
  def new
    @person=Person.new
  end
  
  
  def edit
    @person = Person.updatePerson(params[:id])
    
    @visit = Visit.new
  end
  
  
  def create
    @person = Person.new(person_params)
    
    
    if !@person.personnbr.blank? and @person.personnbr != "0"
      @searchString = "https://sunda.ub.gu.se/cgi-bin/forskreg-lookup.cgi?pnr=" + @person.personnbr + "&key=!kk889fr!"
      @gundaPerson = @gundaPerson = eval(Net::HTTP.get(URI(@searchString)))[:patron]

      if @gundaPerson[:name]
        @person.name = @gundaPerson[:name].force_encoding('UTF-8')
        @person.cardnbr = @gundaPerson[:card_number]
        @person.registrationDate = Date.today
        
        if @person.save
          $selected = @person.id
          redirect_to people_path
        else
          render 'new'
        end

      else
        @person.errors.add(@person.personnbr, "Person med detta personnummer finns inte registrerat i bibliotekets system")
        render 'new'
      end
      
    else
      @person.errors.add(@person.personnbr, "Vänligen fyll i personnummer")
      render 'new'
    end
    
  end
  
  
  def update
    @person = Person.find(params[:id])
 
    if @person.update(person_params)
      $selected = @person.id
      redirect_to people_path
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
