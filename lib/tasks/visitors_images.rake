namespace :visitors_images do
  desc "Destroying visitors uploaded images. To run use 'rake visitors_images:destroy_images' command"
  task destroy_images: :environment do
    Photo.where(user_id: nil).destroy_all
  end
end
