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
  def labeled_field(label, value, field_class = 'labeled_field')
    ("<div class='" + field_class + "'><span class='label'>#{label}</span><span class='value'>#{value}</span></div>").html_safe
  end

  def safe_date(date_value, default = 'never')
    if date_value
      if date_value.class == Fixnum or date_value.class == Bignum
        yield Time.at(date_value)
      else
        yield date_value
      end
    else
      default
    end
  end

  def getAgeText(birthdate)
    safe_date(birthdate, "Forever Young") {|d| date(d) + "&nbsp;(" + time_ago_in_words(d) + " old)"}
  end

  # Show the date, formatted
  def date(date_value, default = 'never')
    safe_date(date_value, default) {|d| d.strftime("%d-%b-%Y")}
  end
end
