class AddTimestampsToRoutine < ActiveRecord::Migration
  def change
  	add_timestamps(:routines)
  end
end
