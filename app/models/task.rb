class Task < ApplicationRecord
  belongs_to :user

  enum :status,   { todo: 0, in_progress: 1, done: 2 }
  enum :priority, { low: 0, medium: 1, high: 2 }

  validates :title, presence: true
  validates :status, presence: true
  validates :priority, presence: true

  scope :by_status, ->(status) do   #defines a scope, that accepts the status, converts it to valid enums and return all those tasks with the status
    return all if status.blank?

    valid_statuses = Array(status).select { |value| statuses.key?(value) }
    if valid_statuses.any?
      where(status: valid_statuses)
    else
      all
    end
  end
end