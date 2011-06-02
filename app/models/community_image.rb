# == Schema Information
# Schema version: 20110310040654
#
# Table name: community_images
#
#  id                 :integer         not null, primary key
#  community_id       :integer
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class CommunityImage < ActiveRecord::Base
  
  belongs_to :community
  
  has_attached_file :image, 
      :styles => {
        :thumb => '150x150>',
        :medium => '300x300>',
        :large => '600x600>'    
      },
      :storage => :s3,
      :s3_credentials => "#{Rails.root.to_s}/config/s3.yml",
      :path => "community_images/:id/:style_:extension"
end
