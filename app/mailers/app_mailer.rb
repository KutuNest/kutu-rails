class AppMailer < ApplicationMailer
  def disputed(t,n)
    @transaction = t
    mail(
      to: n,
      subject: 'PlayKutu: Your transaction is being disputed'
    )
  end

  def failed(t,n)
    @transaction = t
    mail(
      to: n,
      subject: 'PlayKutu: Your transaction is failed'
    )    
  end

  def resolved(t,n)
    @transaction = t
    mail(
      to: n,
      subject: 'PlayKutu: Your transaction has been resolved'
    )    
  end

  def new_transaction(t,n)
    @transaction = t
    mail(
      to: n,
      subject: 'PlayKutu: A new transaction is available'
    )    
  end  

  def receiver_confirmed(t,n)
    @transaction = t
    mail(
      to: n,
      subject: 'PlayKutu: Your transaction is confirmed by receiver'
    )    
  end

  def resolved(t,n)
    @transaction = t
    mail(
      to: n,
      subject: 'PlayKutu: Your transaction dispute is now resolved'
    )    
  end

  def sender_confirmed(t,n)
    @transaction = t
    mail(
      to: n,
      subject: 'PlayKutu: Amount has been sent by sender'
    )    
  end

  def has_finished(t,n)
    mail(
      to: n,
      subject: 'PlayKutu: Your account has completed receive-send'
    )        
  end

  def limit_changed(t,n)
    mail(
      to: n,
      subject: 'PlayKutu: Your member accounts limit has been updated'
    )       
  end

end
