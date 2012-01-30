class C32Controller < ApplicationController
  
  respond_to :xml, :json, :atom
  
  def index
    respond_to do |wants|
      wants.atom {}
    end
  end
  
  def show
    respond_with(@record)
  end
  
end
