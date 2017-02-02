class AddFieldMaxPriceToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :max_price, :float , :default => 0.00
  end
end
