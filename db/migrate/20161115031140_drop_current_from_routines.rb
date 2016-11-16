class DropCurrentFromRoutines < ActiveRecord::Migration
  def change
    remove_column :routines, :current
  end
end
