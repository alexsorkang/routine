class DropUsernameFromRoutines < ActiveRecord::Migration
  def change
    remove_column :routines, :username
    add_column :users, :username, :string
  end
end
