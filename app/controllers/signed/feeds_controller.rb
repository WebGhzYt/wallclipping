require 'oembed'
class Signed::FeedsController < Signed::BaseController

  before_filter :set_flashes_to_null, :check_authentication

  def index
    @title = nil
    @limit = 15
    latest = params[:last_feed] || Time.now
    all_session=current_user.present? ? session_all : []

    if params[:filter]
      sub_cat = SubCategory.where(:name => params[:filter]).first
    end

    case params[:feed_type]
    when "latest_news_feeds"
      if sub_cat.nil?
         @feeds = Feed.desc("updated_at").limit(@limit).where(:user_id.ne => current_user.id, :channels.in => all_session, :updated_at.lt => latest).entries
      else
         @feeds = sub_cat.feeds.desc("updated_at").limit(@limit).where(:user_id.ne => current_user.id, :channels.in => all_session, :updated_at.lt => latest).entries
      end
      @title = "Connection Feed"
      @last_feed = @feeds.last.updated_at unless @feeds.empty?
    
    when "my_posts"
      if sub_cat.nil?
       @feeds = Feed.desc("updated_at").limit(@limit).where(:user_id => current_user.id, :updated_at.lt => latest ).entries
      else
       @feeds = sub_cat.feeds.desc("updated_at").limit(@limit).where(:user_id => current_user.id, :updated_at.lt => latest ).entries
      end  
      @title = "My Posts"
      @last_feed = @feeds.last.updated_at unless @feeds.empty?

    when "circle"
      @circle = Circle.find(params[:circle_id])
      if sub_cat.nil?
        @feeds = Feed.desc("updated_at").limit(@limit).where(:channels.in => [@circle.id.to_s], :updated_at.lt => latest).entries
      else
        @feeds = sub_cat.feeds.desc("updated_at").limit(@limit).where(:channels.in => [@circle.id.to_s], :updated_at.lt => latest).entries
      end  
      @title = @circle.name.capitalize
      @last_feed = @feeds.last.updated_at unless @feeds.empty?

    when "chronicle"
      @chronicle = Chronicle.find(params[:chronicle_id])
      if sub_cat.nil?
      @feeds = Feed.desc("updated_at").limit(@limit).where(:channels.in => [@chronicle.id.to_s], :updated_at.lt => latest ).entries
      else
      @feeds = sub_cat.feeds.desc("updated_at").limit(@limit).where(:channels.in => [@chronicle.id.to_s], :updated_at.lt => latest ).entries
      end  
      @title = @chronicle.chronicle_title.capitalize
      @status = (@chronicle.user_id.to_s == current_user.id.to_s) ? true : false
      @last_feed = @feeds.last.updated_at unless @feeds.empty?

    when "connections"
      @connection = Connection.find(params[:connection_id])
      users = []
      UserFriend.where(:connection_id => @connection.id.to_s).each do |user|
        users << user.friend_id.to_s
      end
      users.uniq!
      if sub_cat.nil?
        @feeds = Feed.desc("updated_at").limit(@limit).where(:channels.in => users + [@connection.id.to_s], :updated_at.lt => latest).entries
      else
        @feeds = sub_cat.feeds.desc("updated_at").limit(@limit).where(:channels.in => users + [@connection.id.to_s], :updated_at.lt => latest).entries
      end  
      @title = @connection.category_title.capitalize
      @last_feed = @feeds.last.updated_at unless @feeds.empty?
      
    when "Favorites"
      @feeds = []
      emotion = Emotion.find(params[:type_id])
      @feed_type = FeedType.first
      user_feeds = UserFeed.desc("updated_at").limit(@limit).where(:emotion_id => emotion.id, :favorite => true,:user_id => current_user.id, :updated_at.lt => latest)
      if sub_cat.nil?
        user_feeds.each do |feed|
          @feeds << feed.feed
        end
      else
        user_feeds.each do |feed|
          if feed.feed.sub_category_id == sub_cat.id
            @feeds << feed.feed
          end
        end
      end
      @title = "Favorites - #{emotion.name}"
      @last_feed = @feeds.last.updated_at unless @feeds.empty?
    
    else
       if sub_cat.nil?
       @feeds = Feed.desc("updated_at").limit(@limit).where(:channels.in => all_session, :updated_at.lt => latest).entries
       else
       @feeds = sub_cat.feeds.desc("updated_at").limit(@limit).where(:channels.in => all_session, :updated_at.lt => latest).entries
       end  
     
      @last_feed = @feeds.last.updated_at unless @feeds.empty?
      @title = "All News feed"
    end
    @feed_types = FeedType.all
    @message = Message.new
    @sub_categories = sub_category
  end

  def create
    if params[:feed].present?
      @feed = Feed.create!(params[:feed])
      
      if params[:feed_photo_id].present?
        feed_image = FeedImage.find(params[:feed_photo_id])
        feed_image.update_attribute(:feed_id, @feed.id)
      elsif params[:event_photo_id].present?
        event_image = EventImage.find(params[:event_photo_id])
        event_image.update_attribute(:feed_id, @feed.id)
        if params[:is_photo]=="true"
          @feed.feed_hash["video"] = nil
          @feed.save!
        else
          event_image.remove_eventimage!
          event_image.destroy
        end
      elsif params[:deal_photo_id].present?
        deal_image = DealImage.find(params[:deal_photo_id])
        deal_image.update_attribute(:feed_id, @feed.id)
        if params[:is_photo]=="true"
          @feed.feed_hash["video"] = nil
          @feed.save!
        else
          deal_image.remove_dealimage!
          deal_image.destroy
        end
      end
      
      feed_type = FeedType.find(params[:feed][:feed_type_id])
      if feed_type.post_type == 'Status' and params[:feed][:add_link].present? 
        unless params[:feed][:add_link].include?("http://")
          @feed.update_attributes(:add_link => "http://"+params[:feed][:add_link])
        end
      end
    end
  end

  def create_photo
    if params[:feed_image].present?
      unless params[:feed_photo_id].blank?
        begin
          previous_feed_image = FeedImage.find(params[:feed_photo_id])
          previous_feed_image.remove_feedimage!
          previous_feed_image.destroy
        rescue
          render :js => "alert('Request Failed. Please try again.');$('#loader').hide();"
        end
      end
      begin
        @feed_image = FeedImage.create!(params[:feed_image])
      rescue
        render :js => "$('.file_format_notice').html('Unsupported file format. You can only upload PDF, DOC. DOCX, HTML, TXT, CSV, XLS file type.');$('#loader').hide();"
      end 
    end

    if params[:event_image].present?
      @event_image = EventImage.create!(params[:event_image])
    end
    
    if params[:deal_image].present?
      @deal_image = DealImage.create!(params[:deal_image])
    end
  end

  def fetch_form
     @feed = Feed.new(:feed_type_id => params["select_id"])
     @feed_image = @feed.build_feed_image
     @event_image = @feed.build_event_image
     @deal_image = @feed.build_deal_image
     @feed_type = FeedType.where("_id" => params["select_id"]).first unless params[:select_id].nil?
     @feed_type = FeedType.first if params[:select_id].nil?
     @chronicle = Chronicle.where("_id" => params[:chronicle_id]).first if params[:chronicle_id].present?
     @circle = Circle.where("_id" => params[:circle_id]).first if params[:circle_id].present?
     @sub_categories = sub_category
  end

  def fetch_friends
    @friends = current_user.my_friends.collect{|f| [f.id, f.first_name ]}
  end

  def add_comment
   @feed = Feed.where("_id" => params[:feed_id]).first
   @comment = @feed.comments.create(:user_id => current_user.id, :comment => params[:comment], :rating => params[:comment_mood_id], :visibility => params[:visibility]) if @feed
   if @comment
     if params[:visibility] == "2"
      commenter_ids = params[:commenter_ids].split(',')
      commenter_ids.each do |commenter_id|
        @comment_privacy = @comment.comment_privacies.create(:comment_id => @comment.id, user_id: commenter_id)  
      end
     end
    end 
  end

  def feed_tag
    begin
      @feed = Feed.find(params[:feed_id])
    rescue
      @feed = false
    end
    update_tag = params[:update_tag]
    if @feed
      feed_user = UserFeed.where("user_id" => current_user.id, "feed_id" => @feed.id).first
      if !feed_user
        @feed.user_feeds.create((update_tag.merge :user_id => current_user.id).merge :feed_type_id => @feed.feed_type_id)
      else
        feed_user.update_attributes(update_tag)
      end
    end
  end

  def emotions_tag
    begin
      @feed = Feed.find(params[:feed_id])
    rescue
      @feed = false
    end
    update_tag = params[:update_tag]
    if @feed
      feed_user = UserFeed.where("user_id" => current_user.id, "feed_id" => @feed.id).first
      if !feed_user
        @feed.user_feeds.create((update_tag.merge :user_id => current_user.id).merge :emotion_id => params[:type_id], :emotion_color => params[:color])
      else
        feed_user.update_attributes(update_tag.merge :emotion_id => params[:type_id], :emotion_color => params[:color])
      end
    end
    render :action => :feed_tag
  end
  def deletepost
    begin
      @feed = Feed.where("_id" => params[:feed_id]).first
    rescue
      @feed = false
    end
    case params[:type]
     when "delete"
       if @feed
         @feed.destroy
       end
     when "hide"
       if @feed
         feed_user = UserFeed.where("user_id" => current_user.id, "feed_id" => @feed.id)
         if feed_user.empty?
           @feed.user_feeds.create(:user_id => current_user.id, :hidden => true )
         else
           feed_user.last.update_attributes(:hidden => true)
         end
       end
     when "abuse"
       if @feed
          feed_user = UserFeed.where("user_id" => current_user.id, "feed_id" => @feed.id)
         if feed_user.empty?
           @feed.user_feeds.create(:user_id => current_user.id, :abuse => true )
           @feed.update_attributes(:feed_count => @feed.feed_count.to_i + 1 )
         else
           feed_user.last.update_attributes(:abuse => true)
           @feed.update_attributes(:feed_count => @feed.feed_count.to_i + 1 )
         end
       end
    end
  end
  def deletecomment
    @feed = Feed.where("_id" => params[:feed_id]).first
    @feed.comments.where("_id" => params[:comment_id]).last.destroy
  end

  def pdf
    file_name = params[:feed_image_path].split('/').last
    # @filename = "#{Rails.root}/public/uploads/feed_image/feedimage/#{file_name}"
    @filename = Rails.root.join('public', 'uploads', 'feed_image', 'feedimage', file_name)
    send_file(@filename ,
      :type => ['application/pdf', 'application/doc', 'application/docx', 'application/html',
       'application/htm', 'application/csv', 'application/xls', 'application/txt'],
      :disposition => 'attachment')           
  end

end
