class RecordsController < ApplicationController
  #before_filter :authenticate_user!
  before_filter :default_format_to_atom, only: [:show]
  before_filter :find_record, only: [:root, :show]

  def index
    @records = Record.all
    audit_log "record_index", nil

    respond_to(:atom, :html)
  end
  
  def create
    ## TODO need to log document content

    xml_file = request.body
    doc = Nokogiri::XML(xml_file)
    doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
    patient_data = HealthDataStandards::Import::C32::PatientImporter.instance.parse_c32(doc)
    patient_data.save!
    audit_log "record_create", patient_data.medical_record_number

    response['Location'] = record_url(id: patient_data.medical_record_number)
    render :text => 'success', :status => 201
  end

  def options
    sr = SectionRegistry.instance
    response['X-hdata-extensions'] = sr.extensions.map(&:extension_id).join(' ')
    # TODO: Replace these with real values
    response['X-hdata-security'] = 'http://openid.net/connect/'
    response['X-hdata-hcp'] = 'http://projecthdata.org/hcp/greenCDA-CoC'

    render :nothing => true
  end

  def show
    desc = audit_log "record_access", nil

    if current_user
      AuditLog.doc(current_user.email, "record_access", desc, @record, @record.version)
    end

    if stale?(:last_modified => @record.updated_at.utc, :etag => @record)
      respond_to(:atom, :html)
    end
  end

  def set_breadcrumbs
    super
    add_breadcrumb('Patient Index')
  end
  
  def root
    # handled by the find_record before filter
  end

 def audit_log(action, id)
   return if current_user.nil?
   
   desc = ""
   desc = "record_id:#{params[:record_id]}" if params[:record_id]
   desc += "|section:#{params[:section]}" if params[:section]
   desc += "|id:#{params[:id]}" if params[:id]
   desc += "|id:#{id}" if id
   AuditLog.create(requester_info: current_user.email, event: action, description: desc)
   
   desc
  end
end
