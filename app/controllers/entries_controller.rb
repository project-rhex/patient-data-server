class EntriesController < ApplicationController
  before_filter :get_section_name
  before_filter :find_entry, except: "index"

  respond_to :atom, :xml
  
  def index
    @entries = @record.send(@section_name)
    respond_to do |wants|
      wants.atom {}
    end
  end
  
  def show
    render :json => @entry.attributes
  end
  

  private
  
  def get_section_name
    @section_name = params[:section]
  end
  
  def find_entry
    @entry = @record.send(@section_name).find(params[:id])
  end

end