class AppMailer < ApplicationMailer
  def notification(notification)
    mail(
      to: notification.receiver_email,
      subject: notification.title
    )
  end
end
