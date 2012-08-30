class VitalSignAuth
  include Mongoid::Document
  
  embedded_in :user
  
  field :access_token, type: String
  field :refresh_token, type: String
  
  belongs_to :vital_sign_feed
  
  def fetch
    if access_token
      vital_sign_feed.fetch(access_token)
      true
    else
      false
    end
  end
end