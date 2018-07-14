class PhotosController < ApplicationController
  before_action :find_photo, only: [:edit_metadata, :update_metadata]

  def index
    @photos = current_user.photos
  end

  def new
    @photo = current_user.photos.new
  end

  def create
    @photo = current_user.photos.build(photo_params)

    if @photo.save
      flash[:success] = "Image uploaded successfully!"
      redirect_to photos_path
    else
      flash[:error] = @photo.errors.full_messages
      render 'new'
    end
  end

  def edit_metadata
  end

  def update_metadata
    # @image.iso = "this is iso"
    # @image.f_number = "this is f_number"
    @image.title = params[:title]
    @image.comment = params[:comment]
    @image.user_comment= params[:user_comment]

    if @image.save
      flash[:success] = "Metadata updated Successfully."
      redirect_to photos_path
    else
      flash.now[:error] = @image.errors.map{|k,v| "#{k.titleize}: #{v}"}.join(", ")
      render 'edit_metadata'
    end
  end

  private

  def photo_params
    params.require(:photo).permit(:avatar)
  end

  def find_photo
    @photo = current_user.photos.find_by_id(params[:id])
    unless @photo.present?
      flash[:error] = "Image not found!"
      redirect_back fallback_location: root_path
    end
    @image = MiniExiftool.new @photo.avatar.path
  end
end
