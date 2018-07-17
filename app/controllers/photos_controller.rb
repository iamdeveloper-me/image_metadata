class PhotosController < ApplicationController
  before_action :find_photo, only: [:destroy, :edit_metadata, :update_metadata, :download]
  before_action :find_photo_metadata, only: [:edit_metadata, :update_metadata]

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

  def destroy
    @photo.destroy
    flash[:success] = "Photo destroyed successfully."
    redirect_to photos_path
  end

  def edit_metadata
  end

  def update_metadata
    # Method to assign metadata to photo.
    assign_metadata

    if @image.save
      flash[:success] = "Metadata updated Successfully."
      redirect_to photos_path
    else
      flash.now[:error] = @image.errors.map{|k,v| "#{k.titleize}: #{v}"}.join(", ")
      render 'edit_metadata'
    end
  end

  def download
    send_file(
      @photo.avatar.path,
      filename: @photo.avatar.file.filename # ,
      # type: "image/png"
    )
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
  end

  def find_photo_metadata
    @image = MiniExiftool.new @photo.avatar.path
  end

  def assign_metadata
    @image.title = params[:title]
    @image.creator = params[:creator]
    @image.description = params[:description]
    @image.city = params[:city]
    @image.state = params[:state]
    @image.country = params[:country]
    @image.comment = params[:comment]
    @image.user_comment = params[:user_comment]
    @image.make = params[:make]
    @image.model = params[:model]
    @image.artist = params[:artist]
    @image.owner_name = params[:owner_name]
    @image.copyright = params[:copyright]
    @image.image_description = params[:image_description]
    @image.gps_latitude = params[:gps_latitude]
    @image.gps_longitude = params[:gps_longitude]
  end
end
