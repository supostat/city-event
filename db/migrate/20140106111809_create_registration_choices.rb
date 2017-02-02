class CreateRegistrationChoices < ActiveRecord::Migration
  def change
    create_table :registration_choices do |t|
      t.references :registration_addon, index: true
      t.integer :choice_id
      t.integer :choice_value, :default => 0
      t.float :choice_price , :default => 0.00

      t.timestamps
    end
  end
end
