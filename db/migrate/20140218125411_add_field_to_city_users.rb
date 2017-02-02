class AddFieldToCityUsers < ActiveRecord::Migration
  def change
    add_column :city_users, :email, :string
  end
end
