class RecordsController < ApplicationController
    #before_filter :authenticate_user!
  def index
    @records = Record.all
    
    respond_to do |wants|
      wants.atom {}
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
    patient_data.save

    render :text => 'success', :status => 201
  end
  
  def show
    respond_to do |wants|
      wants.atom {}
    end
  end

end
