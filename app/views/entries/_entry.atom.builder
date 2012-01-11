feed.entry(entry, id: entry.id, url: section_document_url(@record.medical_record_number, @section_name, entry), type: "application/json") do |feed_entry|
  feed_entry.title entry.description if entry.respond_to?(:description)
  if entry.document_metadata
    render(:partial => "shared/metadata.xml.builder", locals: {record: entry}, formats: 'xml')
  end
end