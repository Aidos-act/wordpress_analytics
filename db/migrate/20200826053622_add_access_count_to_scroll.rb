class AddAccessCountToScroll < ActiveRecord::Migration[6.0]
  def change
    add_column :scrolls, :access_count, :integer, :after => :scroll_duration
  end
end
