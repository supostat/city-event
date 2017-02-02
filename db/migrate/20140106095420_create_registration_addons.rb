class CreateRegistrationAddons < ActiveRecord::Migration
  def change
    create_table :registration_addons do |t|
      t.references :registrations, index: true
      t.integer :addon_id
      t.timestamps
    end
  end
end
