class Notify < ActionMailer::Base
  # default from: "godganeshrohit@gmail.com"
	default from: "donot-reply@wallclipping.com"
  def verify_registration(user)
    @user = user
    mail(:to => user.login.email, :subject => "Activate Your Wallclipping Account")
  end


  def forgot_password_activation(user)
    @user = user
    mail(:to => user.login.email, :subject => "Password Reset")
  end

end






