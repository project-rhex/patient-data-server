module ApplicationHelper
  # Expand the breadcrumbs from the controller into a breadcrumbs bar
  def breadcrumbs
    breadcrumbs = ""
    controller.breadcrumbs.each do |x|
      breadcrumbs += "&nbsp;|&nbsp;" if breadcrumbs.length > 0
      breadcrumbs += "<a href='#{x[:link]}'>#{x[:title]}</a>"
    end
    breadcrumbs.html_safe
  end

  # Create a field/value combination that can be styled
  def labeled_field label, value
    "<div class='labeled_field'><span class='label'>#{label}</span><span class='value'>#{value}</span></div>".html_safe
  end

  # Show the date, formatted
  def date date_value
    date_value = Time.at(date_value) if date_value.class == Fixnum
    date_value.strftime("%m/%d/%Y")
  end
end
