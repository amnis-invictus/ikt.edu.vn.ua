FactoryBot.define do
  factory :contest do
    display_name { '1st USA olympiad' }
    cities { ['New York', 'Los Angeles', 'Chicago'] }
    contest_sites { ['New York School', 'Los Angeles Collage', 'Chicago University'] }
    registration_secret { 'ABC123' }
    registration_open { true }
    task_open { true }
    upload_open { true }
    judge_password { 'password' }

    # No HTML tags, because capybara page.have_content ignoring any HTML tags and normalizing whitespace
    content { 'What is Lorem Ipsum? Lorem Ipsum is simply dummy text of the printing and typesetting industry.' }
  end
end
