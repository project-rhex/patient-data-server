class EntriesController < ApplicationController
  before_filter :set_up_section
  before_filter :find_entry, only: ["show", "update", "delete"]
  
  def index
    @entries = @record.send(@section_name)
    respond_to do |wants|
      wants.atom {}
    end
  end
  
  def show
    respond_to do |wants|
      wants.json {render :json => @entry.attributes}
      wants.xml do
        exporter = @extension.exporters['application/xml']
        render :xml => exporter.export(@entry)
      end
    end
  end
  
  def create
    content_type = request.content_type
    if content_type == "multipart/form-data"
      render text: 'Metadata POSTing not yet implemented', status: 400
    else
      section_document = import_document(content_type)
      @record.send(@section_name).push(section_document)
      response['Location'] = section_document_url(record_id: @record, section: @section_name, id: section_document)
      render text: 'Section document created', status: 201
    end
  end
  
  def update
    content_type = request.content_type
    section_document = import_document(content_type)
    @entry.update_attributes!(section_document.attributes)
    render text: 'Document updated', status: 200
  end

  def delete
    @entry.destroy
    render nothing: true, status: 204
  end

  private
  
  def import_document(content_type)
    importer = @extension.importers[content_type]
    raw_content = nil
    if content_type = 'application/xml'
      raw_content = Nokogiri::XML(request.body.read)
    end
    importer.import(raw_content)
  end
  
  def set_up_section
    @section_name = params[:section]
    sr = SectionRegistry.instance
    @extension = sr.extension_from_path(params[:section])
    unless @extension
      render text: 'Section Not Found', status: 404
    end
  end
  
  def find_entry
    if BSON::ObjectId.legal?(params[:id])
      @entry = @record.send(@section_name).find(:first, conditions: {id: params[:id]})
      unless @entry
        render text: 'Entry Not Found', status: 404
      end
    else
      render text: 'Not a valid identifier for a section document', status: 400
    end
  end

end