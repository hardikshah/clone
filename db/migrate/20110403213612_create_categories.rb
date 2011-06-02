class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name
      t.string :description
      t.string :category_type

      t.timestamps
    end
    add_index :categories, :category_type
  end

  def self.down
    drop_table :categories
  end
end
