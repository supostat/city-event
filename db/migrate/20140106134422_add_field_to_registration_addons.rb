class AddFieldToRegistrationAddons < ActiveRecord::Migration
  def change
    add_column :registration_addons, :addon_value, :string
  end
end
