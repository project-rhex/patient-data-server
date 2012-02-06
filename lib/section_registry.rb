require 'ostruct'

# A registry where hData extensionIds can be mapped to url paths and vice versa
class SectionRegistry
  include Singleton
  
  def initialize
    @extensions = []
  end
  
  # Adds an hData section to the registry
  # @param [String] path the location in the web application where this section is registered.
  #                      For example: 'results'
  # @param [String] extension_id the URI that identifies the type of the section
  # @param [String] name a human readable name for the section
  # @yield [Hash, Hash] If a block is provided, hashes are given that can be used to add importers
  #                     and exporters. The Hash key should be a String representing a Mime Type. 
  #                     The value should be the importer/exporter.
  def add_section(path, extension_id, name)
    importers = {}
    exporters = {}
    yield importers, exporters if block_given?
    @extensions << OpenStruct.new(path: path, extension_id: extension_id, name: name,
                                  importers: importers, exporters: exporters)
  end
  
  # Finds an extension based on the path passed in
  # @param [String] path the path of the extension you are looking for
  # @return an object that has the name, path, extension, importers and exporters for the path
  def extension_from_path(path)
    @extensions.find {|e| e.path == path}
  end
end


##############################################################
# Register all the sections we will use in the web application
############################################################## 
sr = SectionRegistry.instance

sr.add_section('allergies', 'http://projecthdata.org/hdata/schemas/2009/06/allergy', 'Allergies')
sr.add_section('care_goals', 'http://projecthdata.org/hdata/schemas/2009/06/care_goal', 'Care Goals')
sr.add_section('conditions', 'http://projecthdata.org/hdata/schemas/2009/06/condition', 'Conditions')
sr.add_section('encounters', 'http://projecthdata.org/hdata/schemas/2009/06/encounter', 'Encounters')
sr.add_section('immunizations', 'http://projecthdata.org/hdata/schemas/2009/06/immunization', 'Immunizations')
sr.add_section('medical_equipment', 'http://projecthdata.org/hdata/schemas/2009/06/medical_equipment', 'Medical Equipment')
sr.add_section('medications', 'http://projecthdata.org/hdata/schemas/2009/06/medication', 'Medications')
sr.add_section('procedures', 'http://projecthdata.org/hdata/schemas/2009/06/procedure', 'Procedures')
sr.add_section('results', 'http://projecthdata.org/hdata/schemas/2009/06/result', 'Lab Results') do |importers, exporters|
  importers['application/xml'] = HealthDataStandards::Import::GreenCda::ResultImporter.instance
  exporters['application/xml'] = HealthDataStandards::Export::GreenCda::ExportGenerator.create_exporter_for(:result)
end
sr.add_section('social_history', 'http://projecthdata.org/hdata/schemas/2009/06/social_history', 'Social History')
sr.add_section('vital_signs', 'http://projecthdata.org/hdata/schemas/2009/06/result', 'Vital Signs')
