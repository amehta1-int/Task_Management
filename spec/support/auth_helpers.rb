module AuthHelpers
  def login_as(user, password: "password123")
    post login_path, params: { email: user.email, password: password }
  end

  def login_as_system(user, password: "password123")
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: password
    click_button "Login"
  end
end

RSpec.configure do |config|
  config.include AuthHelpers, type: :request
  config.include AuthHelpers, type: :system
end
