# == Schema Information
# Schema version: 20110315202222
#
# Table name: user_community_relationships
#
#  id           :integer         not null, primary key
#  user_id      :integer
#  community_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class UserCommunityRelationship < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :community
  
  validates :user_id,   :presence => true
  validates :community_id,   :presence => true
end
