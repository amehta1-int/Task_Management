class Task < ApplicationRecord
  belongs_to :user

  enum :status,   { todo: 0, in_progress: 1, done: 2 }
  enum :priority, { low: 0, medium: 1, high: 2 }

  validates :title, presence: true
  validates :status, presence: true
  validates :priority, presence: true

  scope :by_status, ->(s) do   #to use this scope we write by_status()
    return all if s.blank?     #Return all tasks if the status is left blank
    return all unless statuses.key?(s)   #If status is valid, then return all tasks that match the status
    where(status: statuses[s])
  end
end
