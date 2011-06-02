# == Schema Information
# Schema version: 20110302024758
#
# Table name: posts
#
#  id              :integer         not null, primary key
#  title           :string(255)
#  description     :string(255)
#  trade_for       :string(255)
#  city_id         :integer
#  user_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#  active          :boolean
#  email           :string(255)
#  activation_hash :string(255)
#  activated_at    :datetime
#

class Post < ActiveRecord::Base
  include EncryptionMethods

  attr_accessible :title, :description, :trade_for, 
                  :email, :city_id, :post_images_attributes
  attr_accessible :category_ids
  attr_accessible :community_ids

  belongs_to :user
  belongs_to :city
  has_many :trades, :dependent => :destroy

  has_many :traders,  :through => :trades,
                      :source => :user

  # user community associations
  has_many :post_community_relationships,
                          :dependent => :destroy
  has_many :communities, :through => :post_community_relationships

  # switch to has_many :through
  has_and_belongs_to_many :categories

  has_many :post_images
  accepts_nested_attributes_for :post_images, :allow_destroy => true

  validates :title, :presence => true, :length => { :maximum => 100 }
  validates :description, :presence => true, :length => { :maximum => 255 }
  validates :trade_for, :length => { :maximum => 255 }
  validates :user_id, :presence => true, :if => :registered_post?
  validates :email, :presence => true, :if => :nonregistered_post?
  validates :city_id, :presence => true
  validates :category_ids, :category_count => true

  scope :active, where(:active => true)
  default_scope :order => 'posts.created_at DESC'
  
  before_create :set_activation

  def activate!
    self.active = true
    self.activated_at = Time.now.utc
    self.activation_hash = nil
    save(:validate => false)
  end
  
  def self.search(query)
    if !query.to_s.strip.blank?
      search_condition = "%" + query.to_s.strip.downcase + "%"
      find(:all, :conditions => ['lower(title) LIKE ? OR lower(description) LIKE ?', search_condition, search_condition])
    else
      find(:all)
    end
  end
  
  private

    def nonregistered_post?
      user_id.nil?
    end
    
    def registered_post?
      email.nil?
    end

    def set_activation
      unless user_id.nil?
        self.active = true
        self.activated_at = Time.now.utc
        self.activation_hash = nil
      else
        self.activation_hash = create_activation_hash
      end
    end

end
