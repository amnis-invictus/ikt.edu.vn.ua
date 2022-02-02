require 'rails_helper'

RSpec.feature 'User registration', type: :feature, ui: true do
  given!(:contest) { create :contest }
  given(:registration_path) { "/contests/#{contest.id}/users/new" }

  before { visit registration_path }
  before { fill_new_user_form params }

  context 'with everything valid' do
    given(:params) { attributes_for :user }
    before { click_button 'commit' }
    scenario { expect(page).to have_content 'Ви успішно зареєстровані.' }
  end

  context 'with duplicated name' do
    before { create :user, contest: }
    given(:params) { attributes_for :user }
    before { click_button 'commit' }

    scenario { expect(page).to have_content "Учасник на ім'я #{params[:name]} вже зареєстрований" }
  end

  context 'with invalid registration secret' do
    given(:params) { attributes_for :user, registration_secret: SecureRandom.base36 }
    before { click_button 'commit' }
    scenario { expect(page).to have_content 'Код доступу помилковий' }
  end

  context 'without contest site' do
    given(:params) { attributes_for :user, contest_site: nil }
    before { click_button 'commit' }
    scenario { expect(page).to have_content 'Заклад, у якому ви пишете олімпіаду не може бути порожнім' }
  end

  context 'without grade' do
    given(:params) { attributes_for :user, grade: nil }
    before { click_button 'commit' }
    scenario { expect(page).to have_content 'Клас не може бути порожнім' }
  end

  context 'without city' do
    given(:params) { attributes_for :user, city: nil }
    before { click_button 'commit' }
    scenario { expect(page).to have_content 'Місто не може бути порожнім' }
  end

  context 'without email' do
    given(:params) { attributes_for :user, email: nil }
    before { click_button 'commit' }
    scenario('should stay on registration page') { expect(page).to have_current_path(registration_path) }
    scenario { expect(page).to have_no_content 'Ваш e-mail не може бути порожнім' }
  end

  context 'without institution' do
    given(:params) { attributes_for :user, institution: nil }
    before { click_button 'commit' }
    scenario('should stay on registration page') { expect(page).to have_current_path(registration_path) }
    scenario { expect(page).to have_no_content 'Ваш навчальний заклад не може бути порожнім' }
  end
end
