class UsersController < ApplicationController
  before_filter :is_admin, only:[:index]
  def index
    @users = User.all
  end
  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "Welcome to the site!"
      session[:user_id] = @user.id
      redirect_to "/"
    else
      flash[:alert] = "There was a problem creating your account. Please try again."
      redirect_to :back
    end
  end

  def update
    @user = User.find(params[:id])
    if user_params[:admin] != nil
      if @user.update(user_params)
        redirect_to users_path
      end
    elsif user_params[:best] != nil
      User.is_best.update(:best => false)
      if @user.update(user_params)
        redirect_to users_path
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to :back
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :admin, :best)
    end
end
