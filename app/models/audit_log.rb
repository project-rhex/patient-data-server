require 'digest/sha1'

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

  ## file record id
  field :record_id, :type => Integer
  field :version,   :type => Integer
  
  ## capture a sha1 hash of record and save it as a water mark
  def self.doc(requester_info, event, description, record, record_id, vers)
    #puts "======"
    ## to_yaml ... sometime bombs out with -  can't dump anonymous class Class, replace with inspect
    #serialized = record.to_yaml
    serialized = record.inspect
    #puts serialized.inspect

    sig = ""
    sig = Digest::SHA1.hexdigest serialized
    ##puts "GG" + sig.inspect
    AuditLog.create(requester_info: requester_info, event: event, 
                    description: description, checksum: sig, record_id: record_id, version: vers)
  end

end
