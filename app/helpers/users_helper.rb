module UsersHelper

  def isAdmin?
    return true if current_user.admin == :true 
    false
  end

end
