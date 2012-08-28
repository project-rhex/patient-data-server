class VitalSignAuth
  include Mongoid::Document
  
  embedded_in :user
  
  field :access_token, type: String
  
  belongs_to :vital_sign_feed
end