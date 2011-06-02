class AddActivationHashToCommunity < ActiveRecord::Migration
  def self.up
    remove_column :communities, :activate_at
  end

  def self.down
    add_column :communities, :activate_at, :datetime
  end
end
