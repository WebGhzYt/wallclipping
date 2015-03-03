class Unsigned::HomeController < Unsigned::BaseController
  
    before_filter :set_flashes_to_null, :check_authentication, except: [ :about_us, :whats_new, :terms, :privacy_cookies, :help_center, :feed_back, :reg_intermediate]
  
  def index
  end
  
  def landing_page
  end

  def verified
  end
 
  def reasons
  end

  def registered_successfully
  end

  def resend_email
   flash[:error] = params[:errors]
  end

  def resend_email_click
    @user = (User.where("login.email" => params[:email]).first)
    if @user and !@user.verified
      @user.send_verification 
      redirect_to registered_successfully_unsigned_home_index_path
    else
      @errors = ''
      if @user.nil?
        @errors += "The username entered does not belong to any account. Enter valid username"
      else
        @errors += "User Already Verified"
      end
      redirect_to :action => "resend_email", :errors=> @errors
    end
  end

  def register
   @user = User.new
   @user.build_login
   @home_banner_image = HomeBanner.last
   @more_reason_popup_image = MoreReasonPopup.last
  end

  def help

  end

 # ====================Forgot password ===================================
  def forgot_password
  end

 #retreive password ajax def
  def retreive
    @user = (User.where("login.email" => params[:email]).first)
    if @user and @user.verified
      @user.send_forgot_password
      flash[:notice] = "A link has been sent to this email account ,kindly follow the instructions to reset your password  "
    else
      flash[:error] = "Invalid Login"
    end
  end

 #==========================End Forgot password===============================
  def account_compromised

  end

 #account compromised retreive ajax def
  def account_compromised_retreive
    @user = (User.where("login.master_email" => params[:master_email]).first)
    if @user and @user.verified
      @user.send_forgot_password
    else
      flash[:error] = "Invalid Login"
    end
  end

 #========================================================================
  def change_password_form
    @user = User.where("login.email" => params[:user][:login_attributes][:email]).first
    @user.update_attributes(params[:user])
  end

 #forgot  login email
  def forgot_username
    user = User.where("login.master_email" => params[:master_email]).first
    @login = user.login if user
    flash[:error] = "invalid master email please enter again"
  end

  def change_password
  end

  def account_com_update
    #flash[:error] = "invalidness"
  end

  def set_password
    @user = User.where("verification_token" => params[:token]).first
  end
  
  def create_user
    @user = User.new(params[:user])
    puts "===========#{params[:user]}============="
    if @user.save
      redirect_to registered_successfully_unsigned_home_index_path
    else
      @home_banner_image = HomeBanner.last
      @more_reason_popup_image = MoreReasonPopup.last
      render register_unsigned_home_index_path 
    end
  end
  
  def verify_email
   @user = User.where("verification_token" => params[:token]).first

    if @user
      @user.update_attributes(:verified => true)
      render reg_intermediate_page_unsigned_home_index_path
      #render  verified_unsigned_home_index_path
    else
     render "unsigned/home/verification_failed"
    end
  end
  
  def reg_intermediate_page
  
  end

  def reg_intermediate
   @user = User.find(params[:user])
    if params[:master_email].present? 
      @user.update_attributes(:master_email => params[:master_email])
    end
    if params[:time_zone].present?
      @user.update_attributes(:time_zone => params[:time_zone])
    end
    if params[:profile_image].present? 
      @user.profile_images.create(:profile_image => params[:profile_image])
    end
    if params[:user_type].present?
      @setting = @user.build_account_setting
      @setting.user_type = params[:user_type]
      @setting.save
    end

    if @user and  @user.verified
      session[:user_id] = @user.id
      set_all
      redirect_to signed_feeds_path
    end

  end
  
  def feed_back
    @feed_back = FeedBack.new
  end

  def create_feed_back
    @feed_back = FeedBack.new(params[:feed_back])
    if @feed_back.save
      flash[:notice] = "Sucessfully submitted"
      @feed_back = FeedBack.new
      render :action => :feed_back
    else
      render :action => :feed_back
    end   
  end

  private

  def redirect_if_logged
    if logged_in?
      redirect_to root_path
    end
  end
end
