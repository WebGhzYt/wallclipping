class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
   embedded_in :feed
   belongs_to :user
   belongs_to :comment_mood

   field :comment
   field :rating, :type => Integer
   field :hash_tags, type: Array
   field :visibility, :type => Integer

   has_many :comment_privacies, validate: false

   validates_presence_of :comment
   
   after_create :update_parent, :set_hash_tags
   after_save :set_biased
   
   def update_parent
     feed = self.feed
     feed.updated_at = Time.now
     feed.save()
   end

   def set_hash_tags
     self.comment.scan(/\#\D\w+/).each do |tag|
       HashTag.find_or_create_by(:name => tag)
     end
   end
   
   def set_biased
    avg = feed.comments.collect(&:rating).sum.to_f/feed.comments.count
    feed.biased = avg.round()
    feed.save
   end
   

end
