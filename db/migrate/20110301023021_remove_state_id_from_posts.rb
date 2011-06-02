class RemoveStateIdFromPosts < ActiveRecord::Migration
  def self.up
    remove_column :posts, :state_id
  end

  def self.down
    add_column :posts, :state_id, :integer
  end
end
