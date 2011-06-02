class CreateTradeMessages < ActiveRecord::Migration
  def self.up
    create_table :trade_messages do |t|
      t.integer :trade_id
      t.string :message
      t.boolean :from_trader

      t.timestamps
    end
    add_index :trade_messages, :trade_id
  end

  def self.down
    drop_table :trade_messages
  end
end
