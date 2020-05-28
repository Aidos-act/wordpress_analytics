class DropScrolls < ActiveRecord::Migration[6.0]
  def change
  	drop_table :scrolls
  end
end
