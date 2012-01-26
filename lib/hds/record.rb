class Record
  include Mongoid::Timestamps
  include Mongoid::Versioning

  def to_xml(x)
    binding.pry
    HealthDataStandards::Export::C32.export(@record)
  end
end