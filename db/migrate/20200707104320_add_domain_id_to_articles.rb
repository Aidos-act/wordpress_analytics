class AddDomainIdToArticles < ActiveRecord::Migration[6.0]
  def change
  	add_column :articles, :domain_id, :integer, after: :id
  end
end
