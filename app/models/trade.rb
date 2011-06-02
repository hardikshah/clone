# == Schema Information
# Schema version: 20110302061550
#
# Table name: trades
#
#  id               :integer         not null, primary key
#  post_id          :integer
#  user_id          :integer
#  email            :string(255)
#  poster_read_flag :boolean
#  trader_read_flag :boolean
#  active           :boolean
#  activation_hash  :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  content          :string(255)
#  activated_at     :datetime
#

class Trade < ActiveRecord::Base
  include EncryptionMethods
  
  attr_accessible :content, :email

  # Trades belong to both users and posts
  belongs_to :user
  belongs_to :post

  # A trade has many trade messages
  has_many :trade_messages, :dependent => :destroy

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :content, :presence => true, :length => { :maximum => 255 }
  validates :user_id, :presence => true, :if => :registered_trade?
  validates :email, :presence => true, 
                    :format => { :with => email_regex },
                    :if => :nonregistered_trade?

  before_create :set_activation
  
  scope :active, where(:active => true)
  default_scope :order => 'trades.created_at DESC'


  def activate!
    save(:validate => false)
  end
  
  private
    
    def nonregistered_trade?
      user_id.nil?
    end
    
    def registered_trade?
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
