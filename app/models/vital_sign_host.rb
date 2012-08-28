class VitalSignHost
  include Mongoid::Document
  field :hostname, :type => String
  field :client_id, :type => String
  field :client_secret, :type => String
  
  has_many :vital_sign_feeds
end
