module RecordHelper
  def patient_name
    ("<span id='patient_name'>" + @record.last + ',&nbsp;' + @record.first + "</span>").html_safe
  end

  def record_simple_value string
    "<div class='simple_value'>#{string}</div>".html_safe
  end

  def sex
    @record.gender
  end

  def calculate_age date_value
    date_value = Time.at(date_value) if date_value.class == Fixnum
    now = Time.now
    year_delta = now.year - date_value.year
    return year_delta.to_s + " years" if year_delta >= 2
    return "1 year" if year_delta == 1

    month_delta = now.mon - date_value.mon
    return month_delta.to_s + " months" if month_delta >= 2
    return "1 month" if month_delta if month_delta == 1

    day_delta = now.yday - date_value.yday

    return day_delta.to_s + " days" if day_delta >= 2
    return "1 day" if day_delta == 1
    return "less than a day"
  end

  # Returns the most recent vital sign that matches formatted
  def latest_matching_vital name
    name.downcase!
    match = nil
    mdelta = nil
    today = Time.now
    @record.vital_signs.each do |result|
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
      rval += " " + value['units'] if value['units']
      rval
    else
      ""
    end
  end

  # Returns the most recent date associated with a vital sign
  def most_recent_vital_date
    today = Time.now
    mdelta = nil
    @record.vital_signs.each do |result|
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
end