class DropColumnInClicks < ActiveRecord::Migration[6.0]
  def change
  	remove_column :clicks, :btn_id
  end
end
