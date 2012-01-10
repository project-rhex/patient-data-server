atom_feed do |feed|
  feed.title "Records"
  @records.each do |record|
    feed.entry(record) do |entry|
      entry.title record.medical_record_number
    end
  end
end