class DropColumnAndAddToArticles < ActiveRecord::Migration[6.0]
  def change
  	remove_column :articles, :maxpos
  	add_column :articles, :maxpos, :integer, :after => :url
  end
end