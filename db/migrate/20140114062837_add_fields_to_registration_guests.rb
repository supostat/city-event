class AddFieldsToRegistrationGuests < ActiveRecord::Migration
  def change
    add_column :registration_guests, :address, :text
    add_column :registration_guests, :city, :string
    add_column :registration_guests, :state, :string
  end
end
