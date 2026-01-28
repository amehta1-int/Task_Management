require "rails_helper"

RSpec.describe Users::SignUp do
  describe "#call" do
    it "creates a new user" do
      user = described_class.new(
        params: {
          name: "New User",
          email: "newuser@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      ).call

      expect(user).to be_persisted
      expect(user.email).to eq("newuser@example.com")
    end

    it "raises when validations fail" do
      expect do
        described_class.new(
          params: {
            name: "",
            email: "not-an-email",
            password: "short",
            password_confirmation: "short"
          }
        ).call
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
