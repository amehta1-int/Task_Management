class UpdateTasksService
  def initialize(task:, params:)
    @task = task
    @params = params
  end

  def call
    @task.update(@params)
  end
end

# Accepts the parameters and calls for updates
