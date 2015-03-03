ActiveAdmin.register FeedBack do

  config.clear_action_items!

  filter :email, :as => :string
  filter :message, :as => :string

  index do
    column :email
    column :message
    column "Actions" do |feed_back|
      span link_to "View", admin_feed_back_path(feed_back)
    end
  end

  show do
    attributes_table :email,:message
  end
  
end
