require 'digest/sha1'
require 'yaml'

class AuditDoc

  def self.log(requester_info, event, description, record)
    puts "======"
    serialized = record.to_yaml
    puts serialized.inspect
    sig = ""
    sig = Digest::SHA1.hexdigest serialized
    puts "GG" + sig.inspect
    AuditLog.create(requester_info: requester_info, event: event, description: description, checksum: sig)
  end


end
