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
end
