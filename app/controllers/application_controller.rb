class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Määritellään, että metodi current_user tulee käyttöön myös näkymissä
  helper_method :current_user, :searched_city

  def ensure_that_signed_in
    redirect_to signin_path, notice:'you should be signed in' if current_user.nil?
  end

  def ensure_user_is_admin
    ensure_that_signed_in
    if (current_user.admin == false or current_user.admin.nil?)
      redirect_to :back, notice:'only admins are allowed to delete'
    end
  end

  def current_user
    return nil if session[:user_id].nil?
    User.find(session[:user_id])
  end

  def searched_city
    return nil if session[:cityname].nil?
    session[:cityname]
  end
end
