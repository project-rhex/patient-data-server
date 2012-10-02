class User
  include Mongoid::Document
  include Mongoid::Symbolize

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :oauth2_providable, :oauth2_password_grantable, :oauth2_refresh_token_grantable, 
         :oauth2_authorization_code_grantable
         
  ## Database authenticatable
  field :email,              type: String
  field :encrypted_password, type: String

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      type: Integer
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## contact information
  field :name,               type: String
  field :street,             type: String
  field :city,               type: String
  field :state,              type: String
  field :zip,                type: String
  field :country,            type: String
  field :dob,                type: String
  field :insurance,          type: String

  ## Information to make OAuth 2 requests for vital signs
  embeds_many :vital_sign_auths, class_name: "VitalSignAuth"

  symbolize :gender, :in => {
    male:           "Male", 
    female:         "Female"}, :default => :male, :scopes => true


  ## role, a user can be one of these roles at at time
  #  PATIENT, CLINICIAN, INSURER, RECORD_ADMIN
=begin
    http://ushik.ahrq.gov/ViewItemDetails?system=mdr&itemKey=86829000

    Permissible Value	Domain Meaning Name	Domain Meaning Definition Text	Begin Date	End Date
    106289002	Dentist		2009-11-09	
    106290006	Veterinarian		2009-11-09	
    106292003	Professional nurse		2009-11-09	
    106311007	Minister of religion AND/OR related member of religious order		2009-11-09	
    106328005	Social worker		2009-11-09	
    106330007	Philologist, translator AND/OR interpreter		2009-11-09	
    112247003	Medical doctor		2009-11-09	
    116154003	Patient		2009-11-09	
    159026005	Speech therapist		2009-11-09	
    159033005	Dietitian		2009-11-09	
    159034004	Podiatrist		2009-11-09	
    159483005	clerical occupation		2009-11-09	
    224546007	Infection control nurse		2009-11-09	
    224570006	Clinical nurse specialist		2009-11-09	
    224571005	Nurse practitioner
=end

  symbolize :role, :in => {
    patient:            "Patient", 
    pro_nurse:          "Professional Nurse", 
    med_doctor:         "Medical Doctor", 
    clinical_nurse:     "Clinical Nurse Specialist", 
    nurse_practitioner: "Nurse Pracitioner", 
    soc_worker:         "Social Worker", 
    dentist:            "Dentist", 
    insurer:            "Insurer", 
    record_admin:       "Record Admin"}, :default => :patient, :scopes => true

  ## APP admin role
  symbolize :admin, :in => {
    true:    "True", 
    false:   "False"}, :default => :false, :scopes => true


  attr_accessible :admin, :role # TODO: This is here only for the form. Needs to be removed later
  attr_accessible :street, :city, :state, :zip, :country, :dob, :insurance, :gender, :name, 
                  :email, :password, :password_confirmation, :remember_me

  validates_uniqueness_of  :email, :case_sensitive => false
  has_many :authentications
   
  def apply_omniauth(omniauth)
    self.email = omniauth['info']['email'] if email.blank?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end
  
  def auth_for_feed(vsf)
    vital_sign_auths.detect { |auth| auth.vital_sign_feed.url.eql?(vsf.url) } || vital_sign_auths.create!(vital_sign_feed: vsf)
  end
  
  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

  def username
   email
  end
end
