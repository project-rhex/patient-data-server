class Authentication
   include Mongoid::Document
   belongs_to :user
   
   field :type  
  
end
