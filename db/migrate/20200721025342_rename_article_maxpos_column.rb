class RenameArticleMaxposColumn < ActiveRecord::Migration[6.0]
  def change
  	rename_column :articles, :maxpos, :max_position
  end
end
