class AddPricingColumnsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :base_price, :float , :default => 0.00
    add_column :events, :max_price, :float  , :default => 0.00
  end
end
