require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it "has a valid factory" do
      expect(build(:user)).to be_valid
    end

    it "requires a name" do
      user = build(:user, name: nil)

      expect(user).not_to be_valid
      expect(user.errors[:name]).to be_present
    end

    it "requires a valid email" do
      user = build(:user, email: "not-an-email")

      expect(user).not_to be_valid
      expect(user.errors[:email]).to be_present
    end

    it "enforces case-insensitive email uniqueness" do
      create(:user, email: "Test@Example.com")
      user = build(:user, email: "test@example.com")

      expect(user).not_to be_valid
      expect(user.errors[:email]).to be_present
    end

    it "requires a password of at least 8 characters" do
      user = build(:user, password: "short", password_confirmation: "short")

      expect(user).not_to be_valid
      expect(user.errors[:password]).to be_present
    end
  end

  describe "associations" do
    it "destroys tasks when the user is destroyed" do
      user = create(:user)
      create(:task, user: user)

      expect { user.destroy }.to change(Task, :count).by(-1)
    end
  end

  describe "authentication" do
    it "authenticates with the correct password" do
      user = create(:user, password: "password123", password_confirmation: "password123")

      expect(user.authenticate("password123")).to eq(user)
      expect(user.authenticate("wrong")).to be(false)
    end
  end

  describe "callbacks" do
    it "normalizes email before validation" do
      user = create(:user, email: "  TEST@EXAMPLE.COM ")

      expect(user.email).to eq("test@example.com")
    end
  end
end
