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
    content { '<h2>What is Lorem Ipsum?</h2><p>Lorem <b>Ipsum</b> is simply dummy text of the industry.</p>' }
  end
end
