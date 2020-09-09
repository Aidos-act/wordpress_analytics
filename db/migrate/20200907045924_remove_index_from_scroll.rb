class RemoveIndexFromScroll < ActiveRecord::Migration[6.0]
  def change
  	remove_index :scrolls, name: "index_scrolls_on_article_id_and_scroll_position"
  end
end
