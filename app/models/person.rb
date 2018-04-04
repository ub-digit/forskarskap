#A person has a name, personnumber, cardnumbed, id and locker_id. 
#They also have several visits, which is modeled by each visit having a person_id
#Represents a scientist in the library who which has a locker
class Person < ApplicationRecord
  belongs_to :locker, optional: true
  has_many :visits
  
  validates_presence_of :name, :message => "Användare måste ha ett namn"
  validates_presence_of :personnbr, :message => "Användare måste ha ett personnummer"
  validates_presence_of :cardnbr, :message => "Användare måste ha ett lånekortsnummer"
  validates_uniqueness_of :personnbr, :message => "Denna användare finns redan i systemet"
  validates_uniqueness_of :cardnbr, :message => ""
  
  validates :personnbr, length: {is: 10 , message: "Personnummret ska vara i formatet ÅÅMMDDXXXX"}
  
  
  
  
  #Used to search for people that has a name that is or contains a given string
  def self.search_name(search)
    where("LOWER(name) LIKE LOWER(?)", "%#{search}%")
  end
  
  #Used to search for people that has a personnumber that is or contains a given string
  def self.search_personnbr(search)
    where("personnbr LIKE ?", "%#{search}%")
  end
  
  #Used to search for people that has a card number that is or contains a given string
  def self.search_cardnbr(search)
    where("cardnbr LIKE ?", "%#{search}%")
  end
  
  #Used to search for people that has a locker whos number is or contains a given string
  def self.search_locker(search)
    @lockers = Locker.where("LOWER(number) LIKE LOWER(?)", "%#{search}%")
    @people = Array.new
    
    @lockers.each do |locker|
      @person = Person.where(locker_id: locker.id).first
      if @person
        @people.push(@person)
      end
    end
    
    return @people
  end
  
  #Looks up in GUNDA for the person who's cardnumber matches a given string
  #Uses that persons personnumber to find corresponding person in this program's database
  #Returns:
  # Found person, if such exists (The person has a locker)
  # A new empty person, if no such person exits (The person has no locker)
  # Null, if no person matching the cardnumber is found in GUNDA (Something went wrong reading the card/they are not in the GUNDA-system)
  def self.findGundaPerson(cardNbr)
    if cardNbr == "0"
      return nil
    end
    
    @searchString = "https://koha-intra.ub.gu.se/cgi-bin/koha/svc/members/forskreg-lookup?cnr=" + cardNbr + "&key=!kk889fr!"
    @gundaPerson = eval(Net::HTTP.get(URI(@searchString)))[:patron]
  
    if @gundaPerson[:name]
      @person = Person.where(personnbr: @gundaPerson[:person_number]).first;
      if @person 
        @person.update_attributes(:name => @gundaPerson[:name].force_encoding('UTF-8'), :cardnbr => @gundaPerson[:card_number])
      else
        @person = Person.new
      end
      
      return @person
    else
      return nil
    end
  end
  
  
  #Updates a person with a given ID by getting their information from GUNDA
  #Returns:
  # The updated person, if a person matching the ID is found
  # Null, if no person matches
  def self.updatePerson(id) 
    @person = Person.find(id)
    if @person.personnbr
      @searchString = "https://koha-intra.ub.gu.se/cgi-bin/koha/svc/members/forskreg-lookup?pnr=" + @person.personnbr + "&key=!kk889fr!"
      @gundaPerson =  eval(Net::HTTP.get(URI(@searchString)))[:patron]
      
      
      if @gundaPerson[:name]
        @person = Person.where(personnbr: @gundaPerson[:person_number]).first; 
        @person.update_attributes(:name => @gundaPerson[:name].force_encoding('UTF-8'), :cardnbr => @gundaPerson[:card_number])
        return @person
      else
        return nil
      end
      
    end
    
  end
  

  
  
 
end
