module RecordHelper
  def patient_name
    ("<span id='patient_name'>" + @record.last + ',&nbsp;' + @record.first + "</span>").html_safe
  end

  def record_simple_value string
    "<div class='simple_value'>#{string}</div>".html_safe
  end

  def calculate_age date_value
    date_value = Time.at(date_value) if date_value.class == Fixnum
    now = Time.now
    (now.year - date_value.year).to_s
  end
end