module ApplicationHelper
  # Expand the breadcrumbs from the controller into a breadcrumbs bar
  def show_breadcrumbs
    rval = ""
    breadcrumbs.each do |x|
      rval += "&nbsp;|&nbsp;" if rval.length > 0
      if x[:link].nil?
        rval += x[:title]
      else
        rval += "<a href='#{x[:link]}'>#{x[:title]}</a>"
      end
    end
    rval.html_safe
  end

  # Create a field/value combination that can be styled
  def labeled_field label, value, field_class = 'labeled_field'
    ("<div class='" + field_class + "'><span class='label'>#{label}</span><span class='value'>#{value}</span></div>").html_safe
  end

  # Show the date, formatted
  def date date_value, default = 'never'
    if date_value
      date_value = Time.at(date_value) if date_value.class == Fixnum
      date_value.strftime("%d-%b-%Y")
    else
      default
    end
  end
end
