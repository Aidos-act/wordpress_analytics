class AddIndexToArticles < ActiveRecord::Migration[6.0]
  def change
  	add_index :articles, :article_url, unique: true
  end
end
