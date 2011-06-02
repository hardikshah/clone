# == Schema Information
# Schema version: 20110227182819
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  first_name         :string(255)
#  last_name          :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  active             :boolean
#  activation_hash    :string(255)
#  activated_at       :datetime
#  admin              :boolean
#

# eventually for sending emails
# require 'mailgun'

class User < ActiveRecord::Base
  include EncryptionMethods
  
  # virtual attribute for the password that is not in the database
  attr_accessor :password
  
  #define the accessible attributes that can be updated
  attr_accessible :first_name, :last_name, :email, 
                  :password, :password_confirmation
  
  has_many :posts, :dependent => :destroy
  has_many :trades, :dependent => :destroy
  has_many :trade_posts,  :through => :trades,
                          :source => :post

  # user community associations
  has_many :user_community_relationships,
                          :dependent => :destroy
  has_many :communities, :through => :user_community_relationships

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :first_name,  :presence     => true,
                          :length       => { :maximum => 50 }
  validates :last_name,   :presence     => true,
                          :length       => { :maximum => 50 }
  validates :email,       :presence     => true,
                          :format       => { :with => email_regex },
                          :uniqueness   => { :case_sensitive => false }
  validates :password,    :presence     => true,
                          :confirmation => true,
                          :length       => { :within => 6..40 },
                          :if           => :password_required?

  before_create :make_activation_hash
  before_save :encrypt_password

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email,submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  def active?
    active
  end
  
  def activate!
    self.active = true
    self.activated_at = Time.now.utc
    self.activation_hash = nil
    save(:validate => false)
  end
  
  def join_community!(community)
    user_community_relationships.create!(:community_id => community.id)
  end
  
  def leave_community!(community)
    user_community_relationships.find_by_community_id(community).destroy
  end
  
  def member_of_community?(community)
    user_community_relationships.find_by_community_id(community)
  end

  private
  
    def password_required?
      self.encrypted_password.blank? || !password.blank?
    end
  
    def make_activation_hash
      self.activation_hash = secure_hash((('a'..'z').to_a+('A'..'Z').to_a+
                                          ('0'..'9').to_a).shuffle.join)
    end

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password) unless password.blank?
    end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

end
