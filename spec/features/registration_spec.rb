require 'rails_helper'

RSpec.describe 'Registration', :ui do
  let(:registration_email) { an_object_having_attributes subject: 'IKT - Реєстрація', to: [params[:email]] }
  let(:registration_path) { "/contests/#{contest.id}/users/new" }

  before { visit registration_path }

  describe 'for contest with contest_site, institution and city' do
    let(:contest) { create :contest, registration_open: true }

    before do
      fill_inputs 'user', params.slice(:name, :email, :registration_secret)
      fill_selects 'user', params.slice(:city, :institution, :contest_site, :grade)
    end

    context 'with everything valid' do
      let(:params) { attributes_for :user }

      before { click_on 'commit' }

      it { expect(page).to have_content 'Ви успішно зареєстровані.' }

      it 'delivers email' do
        perform_enqueued_jobs
        expect(ActionMailer::Base.deliveries).to include(registration_email)
      end
    end

    context 'with duplicated name' do
      let(:params) { attributes_for :user, email: 'judy.doe@example.com' }

      before do
        create(:user, contest:)
        click_on 'commit'
      end

      it { expect(page).to have_content "Учасник на ім'я #{params[:name]} вже зареєстрований" }

      it 'does not deliver email' do
        perform_enqueued_jobs
        expect(ActionMailer::Base.deliveries).to_not include(registration_email)
      end
    end

    context 'with invalid registration secret' do
      let(:params) { attributes_for :user, registration_secret: SecureRandom.base36 }

      before { click_on 'commit' }

      it { expect(page).to have_content 'Код доступу помилковий' }

      it 'does not deliver email' do
        perform_enqueued_jobs
        expect(ActionMailer::Base.deliveries).to_not include(registration_email)
      end
    end

    context 'without contest site' do
      let(:params) { attributes_for :user, contest_site: nil }

      before { click_on 'commit' }

      it { expect(find_by_id('user_contest_site').native.attribute('validationMessage')).to be_present }

      it 'does not deliver email' do
        perform_enqueued_jobs
        expect(ActionMailer::Base.deliveries).to_not include(registration_email)
      end
    end

    context 'without grade' do
      let(:params) { attributes_for :user, grade: nil }

      before { click_on 'commit' }

      it { expect(find_by_id('user_grade').native.attribute('validationMessage')).to be_present }

      it 'does not deliver email' do
        perform_enqueued_jobs
        expect(ActionMailer::Base.deliveries).to_not include(registration_email)
      end
    end

    context 'without city' do
      let(:params) { attributes_for :user, city: nil }

      before { click_on 'commit' }

      it { expect(find_by_id('user_city').native.attribute('validationMessage')).to be_present }

      it 'does not deliver email' do
        perform_enqueued_jobs
        expect(ActionMailer::Base.deliveries).to_not include(registration_email)
      end
    end

    context 'without email' do
      let(:params) { attributes_for :user, email: nil }

      before { click_on 'commit' }

      it('stays on registration page') { expect(page).to have_current_path(registration_path) }
      it { expect(page).to have_no_content 'Ваш e-mail не може бути порожнім' }

      it 'does not deliver email' do
        perform_enqueued_jobs
        expect(ActionMailer::Base.deliveries).to_not include(registration_email)
      end
    end

    context 'without institution' do
      let(:params) { attributes_for :user, institution: nil }

      before { click_on 'commit' }

      it { expect(find_by_id('user_institution').native.attribute('validationMessage')).to be_present }

      it 'does not deliver email' do
        perform_enqueued_jobs
        expect(ActionMailer::Base.deliveries).to_not include(registration_email)
      end
    end

    context 'without name' do
      let(:params) { attributes_for :user, name: nil }

      before { click_on 'commit' }

      it('stays on registration page') { expect(page).to have_current_path(registration_path) }
      it { expect(page).to have_no_content 'Прізвище, Ім\'я, По батькові не може бути пустим' }

      it 'does not deliver email' do
        perform_enqueued_jobs
        expect(ActionMailer::Base.deliveries).to_not include(registration_email)
      end
    end
  end

  describe 'for contest without contest_site' do
    let(:contest) { create :contest, registration_open: true, contest_sites: [] }

    before do
      fill_inputs 'user', params.slice(:name, :email, :contest_site, :registration_secret)
      fill_selects 'user', params.slice(:city, :institution, :grade)
    end

    context 'with everything valid' do
      let(:params) { attributes_for :user }

      before { click_on 'commit' }

      it { expect(page).to have_content 'Ви успішно зареєстровані.' }

      it 'delivers email' do
        perform_enqueued_jobs
        expect(ActionMailer::Base.deliveries).to include(registration_email)
      end
    end

    context 'without contest_site' do
      let(:params) { attributes_for :user, contest_site: nil }

      before { click_on 'commit' }

      it('stays on registration page') { expect(page).to have_current_path(registration_path) }
      it { expect(page).to have_no_content 'Заклад, у якому ви пишете олімпіаду не може бути порожнім' }

      it 'does not deliver email' do
        perform_enqueued_jobs
        expect(ActionMailer::Base.deliveries).to_not include(registration_email)
      end
    end
  end

  describe 'for contest without institution' do
    let(:contest) { create :contest, registration_open: true, institutions: [] }

    before do
      fill_inputs 'user', params.slice(:name, :institution, :email, :registration_secret)
      fill_selects 'user', params.slice(:contest_site, :city, :grade)
    end

    context 'with everything valid' do
      let(:params) { attributes_for :user }

      before { click_on 'commit' }

      it { expect(page).to have_content 'Ви успішно зареєстровані.' }

      it 'delivers email' do
        perform_enqueued_jobs
        expect(ActionMailer::Base.deliveries).to include(registration_email)
      end
    end

    context 'without institution' do
      let(:params) { attributes_for :user, institution: nil }

      before { click_on 'commit' }

      it('stays on registration page') { expect(page).to have_current_path(registration_path) }
      it { expect(page).to have_no_content 'Ваш навчальний заклад не може бути порожнім' }

      it 'does not deliver email' do
        perform_enqueued_jobs
        expect(ActionMailer::Base.deliveries).to_not include(registration_email)
      end
    end
  end

  describe 'for contest without city' do
    let(:contest) { create :contest, registration_open: true, cities: [] }

    before do
      fill_inputs 'user', params.slice(:name, :email, :city, :registration_secret)
      fill_selects 'user', params.slice(:contest_site, :institution, :grade)
    end

    context 'with everything valid' do
      let(:params) { attributes_for :user }

      before { click_on 'commit' }

      it { expect(page).to have_content 'Ви успішно зареєстровані.' }

      it 'delivers email' do
        perform_enqueued_jobs
        expect(ActionMailer::Base.deliveries).to include(registration_email)
      end
    end

    context 'without city' do
      let(:params) { attributes_for :user, city: nil }

      before { click_on 'commit' }

      it('stays on registration page') { expect(page).to have_current_path(registration_path) }
      it { expect(page).to have_no_content 'Місто не може бути порожнім' }

      it 'does not deliver email' do
        perform_enqueued_jobs
        expect(ActionMailer::Base.deliveries).to_not include(registration_email)
      end
    end
  end
end
