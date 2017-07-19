class CreateVisits < ActiveRecord::Migration[5.1]
  def change
    create_table :visits do |t|
      t.date :date
      t.references :person, foreign_key: true
    end
  end
end
