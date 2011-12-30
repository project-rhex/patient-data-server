xml.entry do
  xml.id section.to_s
  xml.link :href => section_feed_url(@record, section), :type => "application/atom+xml"
end