class Record
  include Mongoid::Timestamps
  include Mongoid::Versioning

  def to_xml(args)
    HealthDataStandards::Export::C32.export(self)
  end
end