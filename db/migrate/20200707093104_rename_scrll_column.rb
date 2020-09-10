class RenameScrllColumn < ActiveRecord::Migration[6.0]
  def change
  	rename_column :scrolls, :scroll_pos, :scroll_position
  	rename_column :scrolls, :scroll_dur, :scroll_duration
  end
end
