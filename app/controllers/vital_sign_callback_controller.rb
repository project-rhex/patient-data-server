class VitalSignCallbackController < ApplicationController
  def access_code
    # The way we pair up the access code sent back from the resource host with a feed
    # is by looking for the first VitalSignAuth without an access_token. In theory,
    # we should be able to use the state parameter as described in OAuth 2, but it
    # looks like Rack::OAuth2 doesn't support it. This code should work assuming the
    # same user doesn't try to gain access to two different vital sign feeds at the
    # same time.

    vsa = current_user.vital_sign_auths.where(access_token: nil).first
    
    access_token = vsa.vital_sign_feed.obtain_access_token(params[:code], url_for(controller: 'vital_sign_callback',
                                                                                  action: 'access_code'))

    vsa.access_token = access_token.access_token
    vsa.refresh_token = access_token.refresh_token
    vsa.save!
    
    vsa.fetch
    
    
    redirect_to record_path(vsa.vital_sign_feed.record.medical_record_number)
  end
end
