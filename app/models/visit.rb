class Visit < ApplicationRecord
  belongs_to :person
  
  validates_uniqueness_of :date, scope: :person_id
  

  
  def self.search(date,person)
    where("date EQUALS ? AND person EQUALS ?", "%#{date}%", "%#{person}%")
  end
  
end

