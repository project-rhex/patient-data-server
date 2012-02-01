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
    # This code isn't really correct, however, we're moving the put_as_json code to the appropriate place soon as
    # part of unifying under a single controller, hence this method doesn't determine the type of the content or
    # really handle multipart form data in any proper way
    content = params[:content]
    type = content[:content_type]
    data = content[:content_data]

    put_as_json(data) if 'application/json' == type

    render :json => { :status => 201 }, :status => :created
  end

  private

  #-----------------------------------------------------------------
  # Validate the parameters from JSON and then save the resulting
  # hash into the document
  def put_as_json content
    data = JSON.parse(content)
    # Validate the presence of required data
    codes = data[JsonConstants::CODES]
    time = data[JsonConstants::TIME]
    desc = data[JsonConstants::DESCRIPTION]

    if codes.nil? || time.nil? || desc.nil?
      render file: "public/400.html", :status => :bad_request
      return
    end

    @record.results << Entry.new(data)
    @record.save
  end

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