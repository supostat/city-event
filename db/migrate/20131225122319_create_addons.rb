class CreateAddons < ActiveRecord::Migration
  def change
    create_table :addons do |t|
      t.string :addon_type
      t.string :title
      t.boolean :registration_type , :default => true
      t.references :event, index: true

      t.timestamps
    end
  end
end
