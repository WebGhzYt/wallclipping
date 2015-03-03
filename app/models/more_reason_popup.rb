class MoreReasonPopup

  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Rails.application.routes.url_helpers

  field :more_reason_popup_image, type: String

  mount_uploader :more_reason_popup_image, MoreReasonPopupUploader

  attr_accessible :more_reason_popup_image
end