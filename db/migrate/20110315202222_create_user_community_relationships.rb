class CreateUserCommunityRelationships < ActiveRecord::Migration
  def self.up
    create_table :user_community_relationships do |t|
      t.integer :user_id
      t.integer :community_id

      t.timestamps
    end
    add_index :user_community_relationships, :user_id
    add_index :user_community_relationships, :community_id
    add_index :user_community_relationships, 
                                  [:user_id, :community_id], :unique => true
    
  end

  def self.down
    drop_table :user_community_relationships
  end
end
