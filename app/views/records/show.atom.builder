atom_feed(url: root_feed_url(@record.medical_record_number)) do |feed|
  feed.title "Root"
  feed.entry("c32", id: "c32", url: record_c32_index_url(@record.medical_record_number)) {}
  render(partial: "shared/section", :collection => Record::Sections, locals: {feed: feed})
end