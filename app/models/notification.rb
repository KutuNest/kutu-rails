class Notification < ApplicationRecord
  belongs_to :transaction
  belongs_to :account

  Types    = {sms: 'S', email: 'E'}
  Statuses = {new: 'N', delivered: 'D', error: 'E'}

  validates :notification_type, presence: true, inclusion: {in: Types.values}
  validates :status, presence: true, inclusion: {in: Statuses.values}
  validates :body, presence: true

  def deliver_sms
    #TODO: 
  end

  def deliver_email
    #TODO:
  end

end
