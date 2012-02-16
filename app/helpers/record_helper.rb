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
  # @param field that holds the time value
  # @param limit the maximum number of results to return
  def section_enumerator record, section, earliest, field = :time, limit = 6
    entries = record.send(section).all_of(field.gt => earliest.to_i).asc(field).limit(limit)
    count = entries.count
    entries.each do |e|
      yield e
    end
  end

  # Return the sex character from the "gender" field
  def sex record
    record.gender
  end

  # Returns the most recent vital sign that matches formatted
  def latest_matching_vital record, name
    name.downcase!
    match = nil
    mdelta = nil
    today = Time.now
    record.vital_signs.each do |result|
       if result.description.downcase.start_with?(name)
         if match
           delta = today.to_i - result.time.to_i
           if delta < mdelta
             match = result
             mdelta = delta
           end
         else
           match = result
           mdelta = today.to_i - match.time.to_i
         end
       end
    end
    if match
      show_value match.value
    else
      ""
    end
  end

  # Returns the most recent date associated with a vital sign
  def most_recent_vital_date record
    today = Time.now
    mdelta = nil
    record.vital_signs.each do |result|
      desc = result.description.downcase
       if desc.start_with?('bmi') || desc.start_with?('systolic') || desc.start_with?('diastolic')
         if mdelta
           delta = today.to_i - result.time.to_i
           if delta < mdelta
             mdelta = delta
           end
         else
           mdelta = today.to_i - result.time.to_i
         end
       end
    end
    if mdelta
      update = today - mdelta
    else
      nil
    end
  end

  # Takes the value portion of a record and formats it
  def show_value value
    return "" unless value
    scalar = value['scalar']
    units = value['units']
    scalar = scalar.to_s
    return "" unless scalar
    return ("<span class='lab_value'>" + scalar + "</span>").html_safe unless units
    return ("<span class='lab_value'>" + scalar + "&nbps;(" + units + ")</span>").html_safe
  end
end