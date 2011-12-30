xml.tag! "hrf-md", :DocumentMetadata, :ContentType => "application/json",  do
  xml.tag! "href-md", :PedigreeInfo do
    xml.tag! "href-md", :Author, record.document_metadata.author
    xml.tag! "href-md", :Organization, record.document_metadata.organization
  end
  xml.tag! "href-md", :DocumentId, record.id
  xml.tag! "href-md", :RecordDate do
    xml.tag! "href-md", :CreateDateTime, record.created_at
    xml.tag! "href-md", :Modified do
      xml.tag! "href-md", :ModifiedDate, record.updated_at
      record.versions.each do |version|
        xml.tag! "href-md", :ModifiedDate, version.created_at 
      end
    end
  end
end