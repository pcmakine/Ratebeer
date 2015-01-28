class SessionsController < ApplicationController
  include SessionControl
  def new
    # renderöi kirjautumissivun
  end

  def create
    #haetaan usernamea vastaava käyttäjä tietokannasta
    user = User.find_by username: params[:username]
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Welcome back!"
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