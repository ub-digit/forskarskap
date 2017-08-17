#A locker has an id and a number
#Also has a person assigned to it, modeled by a person having a locker_id
#Represents one of the lockers available to scientists in the library
class Locker < ApplicationRecord
  has_one :person
  
  validates_uniqueness_of :number

  
  
  #Used to get a list of all lockers not assigned to a person
  def self.listAvailable(lockerId)
    @available = Array.new
    Locker.all.each do |locker|
      if(Locker.isAvailable(locker.id))
        @available.push(locker)
      end
    end
    
    if lockerId != nil
      puts lockerId
      @personsLocker = Locker.find(lockerId)
      @available.push(@personsLocker)
    end
    
    @available.sort! {|a,b| a.number.downcase <=> b.number.downcase}
    return @available
  end
  
  
  #Returns wether a locker with a given id is available or not
  def self.isAvailable(id)
    @person = Person.where(locker_id: id).first
    if(@person)
      return false
    else
      return true
    end
  end
  
end
