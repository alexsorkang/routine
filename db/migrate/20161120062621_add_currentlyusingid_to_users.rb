class AddCurrentlyusingidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :currently_using_id, :integer
  end
end
