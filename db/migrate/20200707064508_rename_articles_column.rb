class RenameArticlesColumn < ActiveRecord::Migration[6.0]
  def change
  	rename_column :articles, :title, :article_title
  	rename_column :articles, :url, :article_url
  end
end
