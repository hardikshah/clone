class AddMembershipTypeToCommunities < ActiveRecord::Migration
  def self.up
    add_column :communities, :membership_type, :string
  end

  def self.down
    remove_column :communities, :membership_type
  end
end
