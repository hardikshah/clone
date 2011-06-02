# == Schema Information
# Schema version: 20110512005435
#
# Table name: post_community_relationships
#
#  id           :integer         not null, primary key
#  post_id      :integer
#  community_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class PostCommunityRelationship < ActiveRecord::Base
  
  belongs_to :post
  belongs_to :community
  
  validates :post_id,   :presence => true
  validates :community_id,   :presence => true
end
