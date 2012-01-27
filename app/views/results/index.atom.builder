index = 1
atom_feed do |feed|
  feed.title "Results"
  @record.results.each do |result|
    feed.entry(result, rel: 'content', type: "application/json", url: results_url(@record.medical_record_number) + "/" + index.to_s) do |entry|
      entry.title(result.description + ', result ' + index.to_s)
      index += 1
    end
  end
end