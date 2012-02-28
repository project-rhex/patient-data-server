class RecordsController < ApplicationController
  #before_filter :authenticate_user!

  def index
    @records = Record.all
    audit_log "record_index", nil

    respond_to do |wants|
      wants.atom {}
      wants.html{}
    end
  end
  
  def root
    return if missing_record?
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
  
  def show
    return if missing_record?

    desc = audit_log "record_access", nil

    if current_user
      AuditLog.doc(current_user.email, "record_access", desc, @record, @record.version)
    end

    respond_to do |wants|
      wants.atom {}
      wants.html {}
    end
  end

  def breadcrumbs
    super << breadcrumb('Patient Index')
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
