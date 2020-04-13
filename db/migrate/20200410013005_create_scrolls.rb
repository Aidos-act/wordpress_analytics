class CreateScrolls < ActiveRecord::Migration[6.0]
  def change
    create_table :scrolls do |t|
      t.integer :article_id
      t.integer :scroll_max_pos

      t.timestamps
    end
  end
end
