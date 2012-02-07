class EntriesController < ApplicationController
  before_filter :set_up_section
  before_filter :find_entry, only: "show"
  
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

  private
  
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