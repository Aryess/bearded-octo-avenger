FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "nomNomNomNom #{n}" }
    sequence(:email) { |n| "cookie.monster#{n}@sesame-street.com" }
    password "cookie"
    password_confirmation "cookie"
    
    factory :admin do
      admin true
    end
  end
  
  
end