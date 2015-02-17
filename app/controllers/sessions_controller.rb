class SessionsController < ApplicationController
  include SessionControl
  def new
    # renderöi kirjautumissivun
  end

  def create
    #haetaan usernamea vastaava käyttäjä tietokannasta
    user = User.find_by username: params[:username]
    if user && user.authenticate(params[:password])
      if user.account_frozen
        redirect_to :back, notice: "Your account is frozen, please contact admin."
      else
        session[:user_id] = user.id
        redirect_to user_path(user), notice: "Welcome back!"
      end
    else
      redirect_to :back, notice: "Username and/or password mismatch!"
    end

  end

  def destroy
    signOut
    #uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end


end

