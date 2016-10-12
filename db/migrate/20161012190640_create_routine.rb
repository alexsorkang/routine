class CreateRoutine < ActiveRecord::Migration
  def change
    create_table :routines do |t|
      t.string :name
      t.text :description
      t.jsonb :routine, null: false, default: '{}'
    end
  end
end