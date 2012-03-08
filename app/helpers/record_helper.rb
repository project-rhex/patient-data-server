module RecordHelper
  # Enumerate the entries in a section, formatting each one in a passed block
  # if the section doesn't exist render nothing.
  #
  # @param record the record which is assumed to not be nil
  # @param section the name of the section
  # @param earliest the earliest time to render an entry
  # @param limit the maximum number of results to return
  def section_enumerator(record, section, earliest, limit = 6)
    record.find_sorted_entries_by_timelimit(section, earliest.to_i, limit).each do |e|
      yield e
    end
  end

  # Return the sex character from the "gender" field
  def sex(record)
    record.gender =~ /[Mm]/ ? "Male" : "Female"
  end

  # Returns the most recent vital sign that matches formatted
  def latest_matching_vital(record, name)
    name.downcase!
    vitals = record.get_recent_vitals
    record.vital_signs.each do |result|
       if result.description.downcase.start_with?(name)
         return show_value result.value
       end
    end
    ""
  end

  # Returns the most recent date associated with a vital sign
  def most_recent_vital_date(record)
    vitals = record.get_recent_vitals
    if vitals.count > 0
      vital = vitals.first
      vital.time
    else
      nil
    end
  end

  # Takes the value portion of a record and formats it
  def show_value(value, low = -1E99, high = 1E99)
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
    u = "&nbsp;(" + units + ")" if units
    return ("<span class='lab_value" + oor + "'>" + s + u + "</span>").html_safe
  end


end