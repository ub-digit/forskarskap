class Locker < ApplicationRecord
  has_one :person
  
  validates_uniqueness_of :number
  
  
  
  
  
  def self.listAvailable()
    @people = Person.all
    @lockers = Locker.all
    
    @people.each do |person|
      @locker = Locker.where(id: person.locker_id)
      if @locker
        @lockers.delete(@locker)
      end
    end
    return @lockers
  end
  
  
  def self.isAvailable(nbr)
    @locker = Locker.where(number: nbr)
    @person = Person.where(locker_id: @locker.id)
    if(@person)
      return false
    else
      return true
    end
  end
  
end
