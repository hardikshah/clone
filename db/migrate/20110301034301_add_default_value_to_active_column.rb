class AddDefaultValueToActiveColumn < ActiveRecord::Migration
  def self.up
    remove_column :posts, :active
    add_column :posts, :active, :boolean, :default => false
  end

  def self.down
    remove_column :posts, :active
    add_column :posts, :active, :boolean
  end
end
