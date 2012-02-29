# This class indicates that a record was requested and was not found
class RequestError < Exception
  def initialize(status, message = '')
    super(message)
    @status = status
  end

  def status
    @status
  end
end