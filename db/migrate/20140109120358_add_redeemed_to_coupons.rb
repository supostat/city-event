class AddRedeemedToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :redeemed, :string
  end
end
