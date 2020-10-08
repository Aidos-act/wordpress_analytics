class CreateGaUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :ga_users do |t|
      t.references :article, null: false, foreign_key: true
      t.datetime :date, null: false
      t.integer :user_record, default: 0
      t.integer :new_user_record, default: 0

      t.timestamps
    end
  end
end
