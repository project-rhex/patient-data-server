xml.instruct!
xml.feed :xmlns => "http://www.w3.org/2005/Atom", "xmlns:hrf-md" => "http://projecthdata.org/hdata/schemas/2009/11/metadata" do
  xml.title "Root"
  xml.link root_feed_path(@record.medical_record_number)
    xml.entries do
      xml <<  render(partial: "shared/section", :collection => Record::Sections)
    end
end