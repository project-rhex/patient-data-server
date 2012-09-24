atom_feed do |feed|
  
  @entries.each do |entry|

    feed.entry(entry, url: section_document_path(@record.medical_record_number, @section_name, entry.id), type: "application/xml") do |atom_entry|
      atom_entry.link(rel: "alternate", type: Mime::XML, href: section_document_path(@record.medical_record_number, @section_name, entry._id))
      atom_entry.link(rel: "alternate", type: Mime::Json, href: section_document_path(@record.medical_record_number, @section_name, entry._id))
    end
      
  end
end