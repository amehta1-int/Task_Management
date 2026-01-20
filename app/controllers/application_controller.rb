#In ApplicationController, we usually put shared logic that should be available across the entire app. This is because all controllers inherit application_controller
#Therefore we can anytime use these 3 methods in any controllers. These are the foundation authentication checks
class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }  #Avoids csrf tokens for postman testing
  helper_method :current_user, :logged_in?   #helper methods are methods that can be used by views as well

  private

  def current_user
    return @current_user if defined?(@current_user)   #checks if the current user is still available (memoization)
    @current_user = User.find_by(id: session[:user_id])  #gets the user who logged in
  end

  def logged_in?
    current_user.present?   #returns true if there is a valid current user
  end

  def require_login
    return if logged_in?

    respond_to do |format|
      format.html do
        flash[:alert] = "Please log in to continue."
        redirect_to login_path
      end

      format.json do
        render json: { error: "Unauthorized. Please log in to continue." }, status: :unauthorized
      end
    end
  end
end
