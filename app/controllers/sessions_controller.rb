class SessionsController < ApplicationController
  def new   #renders login form
  end

  def create
    user = Sessions::Authenticate.new(
      email: params[:email],
      password: params[:password]
    ).call

    if user&.authenticate(params[:password])   #uses Rails' has_secure_password (bcrypt) to check the password against the stored password_digest
      session[:user_id] = user.id    #On success, stores the user id in the session cookie
      flash[:notice] = "Logged in successfully."  #SHows a flash message

      respond_to do |format|
        format.html { redirect_to tasks_path }
        format.json { render json: { message: "Logged in successfully.", user_id: user.id }, status: :ok }
      end
    else
      flash.now[:alert] = "Invalid email or password."   #If not successful, shows a flash message for invalid email or password

      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }  #re-render the login form with status 422 Unprocessable Entity
        format.json { render json: { error: "Invalid email or password." }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    reset_session   #Clears all session data (removes session[:user_id])
    flash[:notice] = "Logged out."

    respond_to do |format|
      format.html { redirect_to login_path }
      format.json { render json: { message: "Logged out." }, status: :ok }
    end
  end
end

#session[:user_id] = user.id  gets stored as-
# session={
#   user_id:2
# }
