class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :title
      t.string :description
      t.string :trade_for
      t.integer :city_id
      t.integer :state_id
      t.string :email_address
      t.integer :user_id

      t.timestamps
    end
    add_index :posts, :user_id
    add_index :posts, :city_id
    add_index :posts, :state_id
  end

  def self.down
    drop_table :posts
  end
end
