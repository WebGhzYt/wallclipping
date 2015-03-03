class Message
  include Mongoid::Document
  include Mongoid::Timestamps
   belongs_to :user
   belongs_to :circle

   field :message
   validates_presence_of :message
   field :friend_id, :type => String
   field :read, :type => Boolean
   field :circle_id, :type => Moped::BSON::ObjectId
end
