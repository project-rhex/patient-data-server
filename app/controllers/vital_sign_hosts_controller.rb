class VitalSignHostsController < ApplicationController
  # GET /vital_sign_hosts
  # GET /vital_sign_hosts.json
  def index
    @vital_sign_hosts = VitalSignHost.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @vital_sign_hosts }
    end
  end

  # GET /vital_sign_hosts/1
  # GET /vital_sign_hosts/1.json
  def show
    @vital_sign_host = VitalSignHost.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vital_sign_host }
    end
  end

  # GET /vital_sign_hosts/new
  # GET /vital_sign_hosts/new.json
  def new
    @vital_sign_host = VitalSignHost.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @vital_sign_host }
    end
  end

  # GET /vital_sign_hosts/1/edit
  def edit
    @vital_sign_host = VitalSignHost.find(params[:id])
  end

  # POST /vital_sign_hosts
  # POST /vital_sign_hosts.json
  def create
    @vital_sign_host = VitalSignHost.new(params[:vital_sign_host])

    respond_to do |format|
      if @vital_sign_host.save
        format.html { redirect_to @vital_sign_host, notice: 'Vital sign host was successfully created.' }
        format.json { render json: @vital_sign_host, status: :created, location: @vital_sign_host }
      else
        format.html { render action: "new" }
        format.json { render json: @vital_sign_host.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /vital_sign_hosts/1
  # PUT /vital_sign_hosts/1.json
  def update
    @vital_sign_host = VitalSignHost.find(params[:id])

    respond_to do |format|
      if @vital_sign_host.update_attributes(params[:vital_sign_host])
        format.html { redirect_to @vital_sign_host, notice: 'Vital sign host was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @vital_sign_host.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vital_sign_hosts/1
  # DELETE /vital_sign_hosts/1.json
  def destroy
    @vital_sign_host = VitalSignHost.find(params[:id])
    @vital_sign_host.destroy

    respond_to do |format|
      format.html { redirect_to vital_sign_hosts_url }
      format.json { head :no_content }
    end
  end
end
