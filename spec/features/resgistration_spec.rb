require 'rails_helper'

RSpec.feature 'User registration', type: :feature, ui: true do
  given!(:contest) { create :contest }

  before { visit "/contests/#{contest.id}/users/new" }

  context 'with everything valid' do
    before { fill_new_user_form attributes_for :user }
    before { click_button 'commit' }
    scenario { expect(page).to have_content 'Ви успішно зареєстровані.' }
  end

  context 'with invalid registration secret' do
    before { fill_new_user_form attributes_for :user, registration_secret: SecureRandom.base36 }
    before { click_button 'commit' }
    scenario { expect(page).to have_content 'Код доступу помилковий' }
  end

  context 'without contest site' do
    before { fill_new_user_form attributes_for :user, contest_site: nil }
    before { click_button 'commit' }
    scenario { expect(page).to have_content 'Заклад, у якому ви пишете олімпіаду не може бути порожнім' }
  end

  context 'without email' do
    before { fill_new_user_form attributes_for :user, email: nil }
    before { click_button 'commit' }
    scenario('should stay on registration page') { expect(page).to have_content 'РЕЄСТРАЦІЯ УЧАСНИКА' }
    scenario { expect(page).to have_no_content 'Ваш e-mail не може бути порожнім' }
  end
end
