module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :logged_in?, :admin?
  end

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in? = current_user.present?
  def admin?     = current_user&.admin?

  def log_in(user)
    reset_session_preserving_cart
    session[:user_id] = user.id
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def require_login
    return if logged_in?
    session[:return_to] = request.fullpath if request.get?
    redirect_to login_path, alert: "Будь ласка, увійдіть до облікового запису"
  end

  def require_admin
    redirect_to root_path, alert: "Доступ лише для адміністратора" unless admin?
  end

  # Захист від фіксації сесії: оновлюємо ідентифікатор, але зберігаємо кошик
  def reset_session_preserving_cart
    cart_id = session[:cart_id]
    reset_session
    session[:cart_id] = cart_id
  end
end
