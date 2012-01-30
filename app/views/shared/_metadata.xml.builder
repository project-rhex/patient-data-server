xml.tag! "hrf-md", :DocumentMetadata  do
  xml.tag!("hrf-md", :MediaType, "application/json")
  xml.tag!("hrf-md", :MediaType, "application/xml")
  xml.tag! "href-md", :PedigreeInfo do
    xml.tag! "href-md", :Author, record.document_metadata.author
    xml.tag! "href-md", :Organization, record.document_metadata.organization
  end
  xml.tag! "href-md", :DocumentId, record.id
  xml.tag! "href-md", :RecordDate do
    xml.tag! "href-md", :CreateDateTime, record.created_at.xmlschema
    xml.tag! "href-md", :Modified do
      xml.tag! "href-md", :ModifiedDate, record.updated_at.xmlschema
      record.versions.each do |version|
        xml.tag! "href-md", :ModifiedDate, version.created_at.xmlschema
      end
    end
  end
end