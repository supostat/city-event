class AddStaffToCityUsers < ActiveRecord::Migration
  def change
    add_column :city_users, :staff, :boolean , :default => false
  end
end
