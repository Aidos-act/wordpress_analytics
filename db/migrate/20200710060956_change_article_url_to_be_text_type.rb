class ChangeArticleUrlToBeTextType < ActiveRecord::Migration[6.0]
  def change
  	change_column :articles, :article_url, :text
  end
end
