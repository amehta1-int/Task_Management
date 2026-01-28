
class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = SignUpUsersService.new(params: user_params).call

    session[:user_id] = @user.id  #Stores the new user's ID in the session cookie. This logs the user immediately in after signup.
    flash[:notice] = "Account created. You are now logged in."

    respond_to do |format|
      format.html { redirect_to tasks_path }
      format.json { render json: { message: "Account created. You are now logged in.", user_id: @user.id }, status: :created }
    end
  rescue ActiveRecord::RecordInvalid  #If validations fail, save! or create! raises ActiveRecord::RecordInvalid
    @user = User.new(user_params)
    @user.validate
    flash.now[:alert] = "Please fix the errors below."

    respond_to do |format|
      format.html { render :new, status: :unprocessable_entity }  #re-renders the signup form with HTTP status 422 Unprocessible Entity
      format.json { render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity }
    end
  end

  #Defines strong parameters
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
