require 'section_registry'

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
  importers['application/xml'] = HealthDataStandards::Import::GreenC32::ResultImporter.instance
  exporters['application/xml'] = HealthDataStandards::Export::GreenC32::ExportGenerator.create_exporter_for(:result)
end
sr.add_section('social_history', 'http://projecthdata.org/hdata/schemas/2009/06/social_history', 'Social History')
sr.add_section('vital_signs', 'http://projecthdata.org/hdata/schemas/2009/06/result', 'Vital Signs')
