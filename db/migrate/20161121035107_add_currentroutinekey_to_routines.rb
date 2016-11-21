class AddCurrentroutinekeyToRoutines < ActiveRecord::Migration
  def change
    remove_column :users, :currently_using_id
    remove_column :routines, :current_routine_id
    add_foreign_key :routines, :users
  end
end
