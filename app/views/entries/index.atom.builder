atom_feed do |feed|
  feed.title "/#{@section_name}"
  render(partial: "entry", :collection => @entries, locals: {feed: feed})
end