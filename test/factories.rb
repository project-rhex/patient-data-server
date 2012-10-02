FactoryGirl.define do
  factory :record do
    first 'John'
    last 'Doe'
    birthdate -790874989
    gender 'M'
    sequence(:medical_record_number) {|n| n}
    
    trait :with_lab_results do
      results {|r| [r.association(:lab_result)]}
    end
  end
  
  factory :lab_result do
    description 'LDL Cholesterol'
    time 1285387200
    codes({'CPT' => ['83721'], 'LOINC' => ['2089-1']})
    values {[FactoryGirl.build(:physical_quantity_result_value)]}
    reference_range '70 mg/dL - 160 mg/dL'
  end


  factory :audit_log do
    requester_info "NONE"
    event "c32_access"
    description "id:1"
    checksum "b544cb97491048f4bbe7875bdf69a7cd48d75f41"
    obj_name "Record"
    sequence :obj_id do |n| 
      "4f3437f5069d45038f00000#{n}"
    end
    version 0
  end

  factory :physical_quantity_result_value do |f|
    f.scalar 127
    f.units "mg/dL"
  end
  
  
  factory :user do |u| 
    u.sequence(:email) { |n| "testuser#{n}@test.com"} 
    u.password 'password' 
    u.password_confirmation 'password'
    u.sequence(:name) { |n| "testuser#{n}"}
    u.street '5 Bedford Rd'
    u.city 'Bedford'
    u.state 'Ma'
    u.zip '01720'
    u.country 'USA'
    u.role :patient
    u.admin :true
  end
  
  
  factory :client, :class => 'Devise::Oauth2Providable::Client' do |f|
    f.name 'test-handshake'
    f.cidentifier '1570981427089'
    f.website 'http://handshake.mitre.org'
    f.redirect_uri 'http://handshake.mitre.org'
  end

  factory :notify_config do
    user  'gganley@mitre.org'
    interval :instant
    action :record_update
    alert_out1 :web
    alert_out2 :email
    alert_out3 :direct_email
    alert_out4 :text
  end

  factory :notification do
    user  'gganley@mitre.org'
    action :record_update
    record_id '1'
    status :unread
  end


  factory :ref_consult_request do
    refDate  "2012-03-28"
    disposition  "MyString"
    refNumber  1
    priority  :urgent
    reasonConditionId  1
    status  :pending
    refType  "MyString"
    requestedSpecialty :anesthesia
    procedureId  1
    reasonDescription  "MyString"
    category  "MyString"
    requestedNumTreatments  1
    requestProviderId  1
    comment  "MyString"
    requestedConsultingProviderId  1
    reasonText  "MyString"
  end

  factory :ref_consult_summary do
    refDate  "2012-03-28"
    refNumber  1
    consultationTreatmentSummary  "MyString"
    recommendedPlanOfCareId  1
    sendRequestProviderId  1
  end

  factory :vital_sign_host do
    hostname 'foo.bar.com'
    client_id '1234'
    client_secret '5678'
  end
  
  factory :vital_sign_feed do
    url 'http://foo.bar.com/vs1'
    vital_sign_host
    record
  end

end
