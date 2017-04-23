module DashboardHelper
  def timeout_wording(t)
    distance_of_time_in_words(Date.current.in_time_zone, (t.created_at + t.timeout.seconds))
  end

  def timeout_countdown_old(t)
    (t.created_at + t.timeout.seconds).strftime("%b, %d, %Y")
  end

  def timeout_countdown(t)
    x = []
    (t.created_at + t.timeout.seconds).strftime("%Y, %m, %d, %H, %M, %S, 000").split(",").each_with_index{|a,i| i == 1 ? x << (a.to_i-1) : x << a  }
    x.join(",")
  end  
end
