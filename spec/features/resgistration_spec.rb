require 'rails_helper'

RSpec.describe 'Registration', ui: true do
  let(:registration_email) { an_object_having_attributes subject: 'IKT - Реєстрація', to: [params[:email]] }
  let(:registration_path) { "/contests/#{contest.id}/users/new" }

  before { visit registration_path }

  describe 'for contest with contest_site, institution and city' do
    let(:contest) { create :contest }

    before do
      fill_inputs 'user', params.slice(:name, :email, :registration_secret)
      fill_selects 'user', params.slice(:city, :institution, :contest_site, :grade)
    end

    context 'with everything valid' do
      let(:params) { attributes_for :user }

      before { click_button 'commit' }

      it { expect(page).to have_content 'Ви успішно зареєстровані.' }
      it('delivers email') { expect(ActionMailer::Base.deliveries).to include(registration_email) }
    end

    context 'with duplicated name' do
      let(:params) { attributes_for :user, email: 'judy.doe@example.com' }

      before do
        create(:user, contest:)
        click_button 'commit'
      end

      it { expect(page).to have_content "Учасник на ім'я #{params[:name]} вже зареєстрований" }
      it('does not deliver email') { expect(ActionMailer::Base.deliveries).to_not include(registration_email) }
    end

    context 'with invalid registration secret' do
      let(:params) { attributes_for :user, registration_secret: SecureRandom.base36 }

      before { click_button 'commit' }

      it { expect(page).to have_content 'Код доступу помилковий' }
      it('does not deliver email') { expect(ActionMailer::Base.deliveries).to_not include(registration_email) }
    end

    context 'without contest site' do
      let(:params) { attributes_for :user, contest_site: nil }

      before { click_button 'commit' }

      it { expect(page).to have_content 'Заклад, у якому ви пишете олімпіаду не може бути порожнім' }
      it('does not deliver email') { expect(ActionMailer::Base.deliveries).to_not include(registration_email) }
    end

    context 'without grade' do
      let(:params) { attributes_for :user, grade: nil }

      before { click_button 'commit' }

      it { expect(page).to have_content 'Клас не може бути порожнім' }
      it('does not deliver email') { expect(ActionMailer::Base.deliveries).to_not include(registration_email) }
    end

    context 'without city' do
      let(:params) { attributes_for :user, city: nil }

      before { click_button 'commit' }

      it { expect(page).to have_content 'Місто не може бути порожнім' }
      it('does not deliver email') { expect(ActionMailer::Base.deliveries).to_not include(registration_email) }
    end

    context 'without email' do
      let(:params) { attributes_for :user, email: nil }

      before { click_button 'commit' }

      it('stays on registration page') { expect(page).to have_current_path(registration_path) }
      it { expect(page).to_not have_content 'Ваш e-mail не може бути порожнім' }
      it('does not deliver email') { expect(ActionMailer::Base.deliveries).to_not include(registration_email) }
    end

    context 'without institution' do
      let(:params) { attributes_for :user, institution: nil }

      before { click_button 'commit' }

      it { expect(page).to have_content 'Ваш навчальний заклад не може бути порожнім' }
      it('does not deliver email') { expect(ActionMailer::Base.deliveries).to_not include(registration_email) }
    end

    context 'without name' do
      let(:params) { attributes_for :user, name: nil }

      before { click_button 'commit' }

      it('stays on registration page') { expect(page).to have_current_path(registration_path) }
      it { expect(page).to_not have_content 'Прізвище, Ім\'я, По батькові не може бути пустим' }
      it('does not deliver email') { expect(ActionMailer::Base.deliveries).to_not include(registration_email) }
    end
  end

  describe 'for contest without contest_site' do
    let(:contest) { create :contest, contest_sites: [] }

    before do
      fill_inputs 'user', params.slice(:name, :email, :contest_site, :registration_secret)
      fill_selects 'user', params.slice(:city, :institution, :grade)
    end

    context 'with everything valid' do
      let(:params) { attributes_for :user }

      before { click_button 'commit' }

      it { expect(page).to have_content 'Ви успішно зареєстровані.' }
      it('delivers email') { expect(ActionMailer::Base.deliveries).to include(registration_email) }
    end

    context 'without contest_site' do
      let(:params) { attributes_for :user, contest_site: nil }

      before { click_button 'commit' }

      it('stays on registration page') { expect(page).to have_current_path(registration_path) }
      it { expect(page).to_not have_content 'Заклад, у якому ви пишете олімпіаду не може бути порожнім' }
      it('does not deliver email') { expect(ActionMailer::Base.deliveries).to_not include(registration_email) }
    end
  end

  describe 'for contest without institution' do
    let(:contest) { create :contest, institutions: [] }

    before do
      fill_inputs 'user', params.slice(:name, :institution, :email, :registration_secret)
      fill_selects 'user', params.slice(:contest_site, :city, :grade)
    end

    context 'with everything valid' do
      let(:params) { attributes_for :user }

      before { click_button 'commit' }

      it { expect(page).to have_content 'Ви успішно зареєстровані.' }
      it('delivers email') { expect(ActionMailer::Base.deliveries).to include(registration_email) }
    end

    context 'without institution' do
      let(:params) { attributes_for :user, institution: nil }

      before { click_button 'commit' }

      it('stays on registration page') { expect(page).to have_current_path(registration_path) }
      it { expect(page).to_not have_content 'Ваш навчальний заклад не може бути порожнім' }
      it('does not deliver email') { expect(ActionMailer::Base.deliveries).to_not include(registration_email) }
    end
  end

  describe 'for contest without city' do
    let(:contest) { create :contest, cities: [] }

    before do
      fill_inputs 'user', params.slice(:name, :email, :city, :registration_secret)
      fill_selects 'user', params.slice(:contest_site, :institution, :grade)
    end

    context 'with everything valid' do
      let(:params) { attributes_for :user }

      before { click_button 'commit' }

      it { expect(page).to have_content 'Ви успішно зареєстровані.' }
      it('delivers email') { expect(ActionMailer::Base.deliveries).to include(registration_email) }
    end

    context 'without city' do
      let(:params) { attributes_for :user, city: nil }

      before { click_button 'commit' }

      it('stays on registration page') { expect(page).to have_current_path(registration_path) }
      it { expect(page).to_not have_content 'Місто не може бути порожнім' }
      it('does not deliver email') { expect(ActionMailer::Base.deliveries).to_not include(registration_email) }
    end
  end
end
