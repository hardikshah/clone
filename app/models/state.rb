# == Schema Information
# Schema version: 20110301021055
#
# Table name: states
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  abbreviation :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class State < ActiveRecord::Base
  
  has_many :cities
  
  validates :name,  :presence     => true,
                    :length       => { :maximum => 50 },
                    :uniqueness   => { :case_sensitive => false }
  validates :abbreviation,  :presence     => true,
                            :length       => { :maximum => 2 },
                            :uniqueness   => { :case_sensitive => false }
  
  default_scope :order => 'states.name ASC'
end
