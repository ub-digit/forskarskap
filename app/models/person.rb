class Person < ApplicationRecord
  belongs_to :locker, optional: true
  has_many :visits
  
  validates_presence_of :name, :message => "Användare måste ha ett namn"
  validates_presence_of :personnbr, :message => "Användare måste ha ett personnummer"
  validates_presence_of :cardnbr, :message => "Användare måste ha ett lånekortsnummer"
  validates_uniqueness_of :personnbr, :message => "Denna användare finns redan i systemet"
  validates_uniqueness_of :cardnbr, :message => ""
  
  validates :personnbr, length: {is: 10 , message: "Personnummret ska vara i formatet ÅÅMMDDXXXX"}
  
  
  
  
  
  def self.search_name(search)
    where("name LIKE ?", "%#{search}%")
  end
  
  def self.search_personnbr(search)
    where("personnbr LIKE ?", "%#{search}%")
  end
  
  def self.search_cardnbr(search)
    where("cardnbr LIKE ?", "%#{search}%")
  end
  
  def self.search_locker(search)
    @lockers = Locker.where("number LIKE ?", "%#{search}%")
    @people = Array.new
    
    @lockers.each do |locker|
      @person = Person.where(locker_id: locker.id).first
      if @person
        @people.push(@person)
      end
    end
    
    return @people
  end
  
  
  def self.findGundaPerson(cardNbr)
    @searchString = "https://sunda.ub.gu.se/cgi-bin/forskreg-lookup.cgi?cnr=" + cardNbr + "&key=!kk889fr!"
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
  
  def self.updatePerson(id)
    @person = Person.find(id)
    if @person.personnbr
      @searchString = "https://sunda.ub.gu.se/cgi-bin/forskreg-lookup.cgi?pnr=" + @person.personnbr + "&key=!kk889fr!"
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
