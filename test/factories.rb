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
    value({'scalar' => 127, 'units' => 'mg/dL'})
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

  
  
  factory :user do |u| 
    u.sequence(:email) { |n| "testuser#{n}@test.com"} 
    u.password 'password' 
    u.password_confirmation 'password'
    u.sequence(:name) { |n| "testuser#{n}"}
  end

end
