#This is the welcome page, that redirects to tasks page if the user is logged in, else it directs to the login page for the user to login
class HomeController < ApplicationController
  def index
    if logged_in?
      respond_to do |format|
        format.html { redirect_to tasks_path }
        format.json { render json: { redirect_to: tasks_path }, status: :ok }
      end
    else
      respond_to do |format|
        format.html { redirect_to login_path }
        format.json { render json: { redirect_to: login_path }, status: :ok }
      end
    end
  end
end
