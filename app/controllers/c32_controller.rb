class C32Controller < ApplicationController
  
  def index
   
  end
  
  def show
    respond_to do |wants|
      wants.xml { render xml: HealthDataStandards::Export::C32.export(@record) }
    end
  end
  
end
