class ChangeCommunityRenameActiveAtColumn < ActiveRecord::Migration
  def self.up
    remove_column :communities, :active_at
    add_column :communities, :activated_at, :datetime
  end

  def self.down
    add_column :communities, :activate_at, :datetime
    remove_column :communities, :actived_at
  end
end
