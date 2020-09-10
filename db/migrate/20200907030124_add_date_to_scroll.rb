class AddDateToScroll < ActiveRecord::Migration[6.0]
  def change
    add_column :scrolls, :date, :datetime, :after => :article_id
  end
end
