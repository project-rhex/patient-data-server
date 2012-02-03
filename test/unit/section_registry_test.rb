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
end
