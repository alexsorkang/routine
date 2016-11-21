class DropForeignkeyFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :current_routine_id
  end
end
