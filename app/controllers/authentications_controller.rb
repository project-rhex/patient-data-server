class AuthenticationsController < ActionController::Base
  layout "application"
  def index
    @authentications = current_user.authentications if current_user
  end

  
  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.first(conditions: { provider: omniauth['provider'], uid: omniauth['uid']})
    #binding.pry
    if authentication
      AuditLog.create(requester_info: authentication.user, event: "user_auth", description: "successful sign in")
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      AuditLog.create(requester_info: current_user.email, event: "user_auth2", description: "successful sign in")
      flash[:notice] = "Authentication successful."
      redirect_to authentications_url
    else
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        user.authentications[0].save
        AuditLog.create(requester_info: current_user.email, event: "user_auth3", description: "successful account create and sign in")
        flash[:notice] = "Signed in successfully."
        sign_in_and_redirect(:user, user)
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to new_user_registration_url
      end
    end
  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end


  protected

  # This is necessary since Rails 3.0.4
  # See https://github.com/intridea/omniauth/issues/185
  # and http://www.arailsdemo.com/posts/44
  def handle_unverified_request
    true
  end
  
end
