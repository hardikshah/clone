# == Schema Information
# Schema version: 20110406042827
#
# Table name: categories
#
#  id            :integer         not null, primary key
#  name          :string(255)
#  description   :string(255)
#  category_type :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class Category < ActiveRecord::Base
  attr_accessible :name, :description, :category_type
  
  has_and_belongs_to_many :posts
  
  validates :name,  :presence     => true,
                    :length       => { :maximum => 50 },
                    :uniqueness   => { :case_sensitive => false }
  validates :description, :presence => true,
                          :length   => { :maximum => 100 }
  validates :category_type, :presence => true
  validate :check_category_type


  def check_category_type
    errors.add(:base, "Category type must be valid") unless     
      (self.category_type == "Goods" || self.category_type == "Services")
  end


end
