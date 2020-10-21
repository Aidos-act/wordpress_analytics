class ConvertArticleTableToUtf8mb4 < ActiveRecord::Migration[6.0]
  def change
  	# for saving imoji data into article table
  	execute "ALTER TABLE articles CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
  	execute "ALTER TABLE articles MODIFY article_title VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
  end
end
