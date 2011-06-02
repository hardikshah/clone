class AddActivatedAtColumnToTrades < ActiveRecord::Migration
  def self.up
    add_column :trades, :activated_at, :datetime
  end

  def self.down
    remove_column :trades, :activated_at
  end
end
