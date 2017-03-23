module ApplicationHelper
  def fix_url(str)
    str.starts_with?('http://') ? str : 'http://' + str
  end

  def format_date(date)
    date.strftime('%A, %B %d, %Y')
  end
end
