class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!


  before_filter :find_record
  
  private
  
  def find_record
    record_id = params[:record_id] || params[:id]
    @record = Record.first(conditions: {medical_record_number: record_id})
    render file: "public/404.html", :status => :not_found unless @record
  end
end