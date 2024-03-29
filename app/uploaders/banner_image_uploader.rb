require 'open-uri'
require "digest/md5"
require 'carrierwave/processing/mini_magick'
class BannerImageUploader < CarrierWave::Uploader::Base
include CarrierWave::MiniMagick

  storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :convert => 'png'

  # Create different versions of your uploaded files:
  version :banner_image do
    process :resize_to_fill => [815, 351]
  end



  version :banner_image_thumb do
    process :resize_to_fill => [80, 50]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # see http://huacnlee.com/blog/carrierwave-upload-store-file-name-config/
  def filename
    if super.present?

      @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
      "#{@name}.#{file.extension.downcase}"
    end
  end


end
