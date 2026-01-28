class CreateTasksService
  def initialize(user:, params:)
    @user = user
    @params = params
  end

  def call
    @user.tasks.create(@params)
  end
end

# Accepts user inputs and injects the parameters
