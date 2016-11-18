class AddUsernameToRoutines < ActiveRecord::Migration
  def change
    add_column :routines, :username, :string
  end
end
