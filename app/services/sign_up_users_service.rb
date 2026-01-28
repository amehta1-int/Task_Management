class SignUpUsersService
  def initialize(params:)
    @params = params
  end

  def call
    user = User.new(@params)

    ActiveRecord::Base.transaction do
      user.save!
    end

    user
  end
end

# Initializes parameters and creates and saves the user with those parameters
