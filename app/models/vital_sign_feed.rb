class VitalSignFeed
  include Mongoid::Document

  field :url, type: String

  belongs_to :vital_sign_host
  belongs_to :record

  def fetch(vital_sign_auth)
    token = Rack::OAuth2::AccessToken::Bearer.new(:access_token => vital_sign_auth.access_token)
    token.get(url)
  end

  def obtain_access_token(authorization_code, redirect_uri)
    client = Rack::OAuth2::Client.new(
      :identifier => vital_sign_host.client_id,
      :secret => vital_sign_host.client_secret,
      :redirect_uri => redirect_uri,
      :host => vital_sign_host.hostname
    )

    client.authorization_code = authorization_code
    client.access_token!
  end
end