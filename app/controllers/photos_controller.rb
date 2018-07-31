class PhotosController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :create, :destroy,
    :edit_metadata, :update_metadata, :download]
  before_action :check_visitors, only: [:new_image, :create_image, :edit_metadata_image,
    :update_metadata_image, :download_image]
  before_action :find_photo, only: [:destroy, :edit_metadata, :update_metadata, :download]
  before_action :find_visitors_photo, only: [:edit_metadata_image, :update_metadata_image,
    :delete_image, :download_image]
  before_action :find_photo_metadata, only: [:edit_metadata, :update_metadata,
    :edit_metadata_image, :update_metadata_image]

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
    process_destroy
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
    process_download_file
  end

  ## Start Actions for Visitors
  def new_image
    @photo = Photo.new
  end

  def create_image
    @photo = Photo.new(photo_params)

    if @photo.save
      flash[:success] = "Image uploaded successfully!"
      redirect_to edit_metadata_image_photo_path(@photo)
    else
      flash[:error] = @photo.errors.full_messages
      render 'new_image'
    end
  end

  def edit_metadata_image
  end

  def update_metadata_image
    # Method to assign metadata to photo.
    assign_metadata

    if @image.save
      flash[:success] = "Metadata updated Successfully."
      redirect_to edit_metadata_image_photo_path(@photo)
    else
      flash.now[:error] = @image.errors.map{|k,v| "#{k.titleize}: #{v}"}.join(", ")
      render 'edit_metadata_image'
    end
  end

  def download_image
    process_download_file
  end

  def delete_image
    process_destroy
    redirect_to root_path
  end
  ## End Actions for Visitors

  private

  def photo_params
    params.require(:photo).permit(:avatar)
  end

  def find_photo
    @photo = current_user.photos.find_by_id(params[:id])
    handle_photo_not_present
  end

  def find_visitors_photo
    @photo = Photo.find_by_id(params[:id])
    handle_photo_not_present
    if @photo.user.present?
      flash[:notice] = "You are not authorized."
      redirect_back fallback_location: root_path
    end
  end

  def handle_photo_not_present
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

  def check_visitors
    # If visitor(non-current-user), then only can go ahead.
    if current_user.present?
      flash[:notice] = "You are not authorized."
      redirect_to root_path
    end
  end

  def process_download_file
    send_file(
      @photo.avatar.path,
      filename: @photo.avatar.file.filename
    )
  end

  def process_destroy
    @photo.destroy
    flash[:success] = "Image destroyed successfully."
  end
end
