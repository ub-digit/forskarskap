class Person < ApplicationRecord
  validates :name,  presence: true, length: {minimum: 5} 
  validates :personnbr, presence: true, length: {is: 12 }
end
