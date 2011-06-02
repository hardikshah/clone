# == Schema Information
# Schema version: 20110303034043
#
# Table name: trade_messages
#
#  id          :integer         not null, primary key
#  trade_id    :integer
#  message     :string(255)
#  from_trader :boolean
#  created_at  :datetime
#  updated_at  :datetime
#

class TradeMessage < ActiveRecord::Base
  
  attr_accessible :message
  
  belongs_to :trade

  validates :message,   :presence     => true,
                        :length       => { :maximum => 255 }

  default_scope :order => 'trade_messages.created_at DESC'

end
