atom_feed(url: record_c32_index_url(@record.medical_record_number)) do |feed|
  feed.title "C32"
  feed.entry(@record, :url => record_c32_url(@record.medical_record_number, @record.medical_record_number)) do |entry|
    entry.title @record.medical_record_number
  end
end