# == Schema Information
# Schema version: 20110303044055
#
# Table name: post_images
#
#  id                 :integer         not null, primary key
#  post_id            :integer
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class PostImage < ActiveRecord::Base
  
  belongs_to :post
  
  has_attached_file :image, 
      :styles => {
        :thumb => '150x150>',
        :medium => '300x300>',
        :large => '600x600>'    
      },
      :storage => :s3,
      :s3_credentials => "#{Rails.root.to_s}/config/s3.yml",
      :path => "post_images/:id/:style_:extension"
      
  
end
