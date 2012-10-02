require "tatrc/vital_signs_importer"

class VitalSignFeed
  include Mongoid::Document

  field :url, type: String

  belongs_to :vital_sign_host
  belongs_to :record

  def fetch(access_token)
    token = Rack::OAuth2::AccessToken::Bearer.new(:access_token => access_token)
    feed = token.get(url)
    vital_signs = TATRC::VitalSignsImporter.instance.import(feed.body)
    record.vital_signs.concat(vital_signs)
    record.save!
  end

  def obtain_access_token(authorization_code, redirect_uri)
    client = Rack::OAuth2::Client.new(
      :identifier => vital_sign_host.client_id,
      :secret => vital_sign_host.client_secret,
      :redirect_uri => redirect_uri,
      :host => vital_sign_host.hostname,
      :token_endpoint => "/oauth/token",
      :port => vital_sign_host.port,
      :scheme => "http"
    )

    client.authorization_code = authorization_code
    client.access_token!
  end
end
