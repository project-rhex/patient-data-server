atom_feed do |feed|
  @records.each do |record|
    feed.entry(record, url: root_feed_path(record.medical_record_number)) do |entry|
      entry.link rel: "alternate", type: Mime::Atom, href: root_feed_path(record.medical_record_number)
      entry.link rel: "root", type: Mime::XML, href: root_document_path(record.medical_record_number)
      entry.title record.last + ', ' + record.first
    end
  end
end