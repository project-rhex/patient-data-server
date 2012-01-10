xml.feed :xmlns => "http://www.w3.org/2005/Atom", "xmlns:hrf-md" => "http://www.hl7.org/schemas/hdata/2009/11/metadata" do
  xml.title "Root"
  xml.id root_feed_url(@record.medical_record_number)
  xml.updated @record.updated_at.xmlschema
  xml <<  render(partial: "shared/section", :collection => [:c32] + Record::Sections)
end