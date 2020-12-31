module ApplicationHelper
  def boolean_to_check_mark(value)
    if value
      content_tag(:i, 'check', class: 'material-icons success')
    else
      ""
    end
  end
end
