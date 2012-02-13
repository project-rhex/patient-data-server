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
  def section_enumerator record, section, earliest
    entries = record[section]
    earliest = earliest.to_i if earliest.class == Time
    return unless entries
    entries.each do |e|
      rtime = e['time'] || e['start_time']
      next if rtime <= earliest
      yield e
    end
  end

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
      value = match.value
      rval = value['scalar']
      rval = rval.to_s
      rval += " " + value['units'] if value['units']
      rval
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
  def lab_result_value value
    return "" unless value
    scalar = value['scalar']
    units = value['units']
    return "" unless scalar
    return "<span class='lab_value'>" + scalar + "</span>".html_safe unless units
    return "<span class='lab_value'>" + scalar + "(" + units + ")</span>".html_safe unless units
  end
end