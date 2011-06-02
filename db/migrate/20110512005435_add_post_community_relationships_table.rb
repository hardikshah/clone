class AddPostCommunityRelationshipsTable < ActiveRecord::Migration
  def self.up
    create_table :post_community_relationships do |t|
      t.integer :post_id
      t.integer :community_id

      t.timestamps
    end
    add_index :post_community_relationships, :post_id
    add_index :post_community_relationships, :community_id
    add_index :post_community_relationships, 
                                  [:post_id, :community_id], :unique => true
  end

  def self.down
    drop_table :post_community_relationships
  end
end
