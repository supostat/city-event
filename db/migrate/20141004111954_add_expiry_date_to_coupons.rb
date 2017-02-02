class AddExpiryDateToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :expiry_date, :datetime
    add_column :coupons, :auto_expire, :integer , :default => 1
  end

end
