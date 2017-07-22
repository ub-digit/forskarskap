class Person < ApplicationRecord
  belongs_to :locker, optional: true
  has_many :visits
  
  validates_presence_of :name, :message => "Användare måste ha ett namn"
  validates_presence_of :personnbr, :message => "Användare måste ha ett personnummer"
  validates_presence_of :cardnbr, :message => "Användare måste ha ett lånekortsnummer"
  validates_uniqueness_of :personnbr, :message => "Användare med detta personnummer existerar redan"
  validates_uniqueness_of :cardnbr, :message => "Användare med detta lånekortsnummer existerar redan"
  
  validates :personnbr, length: {is: 12 , message: "Personnummret ska vara i formatet ÅÅÅÅMMDDXXXX"}
  
  
  
  
  
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
  

  
  
 
end
