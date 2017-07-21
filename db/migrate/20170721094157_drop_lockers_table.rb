class DropLockersTable < ActiveRecord::Migration[5.1]
  def up
    drop_table :lockers
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
