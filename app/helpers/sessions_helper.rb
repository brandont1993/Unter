module SessionsHelper
  #logs in user
  def log_in(user)
    session[:user_id] = user.id
    session[:user_role] = user.role
  end
  
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  
  #checks if user is logged in
  def logged_in?
    !current_user.nil?
  end
  
  def log_out
    session.delete(:user_id)
    session.delete(:user_role)    
    @current_user = nil
  end
  
  def current_user?(user)
      user == current_user
  end
  
  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
      redirect_to(session[:forwarding_url] || default)
      session.delete(:forwarding_url)
  end
  
  # Stores the URL trying to be accessed.
  def store_location
      session[:forwarding_url] = request.original_url if request.get?
  end
  
  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
  
  def correct_user?(user)
    user == current_user
  end
  # Confirms the correct user.
  def correct_user
    # @user = User.find(session[:user_id])
      if params[:id] == nil
        flash[:danger] = "You're not valid to perform such operations. Please login as Admin or SuperAdmin to move on."
        redirect_to login_url
        return
      end
      @user = User.find(params[:id])
      unless current_user?(@user)
        flash[:danger] = "You cannot view or edit other user's info."
        redirect_to current_user
        return
      end
  end
  def isAdmin?
      session[:user_role] == 'Admin'
  end
  def isSuperAdmin?
      session[:user_role] == 'SuperAdmin'
  end
  def isCustomer?
    session[:user_role] == 'Customer'
  end
  
  def logged_in_as_admin
    unless (isAdmin? || isSuperAdmin?)
      store_location
      flash[:danger] = "Please login as Admin or SuperAdmin to move on."
      redirect_to login_url
    end
  end
end
