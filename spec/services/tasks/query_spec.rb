require "rails_helper"

RSpec.describe QueryTasksService do
  describe "#call" do
    it "filters by status when provided" do
      user = create(:user)
      todo_task = create(:task, user: user, status: :todo)
      done_task = create(:task, user: user, status: :done)

      results = described_class.new(user: user, status: "todo").call

      expect(results).to contain_exactly(todo_task)
      expect(results).not_to include(done_task)
    end

    it "sorts by due date when requested" do
      user = create(:user)
      earlier = create(:task, user: user, due_date: Date.current + 1)
      later = create(:task, user: user, due_date: Date.current + 3)

      results = described_class.new(
        user: user,
        sort: "due_date",
        direction: "asc"
      ).call

      expect(results.first).to eq(earlier)
      expect(results.last).to eq(later)
    end

    it "defaults to created_at desc for unknown sort" do
      user = create(:user)
      older = create(:task, user: user, created_at: 2.days.ago)
      newer = create(:task, user: user, created_at: 1.day.ago)

      results = described_class.new(user: user, sort: "unknown").call

      expect(results.first).to eq(newer)
      expect(results.last).to eq(older)
    end

    it "ignores invalid direction and defaults to asc" do
      user = create(:user)
      low = create(:task, user: user, priority: :low)
      high = create(:task, user: user, priority: :high)

      results = described_class.new(
        user: user,
        sort: "priority",
        direction: "sideways"
      ).call

      expect(results.first).to eq(low)
      expect(results.last).to eq(high)
    end
  end
end
