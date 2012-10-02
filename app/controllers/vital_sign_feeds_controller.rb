class VitalSignFeedsController < ApplicationController

  before_filter :find_record

  def create
    vsf = VitalSignFeed.new(params[:vital_sign_feed])
    vsh = VitalSignHost.from_url(vsf.url).first
    if vsh
      vsf.vital_sign_host = vsh
      vsf.record = @record
      vsf.save!
      
      vsa = current_user.auth_for_feed(vsf)
      
      if vsa.fetch
        flash[:notice] = "Imported new vital signs"
        redirect_to record_path(@record.medical_record_number)
      else
        redirect_to vsh.authorization_request_url(vital_sign_callback_access_code_url, Rails.env.production?).to_s
      end
    else
      flash[:error] = "Host not registered with PDS"
      redirect_to record_path(@record.medical_record_number)
    end
  end
  
end
