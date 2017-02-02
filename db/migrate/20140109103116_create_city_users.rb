class CreateCityUsers < ActiveRecord::Migration
  def change
    create_table :city_users do |t|
      t.integer :primary_campus_id
      t.integer :city_user_id
      t.string :first
      t.string :last
      t.string :gender
      t.string :primary_campus_name
      t.string :full_name
      t.boolean :active
      t.timestamps
    end
  end
end
