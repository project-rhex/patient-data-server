xml.instruct!
xml.feed xmlns: "http://www.w3.org/2005/Atom", "xmlns:hrf-md" => "http://projecthdata.org/hdata/schemas/2009/11/metadata" do
  xml.title @record.medical_record_number
  xml.link c32s_url(@record.medical_record_number), rel: "self", type: "application/atom+xml"
  xml.entries do
    xml.entry do
      xml.id @record.medical_record_number
      xml.link :href => c32_url(@record.medical_record_number, @record.medical_record_number), :type => "application/xml"
    end
  end
end