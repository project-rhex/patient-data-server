xml.entry do
  xml.id section_feed_url(@record.medical_record_number, section)
  xml.title section_feed_path(@record.medical_record_number, section)
  xml.link :href => section_feed_url(@record, section), :type => "application/atom+xml"
end