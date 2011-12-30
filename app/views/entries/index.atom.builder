xml.instruct!
xml.feed xmlns: "http://www.w3.org/2005/Atom", "xmlns:hrf-md" => "http://projecthdata.org/hdata/schemas/2009/11/metadata" do
  xml.title "/" + @section_name
  xml.link section_feed_url(@record.medical_record_number, @section_name), rel: "self", type: "application/atom+xml"
  xml.entries do
    unless @entries.empty?
      xml <<  render(partial: "entry", :collection => @entries)
    end
  end
end