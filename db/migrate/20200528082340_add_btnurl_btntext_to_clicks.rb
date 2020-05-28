class AddBtnurlBtntextToClicks < ActiveRecord::Migration[6.0]
  def change
  	add_column :clicks, :btn_url, :text
  	add_column :clicks, :btn_text, :text
  end
end
