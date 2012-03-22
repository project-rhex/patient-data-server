# http://localhost:3000/open_id/authorize?response_type=code&client_id=1&scope=openid&redirect_uri=https://handshake.mitre.org&nonce=12141512544124
class OpenIdController < ActionController::Base
  layout "application"

  OII = "OpenIDInfo_"

  ############################################
  # Handle an authorization request
  #
  # Parameters required by the specification:
  # response_type, this implementation requires the use of the value "code"
  # client_id, an opaque identifier that identifies the client, must be present. Identifies the RP
  # scope, a space separated list of scopes, must include the scope "openid". The additional scopes
  #       are used when determining what user information to make visible.
  # redirect_uri, the redirect uri. If we implement the discovery phase this will be checked
  #       against the list of possible redirect uris passed in discovery.
  # nonce, a string value that is used by the client to associate the request and response and guard
  #       against replay attacks.
  # prompt, a space delimited list of strings (one or more of login, consent, select_account, and none)
  #       to indicate how to show the screen to the user
  # state, an opaque value to track state between the request and response for the requester.
  def authorize
    response_type = params[:response_type]
    unless response_type && response_type == 'code'
      render :text => "Authorization Endpoint Error (invalid_request_response_type)", :status => 400
      return
    end
    client_id = params[:client_id]
    unless client_id
      render :text => "Authorization Endpoint Error (invalid_request_client_id)", :status => 400
      return
    end
    scope = params[:scope]
    unless scope && scope.index("openid")
      render :text => "Authorization Endpoint Error (invalid_request_scope)", :status => 400
      return
    end
    redirect_uri = params[:redirect_uri]
    unless redirect_uri
      render :text => "Authorization Endpoint Error (invalid_request_redirect_uri)", :status => 400
      return
    end
    nonce = params[:nonce]
    unless nonce
      render :text => "Authorization Endpoint Error (invalid_request_nonce)", :status => 400
      return
    end
    prompt = params[:prompt] || "login"
    state = params[:state]

    scope = scope.split(/\s/)

    # Find or create a client that matches the given client id
    begin
      client = Devise::Oauth2Providable::Client.first(conditions: {cidentifier: client_id})
    rescue
      render :text => "Authorization Endpoint Error (unknown_client)", :status => 400
      return
    end

    # Save connection information in the session
    session[OII + client_id]= {
        prompt: prompt,
        state: state,
        nonce: nonce,
        scope: scope,
        redirect: redirect_uri
    }

    render 'open_id/authenticate', locals: {credentials: {}, client_id: client_id}
  end

  ############################################
  # Validate the email and password against the user database
  def validate
    credentials = {
        password: params["password"],
        email: params["email"],
    }

    client_id = params["client_id"]
    # Find client and user
    user = User.first(conditions: {email: credentials[:email]})
    client = Devise::Oauth2Providable::Client.first(conditions: {cidentifier: client_id})

    unless client
      render :text => "Missing required field data client", :status => 400
    end

    error = false
    credentials[:error_message] = nil
    if user
      unless user.valid_password?(credentials[:password])
        error = true
      end
    else
      error = true
    end

    if error
      credentials[:error_message] = "Bad user credentials"
      render 'open_id/authenticate', locals: {credentials: credentials, client_id: client_id},
             :status => 400
    end

    # Go on to confirmation and scopes
  end

end