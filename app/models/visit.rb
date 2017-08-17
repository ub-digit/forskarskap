#A visit has a date and a person_id, representing a visit a person does

class Visit < ApplicationRecord
  belongs_to :person
  
  validates_uniqueness_of :date, scope: :person_id
  

  
  #Used to find a visit for a given person during a given date
  def self.search(date,person)
    where("date EQUALS ? AND person EQUALS ?", "%#{date}%", "%#{person}%")
  end
  
  
end

