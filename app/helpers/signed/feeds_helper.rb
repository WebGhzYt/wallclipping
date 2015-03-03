module Signed::FeedsHelper

  def feeds_acordion_hash
    {"Connections" => [], "Circles" => [], "Chronicles" => []}
  end

  def cool_status feed
    count =  UserFeed.where(:feed_id => feed.id, 'cool' => true).count
    count = (count == 0) ? " " : count
    ret = ''
    if current_user.user_feeds.where(:feed_id => feed.id, 'cool' => true).empty?
     # img = image_tag "/img/coolpinshare/like.png", :title => "Heart-it"
    #  ret = link_to(img + " " + "Heart-it", feed_tag_signed_feeds_path(:feed_id => feed.id.to_s, :update_tag => {"cool" => true}), :remote => true)
    else
   #   img = image_tag '/img/coolpinshare/like.png', :title => "Unheart"
   #   ret = link_to(img + " " + "Unheart", feed_tag_signed_feeds_path(:feed_id => feed.id.to_s, :update_tag => {"cool" => false}), :remote => true)
    end
    content_tag(:span, ret + "  "+ count.to_s, :style => "font-size:12px;", :id => "#{feed.id.to_s}_cool", :ajax_call => true)
  end

  def favorite_status feed
    ret = ''
    count =  UserFeed.where(:feed_id => feed.id, 'favorite' => true).count
    count = (count == 0) ? " " : count
    
    
    if current_user.user_feeds.where(:feed_id => feed.id, 'favorite' => true).empty?
      img = image_tag "/img/coolpinshare/pin.png", :title => "Mind it"
      ret = link_to(img + " " + "Fave-it", "#", "data-toggle" => "modal", "data-target" => "#myemotionsModal", :onclick => "emotionId = '#{feed.id.to_s}'; emotionHash = #{feed.emotion_hash.to_json}; setEmotionCounter();")
    else
      img = image_tag '/img/coolpinshare/pin.png', :title => "Minded"
     ret = link_to(img + " " + "Unfave-it", feed_tag_signed_feeds_path(:feed_id => feed.id.to_s, :update_tag => {"favorite" => false}), :remote => true)
    end
    content_tag(:span, ret.to_s + "  "+ count.to_s, :style => "font-size:12px;", :id => "#{feed.id.to_s}_favorite", :ajax_call => true)
  end

  def shared_status feed
    ret = ''
    count =  UserFeed.where(:feed_id => feed.id, 'shared' => true).count
    count = (count == 0) ? " " : count
    if feed.user == current_user and feed.public
      ret = (image_tag "/img/coolpinshare/share.png") + " " + "Feed all"
    elsif feed.public and count.to_i< 1000
      if current_user.user_feeds.where(:feed_id => feed.id, 'shared' => true).empty?
        img = image_tag "/img/coolpinshare/share.png", :title => "Feed all"
        ret = link_to(img + " " + "Feed all", feed_tag_signed_feeds_path(:feed_id => feed.id.to_s, :update_tag => {"shared" => true}), :remote => true)
      else
        img = image_tag "/img/coolpinshare/share.png", :title => "Fed"
        ret = link_to(img + " " + "Fed", feed_tag_signed_feeds_path(:feed_id => feed.id.to_s, :update_tag => {"shared" => false}), :remote => true)
      end
    end
    content_tag(:span, ret.to_s + "  "+ count.to_s, :style => "font-size:12px;", :id => "#{feed.id.to_s}_shared", :ajax_call => true)
  end
end
