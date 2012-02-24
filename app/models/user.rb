class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :oauth2_providable, :oauth2_password_grantable, :oauth2_refresh_token_grantable, 
         :oauth2_authorization_code_grantable
         
   field :name
  # validates_presence_of :name
   validates_uniqueness_of  :email, :case_sensitive => false
   attr_accessible :name, :email, :password, :password_confirmation, :remember_me
   has_many :authentications
   
   def apply_omniauth(omniauth)
     self.email = omniauth['info']['email'] if email.blank?
     authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
   end

   def password_required?
     (authentications.empty? || !password.blank?) && super
   end
   
   
   def username
     email
   end
   
   
end
