require "uri"

class VitalSignHost
  include Mongoid::Document
  field :hostname, :type => String
  field :port, :type => Integer
  field :client_id, :type => String
  field :client_secret, :type => String

  validates_presence_of :hostname

  scope :from_url, ->(url) { where(hostname: URI.parse(url).host) }

  has_many :vital_sign_feeds
  
  def authorization_request_url(redirect_uri, use_https=false)
    query = {'client_id' => client_id, 'client_secret' => client_secret,
             'response_type' => 'code', 'redirect_uri' => redirect_uri,
             'scope' => "vitals"}.to_query
    path = '/oauth/authorization'
    
    if use_https
      URI::HTTPS.build(host: hostname, path: path, query: query, port: port)      
    else
      URI::HTTP.build(host: hostname, path: path, query: query, port: port)
    end
  end
end
