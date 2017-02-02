class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :email
      t.string :first
      t.string :last
      t.string :gender
      t.string :user_id
      t.string :token
      t.string :profile_picture
      t.string :global_user_id
      t.boolean :staff  , :default => false
      t.string :account_id
      t.string :refresh_token
      t.timestamps
    end
  end
end
