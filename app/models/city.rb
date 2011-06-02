# == Schema Information
# Schema version: 20110301021055
#
# Table name: cities
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  state_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class City < ActiveRecord::Base
  
  belongs_to :state
  has_many :posts
  
  default_scope :order => 'cities.name ASC'
end
