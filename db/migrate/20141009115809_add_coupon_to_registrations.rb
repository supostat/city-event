class AddCouponToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :coupon, :string  , :default => ''
    add_column :registrations, :coupon_amount, :float  , :default => 0.00
  end
end
