class Photo < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
  
  ## Associations
  belongs_to :user, optional: true
end
