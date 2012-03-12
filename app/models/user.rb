class User
  include Mongoid::Document
  include Mongoid::Symbolize

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :oauth2_providable, :oauth2_password_grantable, :oauth2_refresh_token_grantable, 
         :oauth2_authorization_code_grantable
         
  ## contact information
  field :street, type: String
  field :city, type: String
  field :state, type: String
  field :zip, type: String
  field :country, type: String

  ## role, a user can be one of these roles at at time
  #  PATIENT, CLINICIAN, INSURER, RECORD_ADMIN
  symbolize :role, :in => {
    patient:       "Patient", 
    clinician:     "Clinician", 
    insurer:       "Insurer", 
    record_admin:  "Record Admin"}, :default => :patient, :scopes => true

  ## APP admin role
  symbolize :admin, :in => {
    true:    "True", 
    false:   "False"}, :default => :false, :scopes => true

  attr_accessible :admin, :role, :street, :city, :state, :zip, :country

  ## need to define name here, odd since defined below in attr_accessible
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
