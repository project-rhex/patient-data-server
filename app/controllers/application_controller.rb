require 'request_error'

class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!
  before_filter :audit_log_all
  before_filter :set_breadcrumbs

  rescue_from RequestError do |e|
    if e.message.nil?
      render file: "public/#{e.status}.html", :status => e.status
    else
      render text: e.message, :status => e.status
    end
  end

  # Return a list of breadcrumbs appropriate for the particular controller. This method can be overridden by
  # any specific subclass to introduce sublinks into the breadcrumb path. A leaf path can then be introduced by
  # the local controller by convention using local code
  def breadcrumbs
    @breadcrumbs
  end

  # Root breadcrumbs setup method. May be overridden or augmented by subclasses
  def set_breadcrumbs
    @breadcrumbs = []
    add_breadcrumb "Home", root_path
  end

  # Add a single link's data in a hash
  def add_breadcrumb title, link = nil
    if link.nil?
      @breadcrumbs << { :title => title }
    else
      @breadcrumbs << { :title => title, :link => link }
    end
  end

  private

  # Only call find_record in a before_filter for methods that should have an id or record_id
  # parameter. Make sure to add exceptions for methods that don't.
  def find_record
    record_id = params[:record_id] || params[:id]
    @record = Record.first(conditions: {medical_record_number: record_id})
    raise RequestError.new(404) if @record.nil?
  end

  ##
  ## Track each controller and method (action) call
  def audit_log_all

    if  params[:controller] && params[:action]
      desc = params[:controller] + "|" + params[:action]
      desc << "|id:#{params[:id]}" if params[:id]

      ## log user email for now
      ## TODO: change to larger requester info set
      if current_user
        if desc =~ /sessions\|destroy/
          desc << "|LOGOUT"
        end

        AuditLog.create(requester_info: current_user.email, event: "USER_ACTION", description: desc)
      else
        AuditLog.create(requester_info: "NONE", event: "USER_ACTION", description: desc)
      end

    end

  end

  # Check the accepts header and defaults the format to request an atom feed
  # apply to a controller using a before filter
  def default_format_to_atom
    # Default the type we are sending out
    if request.accept.nil?
      request.format = :atom
    end
  end

end
