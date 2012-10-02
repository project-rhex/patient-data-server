require 'omniauth-openid'
require 'openid/store/filesystem'
Rails.application.config.middleware.use OmniAuth::Builder do
   provider :open_id, store: OpenID::Store::Filesystem.new('/tmp')
   provider :developer unless Rails.env.production?
   provider :openid_connect, 'direct.stormwoods.info','67f31a9c-ca13-11e1-bc1d-000c297fba10','7fae4ef2-cca7-11e1-bd23-000c297fba10',{:authorization_endpoint => "/tatrc-openid-connect-server/authorize"  ,
                :user_info_endpoint=>"/tatrc-openid-connect-server/userinfo", 
                :token_endpoint =>"/tatrc-openid-connect-server/token", 
                :jwk_url=>"/tatrc-openid-connect-server/jwk",
                :issuer=>"http://localhost/",
                :scope=>"openid profile email",
                :client_options =>{:scheme=>"http", :port=>8080}}
end