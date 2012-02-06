FactoryGirl.define do
  factory :record do
    first 'John'
    last 'Doe'
    birthdate -790874989
    gender 'M'
    sequence(:medical_record_number) {|n| n}
  end
end