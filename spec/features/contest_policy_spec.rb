require 'rails_helper'

RSpec.feature 'ContestPolicy', type: :feature, ui: true do
  feature 'registration' do
    before { visit "/contests/#{contest.id}/users/new" }

    context 'when closed' do
      given(:contest) { create :contest, registration_open: false }

      scenario { expect(page).to have_content 'РЕЄСТРАЦІЯ УЧАСНИКА' }
      scenario { expect(page).to have_content 'Реєстрація заборонена. Повідомте технічного працівника.' }
      scenario { expect(page).to have_no_css 'form#regform', visible: :all }
      scenario { expect(page).to have_no_button 'commit' }
    end

    context 'when open' do
      given(:contest) { create :contest, registration_open: true }

      scenario { expect(page).to have_content 'РЕЄСТРАЦІЯ УЧАСНИКА' }
      scenario { expect(page).to have_no_content 'Реєстрація заборонена. Повідомте технічного працівника.' }
      scenario { expect(page).to have_css 'form#regform', visible: true }
      scenario { expect(page).to have_button 'commit' }
    end
  end

  # TODO: Add additional content upload / check
  feature 'viewing content' do
    before { visit "/contests/#{contest.id}/content" }

    context 'when task closed' do
      given(:contest) { create :contest, task_open: false }

      scenario { expect(page).to have_content 'Перегляд завдання заборонено. Повідомте технічного працівника.' }
      scenario { expect(page.html).to_not include contest.content }
      scenario { expect(page).to have_no_content 'Додаткові матеріали' }
    end

    context 'when task open' do
      given(:contest) { create :contest, task_open: true }

      scenario { expect(page).to have_no_content 'Перегляд завдання заборонено. Повідомте технічного працівника.' }
      scenario { expect(page.html).to include contest.content }
      scenario { expect(page).to have_content 'Додаткові матеріали' }
    end
  end

  feature 'upload' do
    before { visit "/contests/#{contest.id}/upload/new" }

    context 'when closed' do
      given(:contest) { create :contest, upload_open: false }

      scenario { expect(page).to have_content 'ВІДПРАВКА РОЗВ\'ЯЗКІВ' }
      scenario { expect(page).to have_content 'Відправка розв\'язків заборонена. Повідомте технічного працівника.' }
      scenario { expect(page).to have_no_css 'form', visible: :all }
      scenario { expect(page).to have_no_button 'commit' }
    end

    context 'when open' do
      given(:contest) { create :contest, upload_open: true }

      scenario { expect(page).to have_content 'ВІДПРАВКА РОЗВ\'ЯЗКІВ' }
      scenario { expect(page).to have_no_content 'Відправка розв\'язків заборонена. Повідомте технічного працівника.' }
      scenario { expect(page).to have_css 'form', visible: true }
      scenario { expect(page).to have_button 'commit' }
    end
  end
end
