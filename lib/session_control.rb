module SessionControl
  def signOut
    #nollataan sessio
    session[:user_id] = nil
  end
end