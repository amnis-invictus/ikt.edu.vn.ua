require 'rails_helper'

RSpec.feature 'Contest policy', type: :feature, ui: true do
  scenario 'when registration closed' do
    contest = create :contest, registration_open: false

    visit "/contests/#{contest.id}/users/new"
    expect(page).to have_content 'РЕЄСТРАЦІЯ УЧАСНИКА'
    expect(page).to have_content 'Реєстрація заборонена. Повідомте технічного працівника.'
    expect(page).to have_no_content 'Виберіть місто (район)'
    expect(page).to have_no_content contest.contest_sites.first
    expect(page).to have_no_button 'commit'
  end

  scenario 'when registration open' do
    contest = create :contest, registration_open: true

    visit "/contests/#{contest.id}/users/new"
    expect(page).to have_content 'РЕЄСТРАЦІЯ УЧАСНИКА'
    expect(page).to have_no_content 'Реєстрація заборонена. Повідомте технічного працівника.'
    expect(page).to have_content 'Виберіть місто (район)'
    expect(page).to have_content contest.contest_sites.first
    expect(page).to have_button 'commit'
  end

  # TODO: Add additional content upload / check
  scenario 'when task closed' do
    contest = create :contest, task_open: false

    visit "/contests/#{contest.id}/content"
    expect(page).to have_content 'Перегляд завдання заборонено. Повідомте технічного працівника.'
    expect(page).to have_no_content contest.content
    expect(page).to have_no_content 'Додаткові матеріали'
  end

  scenario 'when task open' do
    contest = create :contest, task_open: true

    visit "/contests/#{contest.id}/content"
    expect(page).to have_no_content 'Перегляд завдання заборонено. Повідомте технічного працівника.'
    expect(page).to have_content contest.content
    expect(page).to have_content 'Додаткові матеріали'
  end
end
