FactoryBot.define do
  factory :user do
    name { 'John Doe' }
    city { 'Chicago' }
    institution { 'New York Regional College' }
    contest_site { 'New York School' }
    grade { 10 }
    email { 'john.doe@example.com' }
    registration_secret { 'ABC123' }
  end
end
