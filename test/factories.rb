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
    #reference_range '70 mg/dL - 160 mg/dL'
  end
end