module RecordHelper
  def patient_name record
    ("<span id='patient_name'>" + record.last + ',&nbsp;' + record.first + "</span>").html_safe
  end

  def record_simple_value string
    "<div class='simple_value'>#{string}</div>".html_safe
  end

  # Enumerate the entries in a section, formatting each one in a passed block
  # if the section doesn't exist render nothing.
  #
  # @param record the record which is assumed to not be nil
  # @param section the name of the section
  # @param earliest the earliest time to render an entry
  # @param limit the maximum number of results to return
  def section_enumerator record, section, earliest, limit = 6
    e = earliest.to_i
    entries = record.send(section).any_of([:time.gt => e], [:start_time.gt => e]).limit(limit)
    now = Time.now
    recs = entries.to_a
    recs.sort! do |x, y|
      t1 = x.time || x.start_time || now.to_i
      t2 = y.time || y.start_time || now.to_i
      t2 <=> t1
    end
    recs.each do |e|
      yield e
    end
  end

  # Translate a section title to it's localized value '
  def section_title section
    title = I18n.t("section." + section.to_s)
    "<h2>#{title}</h2>".html_safe
  end

  # Link to history display for the section
  def section_history_link record, section
    id = record.id

    "<a href='/records/#{id}/#{section.to_s}'><<&nbsp;Past #{section_title}</a>".html_safe
  end

  # Return the sex character from the "gender" field
  def sex record
    record.gender =~ /[Mm]/ ? "Male" : "Female"
  end

  # Returns the most recent vital sign that matches formatted
  def latest_matching_vital record, name
    name.downcase!
    vitals = get_recent_vitals record
    record.vital_signs.each do |result|
       if result.description.downcase.start_with?(name)
         return show_value result.value
       end
    end
    ""
  end

  # Returns the most recent date associated with a vital sign
  def most_recent_vital_date record
    vitals = get_recent_vitals record
    if vitals.count > 0
      vital = vitals.first
      vital.time
    else
      nil
    end
  end

  # Takes the value portion of a record and formats it
  def show_value value, low = -1E99, high = 1E99
    return "" unless value
    s = value['scalar']
    units = value['units']
    if s.class == Fixnum || s.class == Float
      n = s;
      n = n.round(2) if n.class == Float
      s = n.to_s;
    elsif s =~ /[+-]?[[:digit:]]+\.?[[:digit:]]*/
      n = s.to_f.round(2)
      s = n.to_s
    else
      n = 0
    end
    return "" unless s
    oor = ""
    oor = " out-of-range-value" if n < low || n > high
    u = ""
    u = "&nbps;(" + units + ")" if units
    return ("<span class='lab_value" + oor + "'>" + s + u + "</span>").html_safe
  end

  private

  # Return recent vitals for use in helper methods, presorted by time descending
  def get_recent_vitals record
    earliest = Time.now - (2 * 365 * 24 * 3600) # About 2 years
    record.vital_signs.all_of(:time.gt => earliest.to_i).desc(:time)
  end
end