require 'rails_helper'

RSpec.feature 'User registration', type: :feature, ui: true do
  context 'create new user' do
    given(:contest) { create :contest }

    before :each do
      visit "/contests/#{contest.id}/users/new"
      within 'form' do
        fill_in 'user_registration_secret', with: contest.registration_secret
        fill_in 'user_name', with: 'John Doe'
        select contest.cities.last, from: 'user_city'
        fill_in 'user_institution', with: 'New York Regional Collage'
        select '10', from: 'user_grade'
      end
    end

    scenario 'should be successful' do
      within 'form' do
        fill_in 'user_email', with: 'john.doe@example.com'
        select contest.contest_sites.first, from: 'user_contest_site'
      end
      click_button 'commit'
      expect(page).to have_content 'Ви успішно зареєстровані.'
    end

    scenario 'with wrong registration_secret should fail' do
      within 'form' do
        fill_in 'user_registration_secret', with: contest.registration_secret.reverse
        fill_in 'user_email', with: 'john.doe@example.com'
        select contest.contest_sites.first, from: 'user_contest_site'
      end
      click_button 'commit'
      expect(page).to have_content 'Код доступу помилковий'
    end

    scenario 'without user_contest_site should fail' do
      within 'form' do
        fill_in 'user_email', with: 'john.doe@example.com'
      end
      click_button 'commit'
      expect(page).to have_content 'Заклад, у якому ви пишете олімпіаду не може бути порожнім'
    end

    scenario 'without user_email should fail (no post)' do
      within 'form' do
        select contest.contest_sites.first, from: 'user_contest_site'
      end
      click_button 'commit'
      expect(page).to have_content 'РЕЄСТРАЦІЯ УЧАСНИКА'
      expect(page).to have_no_content 'Ваш e-mail не може бути порожнім'
    end
  end
end
