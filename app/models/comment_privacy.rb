class CommentPrivacy
  include Mongoid::Document
  belongs_to :user
  belongs_to :comment
end
