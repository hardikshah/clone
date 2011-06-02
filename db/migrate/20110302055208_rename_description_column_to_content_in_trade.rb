class RenameDescriptionColumnToContentInTrade < ActiveRecord::Migration
  def self.up
    remove_column :trades, :description
    add_column :trades, :content, :string
  end

  def self.down
    add_column :trades, :description, :string
    remove_column :trades, :content
  end
end
