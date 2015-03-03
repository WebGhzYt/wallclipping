# encoding: utf-8
require 'carrierwave'

CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',       # required
    :aws_access_key_id      => 'AKIAIP7K2K2JB76ITI3Q', # required
    :aws_secret_access_key  => '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', # required
    :region                 => 'us-east-1'  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = 'recommendone-aws'                     # required
  #config.fog_host       = 'https://s3.amazonaws.com'
  config.fog_public     = true # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}

end
