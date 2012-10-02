module RecordHelper
  # Enumerate the entries in a section, formatting each one in a passed block
  # if the section doesn't exist render nothing.
  #
  # @param record the record which is assumed to not be nil
  # @param section the name of the section
  # @param earliest the earliest time to render an entry
  # @param limit the maximum number of results to return
  def section_enumerator(record, section)
    record.send(section).each do |e|
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
       if result.description && result.description.downcase.start_with?(name)
         return show_value result.values.first
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

  def show_values(values)
    show_value(values.first)
  end

  # Takes the value portion of a record and formats it
  def show_value(value, low = -1E99, high = 1E99)
    return "" unless value && value.scalar
    scalar = value.scalar
    output = scalar.is_a?(Integer) ? scalar.to_s : number_with_precision(scalar, precision: 2)
    output << " (#{value.units})" if value.units
    "<span class='lab_value'>#{output}</span>"
  end


end
