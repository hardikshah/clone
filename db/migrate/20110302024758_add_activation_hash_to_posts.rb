class AddActivationHashToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :activation_hash, :string
    add_column :posts, :activated_at, :datetime
  end

  def self.down
    remove_column :posts, :activation_hash
    remove_column :posts, :activated_at
  end
end
