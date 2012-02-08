module RecordHelper
  def patient_name
    ("<span id='patient_name'>" + @record.last + ',&nbsp;' + @record.first + "</span>").html_safe
  end
end