require 'open-uri'
require "digest/md5"
require 'carrierwave/processing/mini_magick'
class FeedImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  #after :store, :remove_original_file
  storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}"
  end

  #process :convert => 'pdf'
  #process :resize_to_fit => [800, nil]

  # Create different versions of your uploaded files:
  # version :feedimage do
  #   #process :resize_to_fit => [480, 300]
  #    process :resize_and_pad => [720, 540, "#ffffff", "Center"]
  # end

  # version :feedzoom do
  #   process :resize_to_fit => [800, nil]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  
  def extension_white_list
    %w(pdf doc htm html docx txt csv xls)
  end

  # def remove_original_file(p)
  #   if self.version_name.nil?
  #     self.file.delete if self.file.exists?
  #   end
  # end

  # Override the filename of the uploaded files:
  # see http://huacnlee.com/blog/carrierwave-upload-store-file-name-config/
#  def filename
#    if super.present?

#      @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
#      "#{@name}.#{file.extension.downcase}"
#    end
#  end


end

