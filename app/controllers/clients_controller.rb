class ClientsController < ApplicationController
  def index
    @clients = Devise::Oauth2Providable::Client.all
  end

  def show
    @client = Devise::Oauth2Providable::Client.find(params[:id])
  end
  
  def new
    @client = Devise::Oauth2Providable::Client.new
  end
  
  def edit
    @client = Devise::Oauth2Providable::Client.find(params[:id])
  end
  
  def create
    @client = Devise::Oauth2Providable::Client.new(params[:client])
    if @client.save
      redirect_to @client, notice: 'Client was successfully created'
    else
      render action: 'new'
    end
  end
  
  def update
    @client = Devise::Oauth2Providable::Client.find(params[:id])
    if @client.update_attributes(params[:client])
      redirect_to @client, notice: 'Client was successfully update'
    else
      render action: 'edit'
    end    
  end
  
  def destroy
    @client = Devise::Oauth2Providable::Client.find(params[:id])
    @client.destroy
    redirect_to clients_url
  end
end
