xml.entry do
  xml.id entry.id
  if entry.updated_at
    xml.updated entry.updated_at
  end
  xml.link :href => section_document_url(@record.medical_record_number, @section_name, entry), :type => "application/json"
  if entry.document_metadata
    xml << render(:partial => "shared/metadata.xml.builder", locals: {record: entry}, formats: 'xml')
  end
end
