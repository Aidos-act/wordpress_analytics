class RenameScrollDurationsToScrolls < ActiveRecord::Migration[6.0]
  def change
  	rename_table :scroll_durations, :scrolls
  end
end
