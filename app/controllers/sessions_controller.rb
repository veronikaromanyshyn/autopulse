class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:email].to_s.downcase.strip)
    if user&.authenticate(params[:password])
      log_in(user)
      redirect_to session.delete(:return_to) || root_path, notice: "Ви увійшли як #{user.name}"
    else
      flash.now[:alert] = "Невірний email або пароль"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to root_path, notice: "Ви вийшли з облікового запису"
  end
end
