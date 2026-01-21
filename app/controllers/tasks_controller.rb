class TasksController < ApplicationController
  before_action :require_login
  before_action :set_task, only: [:show, :edit, :update, :destroy]  #the set_task callback only runs before show, edit, update, destroy actions

  def index
    @status_filter = params[:status] #which status to filter tasks by
    @sort = params[:sort]  #which column to sort on (due_date,priority,etc.)
    @direction = params[:direction] == "desc" ? "desc" : "asc" #sort direction(asc or desc), defaults to "asc" unless explicitly "desc"
    @tasks = Tasks::Query.new(
      user: current_user,
      status: @status_filter,
      sort: @sort,
      direction: @direction
    ).call

    respond_to do |format|
      format.html
      format.json do
        render json: @tasks.as_json(
          only: [:id, :title, :status, :priority, :due_date, :created_at, :updated_at]
        ), status: :ok
      end
    end
  end


  def show
    respond_to do |format|
      format.html
      format.json do
        render json: @task.as_json(
          only: [:id, :title, :status, :priority, :due_date, :created_at, :updated_at]
        ), status: :ok
      end
    end
  end


  def new
    @task = current_user.tasks.new
  end

  def create  #creates a new task with the strong parameters
    @task = Tasks::Create.new(user: current_user, params: task_params).call

    if @task.persisted?
      flash[:notice] = "Task created."

      respond_to do |format|
        format.html { redirect_to @task }
        format.json do
          render json: @task.as_json(
            only: [:id, :title, :status, :priority, :due_date, :created_at, :updated_at]
          ), status: :created
        end
      end
    else
      flash.now[:alert] = "Could not create task."

      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end


  def edit
  end


  def update
    if Tasks::Update.new(task: @task, params: task_params).call
      flash[:notice] = "Task updated."

      respond_to do |format|
        format.html { redirect_to @task }
        format.json do
          render json: @task.as_json(
            only: [:id, :title, :status, :priority, :due_date, :created_at, :updated_at]
          ), status: :ok
        end
      end
    else
      flash.now[:alert] = "Could not update task."

      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  
  def destroy
    @task.destroy
    flash[:notice] = "Task deleted."

    respond_to do |format|
      format.html { redirect_to tasks_path }
      format.json { head :no_content }
    end
  end

  #defining strong parameters
  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :status, :priority, :due_date)
  end
end
