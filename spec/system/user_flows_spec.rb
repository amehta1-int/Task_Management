require "rails_helper"

RSpec.describe "User flows", type: :system do
  it "allows a user to sign up" do
    visit signup_path

    fill_in "Name", with: "Capy User"
    fill_in "Email", with: "capy@example.com"
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "password123"
    click_button "Sign up"

    expect(page).to have_content("Account created. You are now logged in.")
    expect(page).to have_content("Your Tasks")
  end

  it "allows a user to log in" do
    user = create(:user, email: "login@example.com", password: "password123")

    login_as_system(user, password: "password123")

    expect(page).to have_content("Logged in successfully.")
    expect(page).to have_content("Your Tasks")
  end

  it "allows creating a task" do
    user = create(:user)
    login_as_system(user)

    click_link "New Task"

    fill_in "Title", with: "Capybara task"
    select "Todo", from: "Status"
    select "High", from: "Priority"
    fill_in "Due date", with: (Date.current + 2).strftime("%Y-%m-%d")
    click_button "Create Task"

    expect(page).to have_content("Task created.")
    expect(page).to have_content("Capybara task")
  end

  it "allows editing a task" do
    user = create(:user)
    task = create(:task, user: user, title: "Old title")
    login_as_system(user)

    click_link "Edit", href: edit_task_path(task)
    fill_in "Title", with: "Updated title"
    click_button "Update Task"

    expect(page).to have_content("Task updated.")
    expect(page).to have_content("Updated title")
  end

  it "allows deleting a task" do
    user = create(:user)
    task = create(:task, user: user, title: "Delete me")
    login_as_system(user)

    click_button "Delete", match: :first

    expect(page).to have_content("Task deleted.")
    expect(page).not_to have_content("Delete me")
  end
end
