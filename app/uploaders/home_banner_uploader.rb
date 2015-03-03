require 'open-uri'
require "digest/md5"
require 'carrierwave/processing/mini_magick'

class HomeBannerUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :convert => 'png'

  version :home_banner_image do
    process :resize_to_fill => [420, 250]
  end

  def default_url
    "/img/home_banner.png"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
