class AddFieldAmountTotalToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :amount_total, :float  , :default => 0.00
  end
end
