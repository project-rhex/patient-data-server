class CustomAuthFail < Devise::FailureApp 
  def respond
    super 

    ## Called when user authorization failure 
    puts "*** Here in CustomAuthFail" 

    return if params.nil?

    login_email = ""
    user = params[:user]
    if !user.nil?
      login_email = user[:email]
    end

    if (login_email.length == 0)
      ## user pressing sign-in with out entering email
      AuditLog.create(requester_info: login_email, event: "user_auth_blank_login", description: "Blank Login")
    else
      AuditLog.create(requester_info: login_email, event: "user_auth_fail", description: "Login Failure")
    end

  end 
end 
