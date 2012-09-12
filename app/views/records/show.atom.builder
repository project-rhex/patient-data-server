atom_feed do |feed|
  feed.entry("c32", url: root_feed_path(@record.medical_record_number), id: "/c32") do |entry|
    
  end
  SectionRegistry.instance.extensions.each do |section|
    feed.entry(section.name, url: section_feed_path(@record.medical_record_number, section.path), id: "/#{section.path}") do |atom_entry|
      atom_entry.link(rel: "alternate", type: Mime::Atom, href: section_feed_path(@record.medical_record_number, section.path))
      atom_entry.title(section.name)
    end
  end
end