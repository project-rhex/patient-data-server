require 'open_id/authentication_exception'
require 'open_id/error_codes'

###############################################
# To test you can use this url, but handshake won't know what to do with the redirect
# http://localhost:3000/open_id/authorize?response_type=code&client_id=1&scope=openid profile email&redirect_uri=https://handshake.mitre.org&nonce=12141512544124
class OpenIdController < ActionController::Base
  layout "application"

  OII = "OpenIDInfo_"

  rescue_from Exception do |e|
    render text: "Bad request", status: 400
  end

  rescue_from OpenId::AuthenticationException do |e|
    # Create denial response
    tail = "?error=#{e.value}&error_description=#{e.description}&state=#{e.state}"
    redirect_to e.redirect_uri + tail
  end


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
    redirect_uri = params[:redirect_uri]
    state = params[:state]
    raise Exception.new("Bad request") unless redirect_uri
    response_type = params[:response_type]
    unless response_type && response_type == 'code'
      raise OpenId::AuthenticationException.new(value: OpenId::ErrorCodes::INVALID_REQUEST,
        description: "Invalid or malformed request", redirect_uri: redirect_uri, state: state)
    end
    client_id = params[:client_id]
    unless client_id
      raise OpenId::AuthenticationException.new(value: OpenId::ErrorCodes::INVALID_REQUEST,
        description: "Invalid or malformed request", redirect_uri: redirect_uri, state: state)
    end
    scope = params[:scope]
    unless scope && scope.index("openid")
      raise OpenId::AuthenticationException.new(value: OpenId::ErrorCodes::INVALID_REQUEST,
        description: "Invalid or malformed request", redirect_uri: redirect_uri, state: state)
    end
    nonce = params[:nonce]
    unless nonce
      raise OpenId::AuthenticationException.new(value: OpenId::ErrorCodes::INVALID_REQUEST,
        description: "Invalid or malformed request", redirect_uri: redirect_uri, state: state)
    end
    prompt = params[:prompt] || "login"

    scope = scope.split(/\s/)

    # Find or create a client that matches the given client id
    begin
      client = Devise::Oauth2Providable::Client.first(conditions: {cidentifier: client_id})
    rescue
      #
    end

    unless client
      raise OpenId::AuthenticationException.new(value: OpenId::ErrorCodes::INVALID_REQUEST,
              description: "Invalid or malformed request", redirect_uri: redirect_uri, state: state)
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
        password: params[:password],
        email: params[:email],
    }

    client_id = params[:client_id]
    unless client_id
      raise Exception.new("Missing client id")
    end

    # Find client and user
    user = User.first(conditions: {email: credentials[:email]})
    client = Devise::Oauth2Providable::Client.first(conditions: {cidentifier: client_id})

    unless client
      raise Exception.new("Client is missing from the database")
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
      return
    end

    # Go on to confirmation and scopes
    session_data = session[OII + client_id]
    scope = session_data[:scope] # Array of scopes, the user must pick out the ones to be used
    render 'open_id/confirmation', locals: {scopes: scope, client: client, client_id: client_id }
  end

  ############################################
  # The user confirms (or denies) access to the RP, allowing zero or more of the requested
  # scopes
  def confirm
    permitted = params[:permit]
    email = params[:email]
    profile = params[:profile]
    address = params[:address]
    client_id = params[:client_id]
    unless client_id
      raise Exception.new("Missing required parameter")
    end

    session_data = session[OII + client_id]
    redirect_uri = session_data[:redirect]
    state = session_data[:state]
    nonce = session_data[:nonce]

    unless permitted
      raise OpenId::AuthenticationException.new(value: OpenId::ErrorCodes::ACCESS_DENIED,
        description: "The user denied access to the website", redirect_uri: redirect_uri, state: state)
    end

    client = Devise::Oauth2Providable::Client.first(conditions: {cidentifier: client_id})

    # Create and store the code in the client along with the scopes the user has enabled
    code = SecureRandom.uuid
    authorization_code = Devise::Oauth2Providable::AuthorizationCode.new
    authorization_code[:code] = code
    authorization_code[:scopes] = []
    authorization_code[:scopes] << "email" if email
    authorization_code[:scopes] << "profile" if profile
    authorization_code[:scopes] << "address" if address
    authorization_code[:nonce] = nonce
    client.authorization_codes << authorization_code
    client.save

    # Return query string
    q = "?code=#{code}"
    q += "&state=#{state}" if state
    redirect_to redirect_uri + q, status: 302
  end
end