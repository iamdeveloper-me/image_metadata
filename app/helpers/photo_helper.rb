module PhotoHelper
  def create_url(photo, is_visitor)
    create_image_photos_path(photo) if is_visitor
  end

  def metadata_action(is_visitor)
    is_visitor ? 'update_metadata_image' : 'update_metadata'
  end
end
