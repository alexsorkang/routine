class DropForeignkeyFromRoutines < ActiveRecord::Migration
  def change
    remove_foreign_key :routines, :users
    add_column :users, :current_routine_id, :integer
  end
end
