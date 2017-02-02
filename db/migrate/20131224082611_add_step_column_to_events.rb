class AddStepColumnToEvents < ActiveRecord::Migration
  def change
    add_column :events, :step, :integer , :default => 0
  end
end
