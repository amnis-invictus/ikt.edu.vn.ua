FactoryBot.define do
  factory :contest do
    display_name { '1st USA olympiad' }
    cities { ['New York', 'Los Angeles', 'Chicago'] }
    contest_sites { ['New York School', 'Los Angeles College', 'Chicago University'] }
    institutions { ['New York Regional College', 'Los Angeles Regional College', 'Chicago Regional University'] }
    registration_secret { 'ABC123' }
    registration_open { true }
    task_open { true }
    upload_open { true }
    judge_password { 'password' }
    orgcom_password { 'password' }
    content { '<h2>What is Lorem Ipsum?</h2><p>Lorem <b>Ipsum</b> is simply dummy text of the industry.</p>' }
  end
end
