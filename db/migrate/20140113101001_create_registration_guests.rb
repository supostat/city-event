class CreateRegistrationGuests < ActiveRecord::Migration
  def change
    create_table :registration_guests do |t|

      t.references :registrations, index: true
      t.string :first
      t.string :last
      t.string :email
      t.string :primary_phone_type , :default => "home"
      t.string :primary_phone
      t.string :guest_type, :default => ""
      t.references :city_user, index: true


      t.timestamps
    end
  end
end
