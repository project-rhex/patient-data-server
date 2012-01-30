require "json_constants"

# The results controller presents test results for a patient to a requester.
class ResultsController < ApplicationController

  #-----------------------------------------------------------------
  # GET /results/id
  #
  # Get an aggregate listing of result links
  def index
    respond_to do |wants|
      wants.atom {}
    end
  end

  #-----------------------------------------------------------------
  # GET /results/id/result/subid
  #
  # Get an individual result and return it formatted according to
  # the content type requested by the caller
  def show
    @result_id = params[:result_id]
    if @result_id.nil?
      render file: "public/404.html", :status => :not_found
      return
    end

    respond_to do |wants|
      wants.json { render :json => get_as_json(@result_id) }
      wants.xml { } # TODO w/GreenCDA
    end
  end

  #-----------------------------------------------------------------
  # POST /results/id
  #
  # According to the HData specification there should be several
  # parameters. The main parameter should be a content parameter
  # which should have either a content type of application/json
  # or application/xml
  def add
    #  content = params[:content]

  end

  private

  #-----------------------------------------------------------------
  # Create JSON object for an individual result. This method assumes
  # that the @record instance variable is populated.
  #
  # @param result_id, the index into the array of results, must be
  # a fixnum in the appropriate interval
  # @returns nil if the result id is out of range, a hash of hashes
  # suitable for being turned into a JSON object representation of
  # the result if within range
  def get_as_json result_id
    results = @record.results
    result_id = params[:result_id]
    result = results[result_id.to_i - 1]
    return nil if result.nil?

    rval = { JsonConstants::CODES => result.codes }
    rval[JsonConstants::TIME] = result.time unless result.time.nil?
    rval[JsonConstants::DESCRIPTION] = result.description unless result.description.nil?
    rval[JsonConstants::VALUE] = result.value unless result.value.nil?

    return rval
  end
end