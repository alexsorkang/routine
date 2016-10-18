class AddSharedToRoutines < ActiveRecord::Migration
  def change
    add_column :routines, :shared, :boolean
  end
end
