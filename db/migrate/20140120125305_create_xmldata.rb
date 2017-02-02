class CreateXmldata < ActiveRecord::Migration
  def change
    create_table :xmldata do |t|
      t.text :datafeed

      t.timestamps
    end
  end
end
