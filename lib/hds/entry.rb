class Entry
  include Mongoid::Timestamps
  include Mongoid::Versioning
  
  embeds_one :document_metadata
end