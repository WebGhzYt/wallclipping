require 'open-uri'
require "digest/md5"
require 'carrierwave/processing/mini_magick'

class MoreReasonPopupUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :convert => 'png'

  version :more_reason_popup_image do
    process :resize_to_fill => [960, 720]
  end

  # def default_url
  #   "#{root_url + 'assets/more_reasons_popup_image.jpg'}"
  # end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
