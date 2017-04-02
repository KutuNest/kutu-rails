module ApplicationHelper
  def page_title(title)
    content_for :title, title.to_s
  end
end
