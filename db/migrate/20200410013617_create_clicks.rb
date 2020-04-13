class CreateClicks < ActiveRecord::Migration[6.0]
  def change
    create_table :clicks do |t|
      t.integer :article_id
      t.integer :click_x
      t.integer :click_y
      t.integer :btn_id
      t.string :view_ip

      t.timestamps
    end
  end
end
