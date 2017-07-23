class Locker < ApplicationRecord
  has_one :person
  
  validates_uniqueness_of :number

  
  
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
  
  
  def self.isAvailable(id)
    @person = Person.where(locker_id: id).first
    if(@person)
      return false
    else
      return true
    end
  end
  
end
