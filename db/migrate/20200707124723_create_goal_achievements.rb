class CreateGoalAchievements < ActiveRecord::Migration[6.0]
  def change
    create_table :goal_achievements do |t|
      t.integer :goal_id, null: false
      t.integer :article_id, null: false
      t.datetime :date_hour, null: false
      t.integer :conversion_rate, default: 0
      t.integer :completion, default: 0

      t.timestamps
    end
  end
end
