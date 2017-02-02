class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :discount_type
      t.float :amount
      t.string :coupon

      t.timestamps
    end
  end
end
