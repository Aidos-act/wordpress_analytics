class RenameSrcrollDuToScrollDur < ActiveRecord::Migration[6.0]
  def change
  	rename_column :scrolls, :scroll_du, :scroll_dur
  end
end
