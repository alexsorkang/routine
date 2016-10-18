class AddCurrentToRoutines < ActiveRecord::Migration
  def change
    add_column :routines, :current, :boolean
  end
end
