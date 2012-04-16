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

  ## model class name as a string
  field :obj_name,  :type => String

  ## mongo _id value for object
  field :obj_id,    :type => String

  ## mongoid version number field
  field :version,   :type => Integer
  

  ## get list of all audited docs
  def self.review_docs() 
    ## return all log events that end in _access
    AuditLog.all( conditions: { event: /_access$/i } ).to_a
  end


  ## get list of audited docs with this id
  def self.review_doc(id) 
    ## query and return array of data
    AuditLog.all( conditions: { event: /_access$/i, obj_id: id } ).to_a
  end


  ## get actual document based on version number
  def self.review_doc_snapshot(obj_name, obj_id, version) 

    return nil if version <= 0
    return nil if obj_name == nil

    begin
      if obj_id.class.to_s != "String"
        id = obj_id.to_s
      end
      
      ## convert obj_name to a string for lookup
      if obj_name.class.to_s == "Class"
        # case where record.class is passed in
        classname = obj_name.to_s
      elsif obj_name.class.to_s == "String"
        # case where "Record" is passed in
        classname = obj_name
      else
        # case where Record is passed in
        classname = obj_name.class.to_s
      end
      
      ## first test if this med_record exists at all
      ## classes are constants that can be looked up via Kernel
      
      med_record = Kernel.const_get(classname).where( _id: id ).first
      return nil if med_record == nil

    rescue Exception => e
      ## catch a NoMethodError for the case where the wrong class (e.g. Array) is passed in
      ## catch a wrong constant name error for the case where the garbage class (e.g. "foo") is passed in
      ## catch undefined method `[]' for nil:NilClass 
      return nil
    end
    ## return the latest med_record if the version is 1 greater than the array size
    ## return the only and latest med_record if there are no newer versions
    return med_record if med_record.versions.size + 1 == version
 
    ## med_record.versions is an array of past med_records

    ## number of versions = 0, med_record.versions.size = 0
    ## number of versions = 1, med_record.versions.size = 1, array index of 0
    ## number of versions = 2, med_record.versions.size = 2, array index of 0 and 1 
    ## etc
    ## ex. if passed in version == 2, versions.size must be at least 1 in size (or 1 less)

    med_record.versions[version - 1]
  end


  ## capture a sha1 hash of med_record and save it as a water mark
  ##
  ## obj = Record, or Results etc
  ## obj_id - is _id from mongo
  def self.doc(requester_info, event, description, obj, vers)

    ## to_yaml ... sometime bombs out with -  can't dump anonymous class Class, replace with inspect
    serialized = obj.inspect


    sig = ""
    sig = Digest::SHA1.hexdigest serialized

    AuditLog.create(requester_info: requester_info, 
                    event:          event, 
                    description:    description, 
                    checksum:       sig, 
                    obj_name:       obj.class,
                    obj_id:         obj._id, 
                    version:        vers)
  end

end
