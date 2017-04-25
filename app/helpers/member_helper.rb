module MemberHelper

  def custom_error_message(member, field)
    if member.errors.to_a.any?
      ("<span class='error'>" + member.errors[field].first.to_s + "</span>").html_safe
    else
    end
  end

end
