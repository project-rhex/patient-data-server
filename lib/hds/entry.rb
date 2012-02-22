class Entry
  include Mongoid::Timestamps
  include Mongoid::Versioning

  embeds_one :document_metadata

  class << self
    def timelimit(oldest)
      any_of([:time.gt => oldest], [:start_time.gt => oldest])
    end
  end
end