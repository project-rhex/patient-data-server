atom_feed(url: root_feed_url(@record.medical_record_number)) do |feed|
  feed.title "Root"
  feed.entry("c32", id: "c32", url: c32s_url(@record.medical_record_number)) {}
  feed.entry("c32-json", id: "c32-json", url: c32_json_list_url(@record.medical_record_number)) {}
  render(partial: "shared/section", :collection => Record::Sections, locals: {feed: feed})
end