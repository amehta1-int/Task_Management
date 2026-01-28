require "rails_helper"

RSpec.describe Tasks::Create do
  describe "#call" do
    it "creates a task for the user" do
      user = create(:user)

      task = described_class.new(
        user: user,
        params: { title: "Write specs", status: "todo", priority: "low" }
      ).call

      expect(task).to be_persisted
      expect(task.user).to eq(user)
      expect(task.title).to eq("Write specs")
    end
  end
end
