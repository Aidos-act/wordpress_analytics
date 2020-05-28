class DropColumnAndAddToClicks < ActiveRecord::Migration[6.0]
  def change
  	remove_column :clicks, :btn_url
  	remove_column :clicks, :btn_text
  	add_column :clicks, :btn_url, :text, :after => :click_y
  	add_column :clicks, :btn_text, :text, :after => :btn_url
  end
end
