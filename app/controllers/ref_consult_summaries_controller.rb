class RefConsultSummariesController < ApplicationController
  # GET /ref_consult_summaries
  # GET /ref_consult_summaries.json
  def index
    @ref_consult_summaries = RefConsultSummary.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ref_consult_summaries }
    end
  end

  # GET /ref_consult_summaries/1
  # GET /ref_consult_summaries/1.json
  def show
    @ref_consult_summary = RefConsultSummary.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ref_consult_summary }
    end
  end

  # GET /ref_consult_summaries/new
  # GET /ref_consult_summaries/new.json
  def new
    @ref_consult_summary = RefConsultSummary.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ref_consult_summary }
    end
  end

  # GET /ref_consult_summaries/1/edit
  def edit
    @ref_consult_summary = RefConsultSummary.find(params[:id])
  end

  # POST /ref_consult_summaries
  # POST /ref_consult_summaries.json
  def create
    @ref_consult_summary = RefConsultSummary.new(params[:ref_consult_summary])

    respond_to do |format|
      if @ref_consult_summary.save
        format.html { redirect_to @ref_consult_summary, notice: 'Ref consult summary was successfully created.' }
        format.json { render json: @ref_consult_summary, status: :created, location: @ref_consult_summary }
      else
        format.html { render action: "new" }
        format.json { render json: @ref_consult_summary.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ref_consult_summaries/1
  # PUT /ref_consult_summaries/1.json
  def update
    @ref_consult_summary = RefConsultSummary.find(params[:id])

    respond_to do |format|
      if @ref_consult_summary.update_attributes(params[:ref_consult_summary])
        format.html { redirect_to @ref_consult_summary, notice: 'Ref consult summary was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ref_consult_summary.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ref_consult_summaries/1
  # DELETE /ref_consult_summaries/1.json
  def destroy
    @ref_consult_summary = RefConsultSummary.find(params[:id])
    @ref_consult_summary.destroy

    respond_to do |format|
      format.html { redirect_to ref_consult_summaries_url }
      format.json { head :no_content }
    end
  end
end
