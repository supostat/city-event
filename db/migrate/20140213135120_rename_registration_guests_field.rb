class RenameRegistrationGuestsField < ActiveRecord::Migration
  def change
    rename_column :registration_guests, :registrations_id, :registration_id
  end
end
