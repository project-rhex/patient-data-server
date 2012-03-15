module UsersHelper

  def isAdmin?
    return true if current_user.admin == :true 
    false
  end

  def userRoleValue(role_symbol)
    User.get_role_values.each do |r|
      if r[1] == role_symbol
        # should return "Medical Doctor" or "Patient" etc...
        return r[0]
      end
    end

    "none"  
  end


  def userGenderValue(gender_symbol)
    User.get_gender_values.each do |r|
      if r[1] == gender_symbol
        # should return "Medical Doctor" or "Patient" etc...
        return r[0]
      end
    end

    "none"  
  end

end
