require 'ostruct'

# A registry where hData extensionIds can be mapped to url paths and vice versa
class SectionRegistry
  include Singleton
  
  def initialize
    @extensions = []
  end
  
  def add_section(path, extension_id, name)
    @extensions << OpenStruct.new(path: path, extension_id: extension_id, name: name)
  end
  
  def extension_from_path(path)
    @extensions.find {|e| e.path == path}
  end
end

sr = SectionRegistry.instance

sr.add_section('allergies', 'http://projecthdata.org/hdata/schemas/2009/06/allergy', 'Allergies')
sr.add_section('care_goals', 'http://projecthdata.org/hdata/schemas/2009/06/care_goal', 'Care Goals')
sr.add_section('conditions', 'http://projecthdata.org/hdata/schemas/2009/06/condition', 'Conditions')
sr.add_section('encounters', 'http://projecthdata.org/hdata/schemas/2009/06/encounter', 'Encounters')
sr.add_section('immunizations', 'http://projecthdata.org/hdata/schemas/2009/06/immunization', 'Immunizations')
sr.add_section('medical_equipment', 'http://projecthdata.org/hdata/schemas/2009/06/medical_equipment', 'Medical Equipment')
sr.add_section('medications', 'http://projecthdata.org/hdata/schemas/2009/06/medication', 'Medications')
sr.add_section('procedures', 'http://projecthdata.org/hdata/schemas/2009/06/procedure', 'Procedures')
sr.add_section('results', 'http://projecthdata.org/hdata/schemas/2009/06/result', 'Lab Results')
sr.add_section('social_history', 'http://projecthdata.org/hdata/schemas/2009/06/social_history', 'Social History')
sr.add_section('vital_signs', 'http://projecthdata.org/hdata/schemas/2009/06/result', 'Vital Signs')
