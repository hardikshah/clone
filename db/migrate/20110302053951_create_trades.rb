class CreateTrades < ActiveRecord::Migration
  def self.up
    create_table :trades do |t|
      t.string :description
      t.integer :post_id
      t.integer :user_id
      t.string :email
      t.boolean :poster_read_flag
      t.boolean :trader_read_flag
      t.boolean :active, :default => false
      t.string :activation_hash

      t.timestamps
    end
    add_index :trades, :post_id
    add_index :trades, :user_id
  end

  def self.down
    drop_table :trades
  end
end
