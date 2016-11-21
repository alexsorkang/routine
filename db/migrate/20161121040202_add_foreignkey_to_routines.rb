class AddForeignkeyToRoutines < ActiveRecord::Migration
  def change
    remove_foreign_key :routines, :users
    add_foreign_key :routines, :users, name: :current_routine_id
  end
end
