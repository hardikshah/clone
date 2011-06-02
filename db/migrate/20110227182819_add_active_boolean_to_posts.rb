class AddActiveBooleanToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :active, :boolean
  end

  def self.down
    remove_column :posts, :active
  end
end
