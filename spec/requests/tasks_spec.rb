require "rails_helper"

RSpec.describe "Tasks", type: :request do
  describe "GET /tasks" do
    it "redirects to login when logged out" do
      get tasks_path

      expect(response).to redirect_to(login_path)
    end

    it "returns unauthorized for JSON requests when logged out" do
      get tasks_path, as: :json

      expect(response).to have_http_status(:unauthorized)
    end

    it "renders tasks index when logged in" do
      user = create(:user)
      login_as(user)
      create(:task, user: user, title: "Test task")

      get tasks_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Your Tasks")
      expect(response.body).to include("Test task")
    end

    it "returns JSON list for logged-in user" do
      user = create(:user)
      login_as(user)
      create(:task, user: user, title: "API task")

      get tasks_path, as: :json

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.first["title"]).to eq("API task")
    end
  end

  describe "POST /tasks" do
    it "creates a task with valid params" do
      user = create(:user)
      login_as(user)

      expect do
        post tasks_path, params: {
          task: {
            title: "New task",
            status: "todo",
            priority: "high",
            due_date: Date.current + 2
          }
        }
      end.to change(Task, :count).by(1)

      expect(response).to have_http_status(:found)
    end

    it "re-renders when invalid" do
      user = create(:user)
      login_as(user)

      post tasks_path, params: {
        task: { title: "", status: "todo", priority: "low" }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Could not create task.")
    end
  end

  describe "PATCH /tasks/:id" do
    it "updates a task with valid params" do
      user = create(:user)
      login_as(user)
      task = create(:task, user: user, title: "Old")

      patch task_path(task), params: { task: { title: "Updated" } }

      expect(response).to redirect_to(task_path(task))
      expect(task.reload.title).to eq("Updated")
    end

    it "re-renders when invalid" do
      user = create(:user)
      login_as(user)
      task = create(:task, user: user, title: "Old")

      patch task_path(task), params: { task: { title: "" } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Could not update task.")
    end

    it "prevents updating another user's task" do
      owner = create(:user)
      other = create(:user)
      task = create(:task, user: owner)
      login_as(other)

      patch task_path(task), params: { task: { title: "Nope" } }

      expect(response).to have_http_status(:not_found)
      expect(task.reload.title).not_to eq("Nope")
    end
  end

  describe "DELETE /tasks/:id" do
    it "deletes the task" do
      user = create(:user)
      login_as(user)
      task = create(:task, user: user)

      expect do
        delete task_path(task)
      end.to change(Task, :count).by(-1)

      expect(response).to redirect_to(tasks_path)
    end
  end

  describe "GET /tasks/:id" do
    it "returns task JSON for the owner" do
      user = create(:user)
      login_as(user)
      task = create(:task, user: user, title: "Show me")

      get task_path(task), as: :json

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body["title"]).to eq("Show me")
    end
  end
end
