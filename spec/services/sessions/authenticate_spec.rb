require "rails_helper"

RSpec.describe SessionsAuthenticateService do
  describe "#call" do
    it "returns the user for valid credentials" do
      user = create(:user, email: "Test@Example.com", password: "password123")

      result = described_class.new(
        email: "  test@example.com ",
        password: "password123"
      ).call

      expect(result).to eq(user)
    end

    it "returns nil for invalid password" do
      user = create(:user, password: "password123")

      result = described_class.new(
        email: user.email,
        password: "wrong-password"
      ).call

      expect(result).to be_nil
    end
  end
end
