Relayfan::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  root :to => 'unsigned::home#register'

  match "/signed/users/manage/:form_type/:id" => "signed/users#manage", :as => :circle_edits
  match "/:controller/manage/:form_type/:id/:action/:sub_form", :as => :circle_edit
  match "/:controller/manage/:form_type/:circle_id/:id/:action/:sub_form", :as => :update_circle
  match "/auth/:provider/callback" => "unsigned/sessions#intermediate_fb_page"
  match "/signed/user/emotions_label" => "signed/users#emotions_label"
  match "/signed/feeds/pdf" => "signed/feeds#pdf"
 
  namespace :unsigned do
    resources :home do
      collection do
        get "verified", "about_us", "terms", "privacy_cookies", "help_center", "whats_new", "feed_back", "register", "registered_successfully", "help", "forgot_password", "forgot_username", "reasons" , "account_compromised", "account_com_update", "change_password", "set_password", "resend_email", "verify_email"#, "popular_questions"
        post "retreive", "account_compromised_retreive", "change_password_form", "resend_email_click", "create_user", "create_feed_back"
        put "change_password_form"
        get "reg_intermediate_page"
        post "reg_intermediate"
      end
    end
    resources :search, :only => [:index] do
      collection do
        get "fetch_hash_tags"
      end
    end
    resources :sessions, :only => [:create, :facebook_login] do
      collection do
        get "logout"
        post "facebook_login"
      end
    end
  end

  namespace :signed do
    resources :search, :only => [:index] do
      collection do
        get "fetch_hash_tags"
        get "connections"
        get "communities"
        get "channels"
      end
    end



    resources :users, :except => [:new, :create, :edit] do
     collection do
      get "manage", "account_form", "edit_detail", "hide_wall_detail", "delete", "set_order", "destroy_wall_image", "edit_category", "delete","block","unblock", "connection_types", "edit_circles", "hide_circle", "sort_about", "get_members", "get_circle", "delete_circle", "set_order", "add_circle_photos", "destroy_image", "delete_user", "approve_user", "reject_user", "unjoin_user", "edit_chronicles", "delete_chronicle", "unfollow_chronicle", "chronicle_content", "fetch_older_chronicles", "connection_content", "connection_replace","add_follow", "add_friend", "accept", "delete_friend", "not_now", "hide_all", "delete_all","join_request", "delete_connection", "get_circle_details", "about_circle", "circle_members", "circle_members_replace", "join_circle", "unjoin_circle"

      post "add_walls", "add_category_title", "add_circles_title", "add_circle_details", "add_chronicles_title"
      put "add_walls", "add_photos", "add_category_title", "add_circles_title", "add_circle_photos", "add_circle_details", "add_chronicles_title"
     end
    end
    resources :feeds do
      collection do
        get "fetch_form", "fetch_friends", "add_comment", "feed_tag", "deletepost", "emotions_tag", "deletecomment"
        post "create_photo"
      end
    end
    resources :messages do
      collection do
        get "friend_message","fetch_older_messages","deletemessage"
        post "createmessage_for_connections"
      end
   end
  end

end
