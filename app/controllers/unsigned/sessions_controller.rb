class Unsigned::SessionsController < Unsigned::BaseController

  before_filter :check_authentication, :except => [:logout]

  def create
    @user = (User.where("login.email" => params[:email].downcase).first)
    if @user and  @user.verified and  @user.login.authenticate(params[:password])
      session[:user_id] = @user.id
      set_all
      if params[:keep_me_signed_in].present? and params[:keep_me_signed_in]
        cookies[:auth_token] = { :value =>  @user.id, :expires => Time.now+1.year }
      end
    else
      @errors = ''
      if @user.nil?
        @errors += "The username entered does not belong to any account. Enter valid username"
      elsif !@user.verified
        @errors += "Email provided is not verified."
      else
        @errors += "Incorrect Password."
      end
    end
  end

  def logout
    session[:user_id] = nil
    cookies[:auth_token] = nil
    redirect_to root_path
  end

  def intermediate_fb_page
   omni = request.env['omniauth.auth']   # This contains all the details of the user say Email, Name, Age so that you can store it in your application db. 
   session[:auth] = omni
   @user = User.where("login.email" => session[:auth]['extra']['raw_info'].email.downcase).first 
    if @user.present?
      session[:user_id] =  @user.id
      set_all 
      redirect_to signed_feeds_path
    end  
  end 
 
  def facebook_login
    @user = User.where("login.email" => session[:auth]['extra']['raw_info'].email.downcase).first
    
    if @user and @user.verified
      session[:user_id] =  @user.id
      set_all
      if params[:keep_me_signed_in].present? and params[:keep_me_signed_in]
        cookies[:auth_token] = { :value =>  @user.id, :expires => Time.now+1.year }
      end        
    else
      @user = User.new
      @user.build_login
      @user.login.email = session[:auth]['extra']['raw_info'].email
      @user.login.password = 'anasjmh123'
      if params[:master_email].present? 
         @user.login.master_email = params[:master_email] 
      end
      @user.first_name = session[:auth]['extra']['raw_info'].first_name
      @user.last_name =  session[:auth]['extra']['raw_info'].last_name
      @user.birthday = Date.strptime("#{session[:auth]['extra']['raw_info'].birthday}", "%m/%d/%Y")
      @user.time_zone = params[:time_zone]#.to_s.delete("[]")
      @user.save
      @user.update_attributes(:verified => true, :verification_token => Time.now.to_i.to_s )
      if params[:profile_image].present? 
        @user.profile_images.create(:profile_image => params[:profile_image])
      end
      if params[:user_type].present?
         @setting = @user.build_account_setting
         @setting.user_type = params[:user_type]
         @setting.save
      end
        session[:user_id] = @user.id
        set_all
    end
     redirect_to signed_feeds_path
  end

   

end
