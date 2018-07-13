class PhotosController < ApplicationController

  def index
    @photos = current_user.photos
  end

  def new
    @photo = current_user.photos.new
  end

  def create
    @photo = current_user.photos.build(photo_params)
    # binding.pry
    if @photo.save
      flash[:success] = "Image uploaded successfully!"
      redirect_to photos_path
    else
      flash[:error] = @photo.errors.full_messages
      render 'new'
    end
  end

  private

  def photo_params
    params.require(:photo).permit(:image)
  end
end
