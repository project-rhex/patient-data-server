feed.entry(section, {id: section.to_s, url: section_feed_url(@record.medical_record_number, section)}) do |entry|
  xml.title section_feed_path(@record.medical_record_number, section)
end