atom_feed(url: c32s_url(@record.medical_record_number)) do |feed|
  feed.title "C32 JSON"
  feed.entry(@record, :url => c32_json_url(@record.medical_record_number)) do |entry|
    entry.title @record.medical_record_number
  end
end