class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.references :user, index: true
      t.references :event, index: true
      t.float :amount_payable , :default => 0.00
      t.float :amount_paid , :default => 0.00

      t.timestamps
    end
  end
end
