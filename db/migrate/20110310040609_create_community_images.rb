class CreateCommunityImages < ActiveRecord::Migration
  def self.up
    create_table :community_images do |t|
      t.integer :community_id

      t.timestamps
    end
  end

  def self.down
    drop_table :community_images
  end
end
