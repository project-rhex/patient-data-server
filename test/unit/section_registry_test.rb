require 'test_helper'
require 'section_registry'

class SectionRegistryTest < ActiveSupport::TestCase
  test 'finding an extension by path' do
    sr = SectionRegistry.instance
    e = sr.extension_from_path('allergies')
    assert_equal 'http://projecthdata.org/hdata/schemas/2009/06/allergy', e.extension_id
    
    e = sr.extension_from_path('bacon')
    refute e
  end
  
  test 'exporters and importers are there' do
    sr = SectionRegistry.instance
    e = sr.extension_from_path('results')
    lab_exporter = e.exporters['application/xml']
    assert lab_exporter
    assert lab_exporter.respond_to? :export
    lab_importer = e.importers['application/xml']
    assert lab_importer
    assert lab_importer.respond_to? :import
  end
end
