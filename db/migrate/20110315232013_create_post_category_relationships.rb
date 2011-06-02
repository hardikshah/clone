class CreatePostCategoryRelationships < ActiveRecord::Migration
  def self.up
    create_table :post_category_relationships do |t|
      t.integer :post_id
      t.integer :category_id

      t.timestamps
    end
    add_index :post_category_relationships, :post_id
    add_index :post_category_relationships, :category_id
    add_index :post_category_relationships, 
                                  [:post_id, :category_id], :unique => true
    
  end

  def self.down
    drop_table :post_category_relationships
  end
end
