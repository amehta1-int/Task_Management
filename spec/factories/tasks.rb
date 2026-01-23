FactoryBot.define do
  factory :task do
    association :user
    title { "Sample task" }
    status { :todo }
    priority { :medium }
    due_date { Date.current + 1 }
  end
end
