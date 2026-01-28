require "rails_helper"

RSpec.describe UpdateTasksService do
  describe "#call" do
    it "updates a task with valid params" do
      task = create(:task, title: "Old title")

      result = described_class.new(
        task: task,
        params: { title: "New title" }
      ).call

      expect(result).to be(true)
      expect(task.reload.title).to eq("New title")
    end

    it "does not update with invalid params" do
      task = create(:task, title: "Keep me")

      result = described_class.new(
        task: task,
        params: { title: nil }
      ).call

      expect(result).to be(false)
      expect(task.reload.title).to eq("Keep me")
    end
  end
end
