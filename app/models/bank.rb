class Bank < ApplicationRecord
  belongs_to :country, required: false
  has_many :members, dependent: :nullify

  validates :title, presence: true, uniqueness: true
end
