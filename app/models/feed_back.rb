class FeedBack
  include Mongoid::Document
  field :email, type: String
  field :message, type: String

  validates_presence_of :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
  validates_presence_of :message
end
