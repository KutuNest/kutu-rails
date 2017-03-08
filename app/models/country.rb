class Country < ApplicationRecord

  has_many :banks, dependent: :nullify
  has_many :members, dependent: :nullify

  validates :title, presence: true, uniqueness: true

end
