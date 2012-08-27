class RefConsultRequestsController < ApplicationController

  # GET /ref_consult_requests
  # GET /ref_consult_requests.json
  def index
    @ref_consult_requests = RefConsultRequest.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ref_consult_requests }
      format.xml  { render xml:  @ref_consult_requests.to_xml }
    end
  end

  # GET /ref_consult_requests/1
  # GET /ref_consult_requests/1.json
  def show
    @ref_consult_request = RefConsultRequest.find( params[:id] )

    if @ref_consult_request.nil? 
      render text: 'Referral Consult Not Found', status: 404
      return
    end
    @record = Record.find( @ref_consult_request.patientRecordId ) if !@ref_consult_request.patientRecordId.nil?

    if stale?(:last_modified => @ref_consult_request.updated_at.utc, :etag => @ref_consult_request)
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @ref_consult_request }
        format.xml  { render xml:  @ref_consult_request.to_xml }
      end
    end
  end

  # GET /ref_consult_requests/new
  # GET /ref_consult_requests/new.json
  def new
    @ref_consult_request = RefConsultRequest.new
    @ref_consult_request.refDate = Date.today
    @ref_consult_request.refNumber = RefNumber.next

    ## patient record ID passed in
    if params[:id]
      @ref_consult_request.patientRecordId = params[:id]
      @record = Record.find( @ref_consult_request.patientRecordId ) 
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ref_consult_request }
    end
  end

  # GET /ref_consult_requests/1/edit
  def edit
    @ref_consult_request = RefConsultRequest.find(params[:id])
    @record = Record.find( @ref_consult_request.patientRecordId  ) if @ref_consult_request.patientRecordId
  end

  # POST /ref_consult_requests
  # POST /ref_consult_requests.json
  def create
    @ref_consult_request = RefConsultRequest.new(params[:ref_consult_request])

    respond_to do |format|
      if @ref_consult_request.save
        format.html { redirect_to @ref_consult_request, notice: 'Ref consult request was successfully created.' }
        format.json { render json: @ref_consult_request, status: :created, location: @ref_consult_request }
      else
        format.html { render action: "new" }
        format.json { render json: @ref_consult_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ref_consult_requests/1
  # PUT /ref_consult_requests/1.json
  def update
    @ref_consult_request = RefConsultRequest.find(params[:id])

    respond_to do |format|
      if @ref_consult_request.update_attributes(params[:ref_consult_request])
        format.html { redirect_to @ref_consult_request, notice: 'Ref consult request was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ref_consult_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ref_consult_requests/1
  # DELETE /ref_consult_requests/1.json
  def destroy
    @ref_consult_request = RefConsultRequest.find(params[:id])
    @ref_consult_request.destroy

    respond_to do |format|
      format.html { redirect_to ref_consult_requests_url }
      format.json { head :no_content }
    end
  end
end
