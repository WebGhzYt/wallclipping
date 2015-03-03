ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do

   columns do
     column do
       panel "Stats" do
         div do
           "Number of members:  #{User.count}"
         end
         div do
           "Number of signups today: #{User.where(:created_at => Time.now.all_day).count}"
         end
         div do
           "Number of signups this week: #{User.where(:created_at => Time.now.all_week).count}"
         end
         div do
           "Number of signups this month: #{User.where(:created_at => Time.now.all_month).count}"
         end
         div do
           div do
            "Number of posts today: #{Feed.where(:created_at => Time.now.all_day).count}"
           end
           div do
             "Status: #{Feed.where(:created_at  => Time.now.all_day, :feed_type_id => FeedType.where(:post_type => 'Status').first.id).count}"
           end
           div do
             "File: #{Feed.where(:created_at => Time.now.all_day, :feed_type_id => FeedType.where(:post_type => 'File').first.id).count}"
           end
           # div do
           #   "Video: #{Feed.where(:created_at => Time.now.all_day, :feed_type_id => FeedType.where(:post_type => 'Video').first.id).count}"
           # end
           div do
             "Event: #{Feed.where(:created_at => Time.now.all_day, :feed_type_id => FeedType.where(:post_type => 'Event').first.id).count}"
           end
           div do
             "Deals: #{Feed.where(:created_at => Time.now.all_day, :feed_type_id => FeedType.where(:post_type => 'Deal').first.id).count}"
           end
         end
         div do
           "Number of total posts: #{Feed.count}"
         end
       end
     end
   end

  end # content
end
