class CreateEventOptionTypes < ActiveRecord::Migration
  def change
    create_table :event_option_types do |t|
      t.string :title
      t.text :description
      t.boolean :active , :default => true
      t.timestamps
    end
  end
end
