class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :customer_first_name
      t.string :customer_last_name
      t.string :customer_address1
      t.string :customer_address2
      t.string :customer_city
      t.string :customer_state
      t.string :customer_postal_code
      t.string :customer_country
      t.string :customer_phone
      t.string :customer_email
      t.integer :registration_id
      t.integer :user_id
      t.string :coupon
      t.float :order_total

      t.timestamps
    end
  end
end
