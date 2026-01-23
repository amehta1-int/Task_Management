require "rails_helper"

RSpec.describe Task, type: :model do
  describe "validations" do
    it "has a valid factory" do
      expect(build(:task)).to be_valid
    end

    it "requires a title" do
      task = build(:task, title: nil)

      expect(task).not_to be_valid
      expect(task.errors[:title]).to be_present
    end

    it "requires a status" do
      task = build(:task, status: nil)

      expect(task).not_to be_valid
      expect(task.errors[:status]).to be_present
    end

    it "requires a priority" do
      task = build(:task, priority: nil)

      expect(task).not_to be_valid
      expect(task.errors[:priority]).to be_present
    end
  end

  describe "associations" do
    it "requires a user" do
      task = build(:task, user: nil)

      expect(task).not_to be_valid
      expect(task.errors[:user]).to be_present
    end
  end

  describe "enums" do
    it "defines status values" do
      expect(described_class.statuses.keys).to contain_exactly("todo", "in_progress", "done")
    end

    it "defines priority values" do
      expect(described_class.priorities.keys).to contain_exactly("low", "medium", "high")
    end
  end

  describe ".by_status" do
    it "returns tasks matching the given status" do
      todo_task = create(:task, status: :todo)
      done_task = create(:task, status: :done)

      expect(described_class.by_status("todo")).to contain_exactly(todo_task)
      expect(described_class.by_status("todo")).not_to include(done_task)
    end

    it "returns all tasks for invalid status" do
      create(:task, status: :todo)
      create(:task, status: :done)

      expect(described_class.by_status("invalid")).to match_array(described_class.all)
    end
  end
end
