class CreateGaApis < ActiveRecord::Migration[6.0]
  def change
    create_table :ga_apis do |t|
      t.integer :article_id, null: false
      t.datetime :date_hour, null: false
      t.integer :page_view, default: 0
      t.integer :user, default: 0
      t.integer :new_user, default: 0
      t.integer :bounce, default: 0
      t.integer :session, default: 0
      t.integer :avg_time_on_page, default: 0

      t.timestamps
    end
  end
end
