class Project < ApplicationRecord
  audited

  VALID_STATUSES = %w[planning pending in_progress completed].freeze

  belongs_to :user, optional: false
  has_many :comments, dependent: :destroy


  enum status: VALID_STATUSES

  validates :title, presence: true
  validates :status, inclusion: { in: VALID_STATUSES, message: "Wrong project status" }
end
