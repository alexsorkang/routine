class AddDifficultiesToRoutine < ActiveRecord::Migration
  def change
  	add_column :routines, :difficuly, :string
  end
end
