class CreateGoals < ActiveRecord::Migration[6.0]
  def change
    create_table :goals do |t|
      t.integer :domain_id, null: false
      t.string :goal_name, null: false
      t.integer :goal_index, null: false

      t.timestamps
    end
  end
end
