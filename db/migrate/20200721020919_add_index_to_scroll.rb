class AddIndexToScroll < ActiveRecord::Migration[6.0]
  def change
  	add_index :scrolls, [:article_id, :scroll_position], unique: true
  end
end
