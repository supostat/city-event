class RenameAddonRegistrationsIfField < ActiveRecord::Migration
  def change
    rename_column :registration_addons, :registrations_id, :registration_id
  end
end
