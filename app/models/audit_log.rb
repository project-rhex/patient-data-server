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
  field :record_id, :type => String
  field :version,   :type => Integer
  

  ## get list of all audited docs
  def self.review_docs() 
    AuditLog.all( conditions: { event: /_access$/i } )
  end


  ## get list of audited docs with this record number
  def self.review_doc(medical_record_number) 
    ## query and return array (to_a) of data
    AuditLog.all( conditions: { event: /_access$/i, record_id: medical_record_number } ).to_a
  end


  ## get actual document based on version number
  def self.review_doc_content(medical_record_number, version) 

    return nil if version <= 0

    ## first test if this record exists at all
    record = Record.where( medical_record_number: medical_record_number ).first
    return nil if record == nil

    ## return the latest record if the version is 1 greater than the array size
    ## return the only and latest record if there are no newer versions
    return record if record.versions.size + 1 == version
 
    ## record.versions is an array of past records

    ## number of versions = 0, record.versions.size = 0
    ## number of versions = 1, record.versions.size = 1, array index of 0
    ## number of versions = 2, record.versions.size = 2, array index of 0 and 1 
    ## etc
    ## ex. if passed in version == 2, versions.size must be at least 1 in size (or 1 less)

    record.versions[version - 1]
  end


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
