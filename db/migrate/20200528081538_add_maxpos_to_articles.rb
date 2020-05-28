class AddMaxposToArticles < ActiveRecord::Migration[6.0]
  def change
  	add_column :articles, :maxpos, :integer
  end
end
