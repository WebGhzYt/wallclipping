class HomeBanner
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Rails.application.routes.url_helpers

  field :home_banner_image, type: String
  mount_uploader :home_banner_image, HomeBannerUploader

  attr_accessible :home_banner_image

end