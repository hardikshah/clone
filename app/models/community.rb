# == Schema Information
# Schema version: 20110420032940
#
# Table name: communities
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  description     :string(255)
#  active          :boolean
#  url             :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  activated_at    :datetime
#  city_id         :integer
#  membership_type :string(255)
#

class Community < ActiveRecord::Base
  attr_accessible :name, :description, :community_images_attributes
  
  has_many :users
  has_many :community_images
  accepts_nested_attributes_for :community_images, :allow_destroy => true

  validates :name, :presence => true, :length => { :maximum => 255 }
  validates :description, :presence => true, :length => { :maximum => 255 }

  scope :active, where(:active => true)
  default_scope :order => 'communities.name ASC'
  
  before_create :set_activation
  
  def activate!
    self.active = true
    self.activated_at = Time.now.utc
    save(:validate => false)
  end
  
  private
  
    def set_activation
      self.active = false
      return true
    end
  
end
