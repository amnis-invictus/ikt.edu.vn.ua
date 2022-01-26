require 'rails_helper'

RSpec.feature 'Contest policy', type: :feature, ui: true do
  context 'when registration closed' do
    given(:contest) { create :contest, registration_open: false }

    scenario do
      visit "/contests/#{contest.id}/users/new"
      expect(page).to have_content 'РЕЄСТРАЦІЯ УЧАСНИКА'
      expect(page).to have_content 'Реєстрація заборонена. Повідомте технічного працівника.'
      expect(page).to have_no_content 'Виберіть місто (район)'
      expect(page).to have_no_content contest.contest_sites.first
      expect(page).to have_no_button 'commit'
    end
  end

  context 'when registration open' do
    given(:contest) { create :contest, registration_open: true }

    scenario do
      visit "/contests/#{contest.id}/users/new"
      expect(page).to have_content 'РЕЄСТРАЦІЯ УЧАСНИКА'
      expect(page).to have_no_content 'Реєстрація заборонена. Повідомте технічного працівника.'
      expect(page).to have_content 'Виберіть місто (район)'
      expect(page).to have_content contest.contest_sites.first
      expect(page).to have_button 'commit'
    end
  end

  # TODO: Add additional content upload / check
  context 'when task closed' do
    given(:contest) { create :contest, task_open: false }

    scenario do
      visit "/contests/#{contest.id}/content"
      expect(page).to have_content 'Перегляд завдання заборонено. Повідомте технічного працівника.'
      expect(page).to have_no_content contest.content
      expect(page).to have_no_content 'Додаткові матеріали'
    end
  end

  context 'when task open' do
    given(:contest) { create :contest, task_open: true }

    scenario do
      visit "/contests/#{contest.id}/content"
      expect(page).to have_no_content 'Перегляд завдання заборонено. Повідомте технічного працівника.'
      expect(page).to have_content contest.content
      expect(page).to have_content 'Додаткові матеріали'
    end
  end

  context 'when upload closed' do
    given(:contest) { create :contest, upload_open: false }

    scenario do
      visit "/contests/#{contest.id}/upload/new"
      expect(page).to have_content 'ВІДПРАВКА РОЗВ\'ЯЗКІВ'
      expect(page).to have_content 'Відправка розв\'язків заборонена. Повідомте технічного працівника.'
      expect(page).to have_no_field 'upload_secret'
      expect(page).to have_no_button 'commit'
    end
  end

  context 'when upload open' do
    given(:contest) { create :contest, upload_open: true }

    scenario do
      visit "/contests/#{contest.id}/upload/new"
      expect(page).to have_content 'ВІДПРАВКА РОЗВ\'ЯЗКІВ'
      expect(page).to have_no_content 'Відправка розв\'язків заборонена. Повідомте технічного працівника.'
      expect(page).to have_field 'upload_secret'
      expect(page).to have_button 'commit'
    end
  end
end
