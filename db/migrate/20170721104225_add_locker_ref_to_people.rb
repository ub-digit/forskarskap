class AddLockerRefToPeople < ActiveRecord::Migration[5.1]
  def change
    add_reference :people, :locker, foreign_key: true
  end
end
