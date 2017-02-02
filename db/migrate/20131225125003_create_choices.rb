class CreateChoices < ActiveRecord::Migration
  def change
    create_table :choices do |t|
      t.references :addon, index: true
      t.string :title
      t.float :price , :default => 0.00
      t.integer :range_from
      t.integer :range_to

      t.timestamps
    end
  end
end
