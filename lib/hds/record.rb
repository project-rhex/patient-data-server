class Record
  include Mongoid::Timestamps
  include Mongoid::Versioning

  #-------------------------------------------------------------------------
  # Find a set of entries in the given section and return them sorted
  # by the start_time or time, whichever is present for the given entry.
  def find_sorted_entries_by_timelimit(section, oldest,limit)
    # entries = record.send(section).any_of([:time.gt => e], [:start_time.gt => e]).limit(limit)
    entries = send(section).timelimit(oldest).limit(limit)
    now = Time.now
    recs = entries.to_a
    recs.sort! do |x, y|
      t1 = x.time || x.start_time || now.to_i
      t2 = y.time || y.start_time || now.to_i
      t2 <=> t1
    end
    recs
  end

  def to_xml(args)
    HealthDataStandards::Export::C32.export(self)
  end
end