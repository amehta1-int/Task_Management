require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "GET /signup" do
    it "renders the signup page" do
      get signup_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Create your account")
    end
  end

  describe "POST /signup" do
    it "creates a user with valid params" do
      expect do
        post signup_path, params: {
          user: {
            name: "New User",
            email: "new@example.com",
            password: "password123",
            password_confirmation: "password123"
          }
        }
      end.to change(User, :count).by(1)

      expect(response).to redirect_to(tasks_path)
    end

    it "re-renders when invalid" do
      expect do
        post signup_path, params: {
          user: {
            name: "",
            email: "bad",
            password: "short",
            password_confirmation: "short"
          }
        }
      end.not_to change(User, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Please fix the errors below.")
    end

    it "returns JSON on success" do
      post signup_path, params: {
        user: {
          name: "Json User",
          email: "json@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }, as: :json

      expect(response).to have_http_status(:created)
      expect(response.parsed_body["user_id"]).to be_present
    end

    it "returns JSON errors on failure" do
      post signup_path, params: {
        user: {
          name: "",
          email: "bad",
          password: "short",
          password_confirmation: "short"
        }
      }, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body["errors"]).to be_present
    end
  end
end
