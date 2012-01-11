class C32JsonController < ApplicationController

  def index
    respond_to do |wants|
      wants.atom {}
    end
  end

  def show
    respond_to do |wants|
      wants.json { render json: @record }
    end
  end
  
end