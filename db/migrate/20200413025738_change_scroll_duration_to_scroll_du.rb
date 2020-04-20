class ChangeScrollDurationToScrollDu < ActiveRecord::Migration[6.0]
  def change
  	rename_column :scroll_durations, :scroll_duration, :scroll_du
  end
end