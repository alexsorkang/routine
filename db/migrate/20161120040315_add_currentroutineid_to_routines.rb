class AddCurrentroutineidToRoutines < ActiveRecord::Migration
  def change
    remove_column :users, :current_routine_id
    add_column :routines, :current_routine_id, :integer
  end
end
