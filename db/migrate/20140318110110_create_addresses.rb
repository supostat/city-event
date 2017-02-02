class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :friendly_name
      t.string :street
      t.string :street2
      t.string :zipcode
      t.string :city
      t.string :state
      t.string :location_type

      t.string :latitude
      t.string :longitude



      t.integer :city_address_id
      t.integer :city_user_id
      t.string :privacy


      t.timestamps
    end
  end
end
