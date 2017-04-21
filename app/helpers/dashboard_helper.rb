module DashboardHelper
  def timeout_wording(t)
    distance_of_time_in_words(DateTime.now, (t.created_at + t.timeout.seconds))
  end

  def timeout_countdown(t)
    (t.created_at + t.timeout.seconds).strftime("%b, %d, %Y")
  end
end
