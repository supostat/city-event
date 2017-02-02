class AddGuestFieldToRegistrationAddons < ActiveRecord::Migration
  def change
    add_reference :registration_addons, :registration_guest, index: true
  end
end
