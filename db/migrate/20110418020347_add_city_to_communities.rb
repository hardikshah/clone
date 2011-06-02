class AddCityToCommunities < ActiveRecord::Migration
  def self.up
    add_column :communities, :city_id, :integer
  end

  def self.down
    remove_column :communities, :city_id
  end
end
