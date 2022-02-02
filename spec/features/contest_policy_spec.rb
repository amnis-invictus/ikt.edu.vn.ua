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
end
