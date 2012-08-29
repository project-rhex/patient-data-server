class VitalSignHost
  include Mongoid::Document
  field :hostname, :type => String
  field :client_id, :type => String
  field :client_secret, :type => String
  
  has_many :vital_sign_feeds
  
  def authorization_request_url(redirect_uri, use_https=false)
    query = {'client_id' => client_id, 'client_secret' => client_secret,
             'response_type' => 'code', 'redirect_uri' => redirect_uri}.to_query
    path = '/authorize'
    if use_https
      URI::HTTPS.build(host: hostname, path: path, query: query)      
    else
      URI::HTTP.build(host: hostname, path: path, query: query)
    end
  end
end
