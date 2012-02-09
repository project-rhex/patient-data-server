class RecordsController < ApplicationController
  #before_filter :authenticate_user!

  def index
    @records = Record.all

    if current_user
      AuditLog.create(requester_info: current_user.email, event: "record_list_access", description: desc)
    end
    respond_to do |wants|
      wants.atom {}
      wants.html{}
    end
  end
  
  def root
    
  end
  
  def create
    xml_file = request.body
    doc = Nokogiri::XML(xml_file)
    doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
    patient_data = HealthDataStandards::Import::C32::PatientImporter.instance.parse_c32(doc)
    ## GG commented out, thows a Array.reject no method error; patient_data.save works
    #Record.create!(patient_data)

    ##
    patient.medical_record_number = next_med_rec_num
    patient_data.save
    
    # TODO: need to confirm save is ok or not and return appropriate response

    ## TODO: need to return patient ID with URI
    render :text => 'success', :status => 201
  end
  
  def show
    if current_user
      AuditLog.create(requester_info: current_user.email, event: "record_access", description: desc)
    end

    respond_to do |wants|
      wants.atom {}
      wants.html {}
    end
  end

  def breadcrumbs
    super << breadcrumb('Patient Index')
  end

  private

  def next_med_rec_num
    records = Record.all

    highest_med_rec_num = 0
    records.each do |rec|
      if rec.medical_record_number.to_i > highest_med_rec_num 
        highest_med_rec_num =  rec.medical_record_number.to_i
      end
    end

    highest_med_rec_num += 1
  end
end
