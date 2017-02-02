class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.datetime :start_date
      t.datetime :end_date
      t.time :start_time
      t.time :end_time
      t.string :organizer
      t.string :locale, :default => 'en'
      t.string :timezone
      t.string :description
      t.string :logo
      t.string :reply_to_email
      t.integer :guest_count, :default => 0
      t.timestamps
    end
  end
end
