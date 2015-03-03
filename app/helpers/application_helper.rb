module ApplicationHelper

  def fetch_filters
    case params[:model_type]
    when"Feed"
      FeedType.all.collect{|ft| [ft.post_type, ft.id]}
    when "User"
      UserType.all.collect{|ut| [ut.name, ut.id]}
    else
      []
    end
  end

  def account_setting_hash
    {"Account Management" => ["General", "Status","Fave_it"],  "My Wall Profile" => ["Create About me","Sort About me list", "Add Profile Photos"],  "Manage Connections" => [ "Create List names", "Lists Update"],   "Manage #{t(:circle)}" => ["Manage Social Circles", "Other's Edit", "Invite"],   "Manage Channels" => ["Manage Fan Pages", "Other's Edit"] }
  end

end
