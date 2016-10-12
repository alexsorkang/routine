class RenameDifficulyInRoutineToDifficulty < ActiveRecord::Migration
  def change
  	rename_column :routines, :difficuly, :difficulty
  end
end
