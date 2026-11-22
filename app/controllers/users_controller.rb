class UsersController < ApplicationController
  before_action :require_login, only: [:show, :edit, :update]

  def new
    redirect_to root_path if logged_in?
    @user = User.new
  end

  def create
    @user = User.new(signup_params)
    if @user.save
      log_in(@user)
      redirect_to root_path, notice: "Вітаємо, #{@user.name}! Реєстрацію завершено."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user   = current_user
    @orders = current_user.orders.recent.limit(5)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(profile_params)
      redirect_to profile_path, notice: "Профіль оновлено"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def signup_params
    params.require(:user).permit(:name, :email, :phone, :password, :password_confirmation)
  end

  def profile_params
    permitted = params.require(:user).permit(:name, :phone, :password, :password_confirmation)
    permitted.delete(:password) && permitted.delete(:password_confirmation) if permitted[:password].blank?
    permitted
  end
end
