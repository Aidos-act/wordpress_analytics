class AddDateHourToClick < ActiveRecord::Migration[6.0]
  def change
  	add_column :clicks, :date_hour, :datetime, after: :article_id
  	remove_column :clicks, :view_ip
  end
end
