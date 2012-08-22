class RefConsultRequestsController < ApplicationController

  # GET /ref_consult_requests
  # GET /ref_consult_requests.json
  def index

    if params[:record_id].nil?
      ## list all patients
      @ref_consult_requests = RefConsultRequest.all
      @patient_names = Hash.new
      @ref_consult_requests.each do |ref_consult_request|
        if ref_consult_request.patientRecordId
          record = Record.find( ref_consult_request.patientRecordId  ) 
          next if record.nil?
          @patient_names["#{ref_consult_request.patientRecordId}"] = record.last.upcase + ', ' + record.first
        end
      end

    else
      ## list refs for this patient only
      @patient_names = Hash.new
      @ref_consult_requests = []
      ref_consults = RefConsultRequest.all().to_a
      ref_consults.each do |ref_consult|
        record = Record.find( ref_consult.patientRecordId  ) 
        next if record.nil?
        if record.medical_record_number == params[:record_id]
          @ref_consult_requests << ref_consult
          @patient_names["#{ref_consult.patientRecordId}"] = record.last.upcase + ', ' + record.first
        end
      end

    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ref_consult_requests }
      format.xml  { render xml:  @ref_consult_requests.to_xml }
    end
  end

  # GET /ref_consult_requests/1
  # GET /ref_consult_requests/1.json
  def email
    @ref_consult_request = RefConsultRequest.find( params[:id] )

  end


  # GET /ref_consult_requests/email/1
  def email
    @ref_consult_request = RefConsultRequest.find( params[:id] )

  end

  # GET /ref_consult_requests/sendemail/1
  def send_email
    @ref_consult_request = RefConsultRequest.find( params[:id] )
    @record = Record.find( @ref_consult_request.patientRecordId ) if !@ref_consult_request.patientRecordId.nil?

    PdsMail.consult(@ref_consult_request, @record).deliver ##
    respond_to do |format|
      format.html { redirect_to ref_consult_requests_url, notice: 'PDS Direct Email sent!' }
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
    @conditions  = @record.conditions.map {|x| x.description }
    @medications = @record.medications.map {|x| x.description }
    @vitals      = @record.vital_signs.sort { |a,b| b.time <=> a.time }
    @vitals.map! {|y| [ Time.at(y.time).strftime("%Y-%m-%d"), y.description.split(" ")[0], y.value['scalar']] }

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: { :ref_consult_requests => @ref_consult_request,
                                   :conditions => @conditions,
                                   :medicaitons => @medications,
                                   :vitals => @vitals }
      } 
      format.xml  { render xml:  @ref_consult_request.to_xml }
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
      @conditions  = @record.conditions.map {|x| x.description }
      @medications = @record.medications.map {|x| x.description }
      @vitals      = @record.vital_signs.sort { |a,b| b.time <=> a.time }
      @vitals.map! {|y| [ Time.at(y.time).strftime("%Y-%m-%d"), y.description.split(" ")[0], y.value['scalar']] }
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: { :ref_consult_requests => @ref_consult_request,
                                   :conditions => @conditions,
                                   :medicaitons => @medications,
                                   :vitals => @vitals }
      } 
    end
  end

  # GET /ref_consult_requests/1/edit
  def edit
    @ref_consult_request = RefConsultRequest.find(params[:id])
    @record = Record.find( @ref_consult_request.patientRecordId  ) if @ref_consult_request.patientRecordId
    @conditions = @record.conditions.map {|x| x.description }
    @medications = @record.medications.map {|x| x.description }
    @vitals      = @record.vital_signs.sort { |a,b| b.time <=> a.time }
    @vitals.map! {|y| [ Time.at(y.time).strftime("%Y-%m-%d"), y.description.split(" ")[0], y.value['scalar']] }
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
