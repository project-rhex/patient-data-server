
class AuditLog
  include Mongoid::Document
  include Mongoid::Timestamps
  
  ## could be email, auth server name and user name, etc
  field :requester_info, :type => String

  ## record_accesse, record_update
  field :event, :type => String
  field :description, :type => String
  ##field :medical_record_number, :type => String
  
  ## file SHA1 HASH
  field :checksum, :type => String

end
