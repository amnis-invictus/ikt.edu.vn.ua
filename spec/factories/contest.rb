FactoryBot.define do
  factory :contest do
    sequence(:display_name) { "USA olympiad ##{_1}" }
    cities { ['New York', 'Los Angeles', 'Chicago'] }
    contest_sites { ['New York School', 'Los Angeles College', 'Chicago University'] }
    institutions { ['New York Regional College', 'Los Angeles Regional College', 'Chicago Regional University'] }
    registration_secret { 'ABC123' }
    judge_password { 'password' }
    orgcom_password { 'password' }
    content { '<h2>What is Lorem Ipsum?</h2><p>Lorem <b>Ipsum</b> is simply dummy text of the industry.</p>' }

    trait :future do
      archived { false }
      registration_open { false }
      task_open { false }
      upload_open { false }
      statistic_open { false }
      archive_open { false }
    end

    trait :active do
      archived { false }
      registration_open { true }
      task_open { true }
      upload_open { true }
      statistic_open { true }
      archive_open { true }
    end

    trait :archived do
      archived { true }
      registration_open { false }
      task_open { true }
      upload_open { false }
      statistic_open { true }
      archive_open { true }
    end
  end
end
