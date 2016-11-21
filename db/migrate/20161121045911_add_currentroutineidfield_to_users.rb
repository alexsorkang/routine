class AddCurrentroutineidfieldToUsers < ActiveRecord::Migration
  def change
    add_column :users, :current_routine_id, :integer
  end
end
