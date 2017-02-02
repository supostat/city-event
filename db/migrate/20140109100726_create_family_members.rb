class CreateFamilyMembers < ActiveRecord::Migration
  def change
    create_table :family_members do |t|
      t.integer :city_user_id
      t.string :name
      t.string :email
      t.string :family_role
      t.boolean :active
      t.string :full_name
      t.references :user, index: true

      t.timestamps
    end
  end
end
