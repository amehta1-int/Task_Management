require "rails_helper"

RSpec.describe "Home", type: :request do
  describe "GET /" do
    it "redirects to login when logged out" do
      get root_path

      expect(response).to redirect_to(login_path)
    end

    it "redirects to tasks when logged in" do
      user = create(:user)
      login_as(user)

      get root_path

      expect(response).to redirect_to(tasks_path)
    end
  end
end
