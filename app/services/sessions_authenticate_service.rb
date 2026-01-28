class SessionsAuthenticateService
  def initialize(email:, password:)
    @email = email.to_s.strip.downcase
    @password = password
  end

  def call
    user = User.find_by(email: @email)
    return nil unless user&.authenticate(@password)

    user
  end
end

# this just checks if the user exists. The session creation is done in login
