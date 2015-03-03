class Feed
  include Mongoid::Document
  include Mongoid::Timestamps

  include Tire::Model::Search
  include Tire::Model::Callbacks

    has_one :feed_image, validate: false, :dependent => :destroy
    has_one :deal_image, validate: false, :dependent => :destroy
    has_one :event_image, validate: false, :dependent => :destroy
    accepts_nested_attributes_for :deal_image
    accepts_nested_attributes_for :feed_image
    accepts_nested_attributes_for :event_image
    has_many :user_feeds, validate: false, :dependent => :destroy

    embeds_many :comments
    belongs_to :user
    belongs_to :feed_type
    belongs_to :sub_category

    field :category
    field :title
    field :feed
    field :tag_user
    field :add_link
    field :public, type: Boolean
    field :feed_hash, type: Hash
    field :channels, type: Array
    field :tags, type: Array
    field :feed_count, type: Integer
    field :hash_tags, type: Array
    field :biased, type: Integer
    before_create :set_hash_tags_field
    after_create :set_feed_array, :set_tags_array, :set_hash_tags
    validates :feed, :presence => true, :on => :create
    before_save :title_upcase

    delegate :feedimage, to: :feed_image, allow_nil: true

    CATEGORY_TYPES = ["News", "Places", "Fashion", "Update", "Friend", "Entertainment", "Interest", "Q&A"]

    mapping do
      indexes :id, type: 'string'
      indexes :user_id, type: 'string'
      indexes :sub_category_id, type: 'string'
      indexes :feed_type_id, type: 'string'
      indexes :feed
      indexes :biased, type: 'integer'
      indexes :user_name
      indexes :sub_category do
        indexes :name, type: "string"
      end
      indexes :feed_type do
        indexes :post_type, type: "string"
      end
      indexes :add_link
      indexes :current_channels, type: 'string'
      indexes :public, type: 'boolean'
    end

    def to_indexed_json
        to_json(methods: [:user_name, :current_channels, :name, :post_type], except: [:_id,:user_id, :sub_category_id, :feed_type_id], include: { sub_category: { only: [:name] }, feed_type: { only: [:post_type]} })
    end

    def self.search(params)
      tire.search(page: params[:page], per_page: 10, load: true) do
        query do
          boolean do
            must { string params[:keyword] } if params[:keyword].present?
            must { term :public, true } unless params[:channels].present?
            should { string "public: true OR current_channels: #{params[:channels]}" } if params[:channels].present?
            must { term :biased, params[:filter] } if params[:filter].present?
            must { string params[:feed_type] } if params[:feed_type].present?
          end
        end
      end
    end

    def set_feed_array
      if !self.channels.nil?
        self.public = false
      else
        self.channels = []
        self.channels << self.user.id.to_s
      end
      self.save
    end

  def feed_images
       self.feed_image.feedimage_url(:feedimage)
  end
  
  def emotion_hash
    emotion_hash = {}
    (Emotion.order_by "order ASC").each do |emotion|
      emotion_hash.merge! emotion.id => UserFeed.where(:feed_id => self.id, 'favorite' => true, :emotion_id => emotion.id).count
    end
    emotion_hash
  end

  def feed_zooms
       self.feed_image.feedimage_url(:feedzoom)
  end

  def event_zooms
       self.event_image.eventimage_url(:eventimage)
  end

  def deal_zooms
       self.deal_image.dealimage_url(:dealimage)
  end

  def event_images
       self.event_image.eventimage_url(:eventimage)
  end

  def deal_images
       self.deal_image.dealimage_url(:dealimage)
  end

   def set_tags_array
     unless self.tag_user.nil?
       self.tags = self.tag_user.split(",").uniq
       self.save
     end
   end

  def user_name
    user.display_name.to_s + " " + user.first_name.to_s + " " +  user.last_name.to_s
  end

  def current_channels
    channels.collect{|c| c}.join(" ")
  end

  def set_hash_tags_field
    unless self.hash_tags.nil?
      self.hash_tags = self.hash_tags.split(",")
    end
  end

  def set_hash_tags
   unless self.hash_tags.nil?
     self.hash_tags.each do |ht|
       HashTag.find_or_create_by(:name => ht)
     end
    end
  end

  def title_upcase
    unless self.title.nil?
      self.title = self.title.upcase
    end
  end

  def comment_users(current_user_id)
    commenters = []
    self.user.first_name = "(o) "+self.user.first_name
    commenters << self.user
    self.comments.each do|comment|
      commenter = comment.user
      if commenter.id != current_user_id
        commenters << commenter
      elsif self.user.id == commenter.id
        commenters << commenter
      end
    end
    commenters.uniq
  end

end




