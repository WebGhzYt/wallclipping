require 'open-uri'
require "digest/md5"
require 'carrierwave/processing/mini_magick'
class EventImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  after :store, :remove_original_file
  storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :convert => 'png'

  # Create different versions of your uploaded files:
  version :eventimage do
    process :resize_and_pad => [720, 540, "#ffffff", "Center"]
  end

  def remove_original_file(p)
    if self.version_name.nil?
      self.file.delete if self.file.exists?
    end
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
