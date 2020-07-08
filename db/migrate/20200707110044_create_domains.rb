class CreateDomains < ActiveRecord::Migration[6.0]
  def change
    create_table :domains do |t|
      t.string :domain_name, null: false
      t.integer :view_id

      t.timestamps
    end
  end
end
