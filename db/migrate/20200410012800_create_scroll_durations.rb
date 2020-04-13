class CreateScrollDurations < ActiveRecord::Migration[6.0]
  def change
    create_table :scroll_durations do |t|
      t.integer :article_id
      t.integer :scroll_pos
      t.float :scroll_duration

      t.timestamps
    end
  end
end
