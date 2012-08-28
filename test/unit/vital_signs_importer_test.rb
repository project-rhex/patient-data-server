require 'test_helper'
require 'tatrc/vital_signs_importer'
class VitalSignsImporterTest < ActiveSupport::TestCase

  def test_import
    file = File.new("test/fixtures/sample_vital_signs.xml")
    vital_signs = TATRC::VitalSignsImporter.instance.import(file.read)
    assert_equal 6, vital_signs.size
    vs = vital_signs.first
    assert_equal "8480-6", vs.codes["LOINC"].first
    assert_equal "Systolic BP", vs.description
    assert_equal 115.0, vs.values.first.scalar
    assert_equal "mm[Hg]", vs.values.first['units']
  end
end
