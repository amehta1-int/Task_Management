require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "GET /login" do
    it "renders the login page" do
      get login_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Login")
    end
  end

  describe "POST /login" do
    it "logs in with valid credentials" do
      user = create(:user, password: "password123")

      post login_path, params: { email: user.email, password: "password123" }

      expect(response).to redirect_to(tasks_path)
    end

    it "re-renders on invalid credentials" do
      user = create(:user, password: "password123")

      post login_path, params: { email: user.email, password: "wrong" }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Invalid email or password.")
    end

    it "returns JSON with user id on success" do
      user = create(:user, password: "password123")

      post login_path, params: { email: user.email, password: "password123" }, as: :json

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body["user_id"]).to eq(user.id)
    end
  end

  describe "DELETE /logout" do
    it "logs out and redirects to login" do
      user = create(:user)
      login_as(user)

      delete logout_path

      expect(response).to redirect_to(login_path)
    end

    it "returns JSON on logout" do
      user = create(:user)
      login_as(user)

      delete logout_path, as: :json

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body["message"]).to eq("Logged out.")
    end
  end
end
