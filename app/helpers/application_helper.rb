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
end
