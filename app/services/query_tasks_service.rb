class QueryTasksService
  def initialize(user:, status: nil, sort: nil, direction: "asc")
    @user = user
    @status = status
    @sort = sort
    @direction = direction == "desc" ? "desc" : "asc"
  end

  def call
    scope = @user.tasks
    scope = scope.by_status(@status)

    case @sort
    when "due_date"
      scope.order(due_date: @direction)
    when "priority"
      scope.order(priority: @direction)
    else
      scope.order(created_at: :desc)
    end
  end
end

# Accepts the filtering and sorting parameters, retrieves data from db and sorts and filters accordingly
