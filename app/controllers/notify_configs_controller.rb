class NotifyConfigsController < ApplicationController
  # GET /notify_configs
  # GET /notify_configs.json
  def index
    add_breadcrumb('Notification Configurations')

    if !params[:all].nil?
      @title = "All Notification Settings"
      @notify_configs = NotifyConfig.all().to_a
    else
      @title = "My Notification Settings"
      @notify_configs = NotifyConfig.all( conditions: { user: /#{@current_user.email}/i } ).to_a
    end


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @notify_configs }
    end
  end

  # GET /notify_configs/1
  # GET /notify_configs/1.json
  def show
    @notify_config = NotifyConfig.find(params[:id])

    add_breadcrumb('Notification Configuration')

    if stale?(:last_modified => @notify_config.updated_at.utc, :etag => @notify_config)
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @notify_config }
      end
    end
  end

  # GET /notify_configs/new
  # GET /notify_configs/new.json
  def new
    @notify_config = NotifyConfig.new

    add_breadcrumb('Create Notification Configuration')

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @notify_config }
    end
  end

  # GET /notify_configs/1/edit
  def edit
    add_breadcrumb('Edit Notification Configuration')

    @notify_config = NotifyConfig.find(params[:id])
  end

  # POST /notify_configs
  # POST /notify_configs.json
  def create
    @notify_config = NotifyConfig.new(params[:notify_config])

    respond_to do |format|
      if @notify_config.save
        format.html { redirect_to @notify_config, notice: 'Notify config was successfully created.' }
        format.json { render json: @notify_config, status: :created, location: @notify_config }
      else
        format.html { render action: "new" }
        format.json { render json: @notify_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /notify_configs/1
  # PUT /notify_configs/1.json
  def update
    @notify_config = NotifyConfig.find(params[:id])

    respond_to do |format|
      if @notify_config.update_attributes(params[:notify_config])
        format.html { redirect_to @notify_config, notice: 'Notify config was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @notify_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notify_configs/1
  # DELETE /notify_configs/1.json
  def destroy
    @notify_config = NotifyConfig.find(params[:id])
    @notify_config.destroy

    respond_to do |format|
      format.html { redirect_to notify_configs_url }
      format.json { head :no_content }
    end
  end
end
