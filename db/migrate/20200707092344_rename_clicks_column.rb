class RenameClicksColumn < ActiveRecord::Migration[6.0]
  def change
  	rename_column :clicks, :btn_url, :button_url
  	rename_column :clicks, :btn_text, :button_text
  end
end
