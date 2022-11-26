require 'rails_helper'

RSpec.describe 'ContestPolicy', ui: true do
  describe 'registration' do
    before { visit "/contests/#{contest.id}/users/new" }

    context 'when closed' do
      let(:contest) { create(:contest, registration_open: false) }

      it { expect(page).to have_content 'РЕЄСТРАЦІЯ УЧАСНИКА' }
      it { expect(page).to have_content 'Реєстрація заборонена. Повідомте технічного працівника.' }
      it { expect(page).to_not have_css 'form#regform', visible: :all }
      it { expect(page).to_not have_button 'commit' }
    end

    context 'when open' do
      let(:contest) { create(:contest, registration_open: true) }

      it { expect(page).to have_content 'РЕЄСТРАЦІЯ УЧАСНИКА' }
      it { expect(page).to have_no_content 'Реєстрація заборонена. Повідомте технічного працівника.' }
      it { expect(page).to have_css 'form#regform', visible: :visible }
      it { expect(page).to have_button 'commit' }
    end
  end

  # TODO: Add additional content upload / check
  describe 'viewing content' do
    before { visit "/contests/#{contest.id}/content" }

    context 'when task closed' do
      let(:contest) { create(:contest, task_open: false) }

      it { expect(page).to have_content 'Перегляд завдання заборонено. Повідомте технічного працівника.' }
      it { expect(page.html).to_not include contest.content }
      it { expect(page).to have_no_content 'Додаткові матеріали' }
    end

    context 'when task open' do
      let(:contest) { create(:contest, task_open: true) }

      it { expect(page).to have_no_content 'Перегляд завдання заборонено. Повідомте технічного працівника.' }
      it { expect(page.html).to include contest.content }
      it { expect(page).to have_content 'Додаткові матеріали' }
    end
  end

  describe 'upload' do
    before { visit "/contests/#{contest.id}/upload/new" }

    context 'when closed' do
      let(:contest) { create(:contest, upload_open: false) }

      it { expect(page).to have_content 'ВІДПРАВКА РОЗВ\'ЯЗКІВ' }
      it { expect(page).to have_content 'Відправка розв\'язків заборонена. Повідомте технічного працівника.' }
      it { expect(page).to_not have_css 'form', visible: :all }
      it { expect(page).to_not have_button 'commit' }
    end

    context 'when open' do
      let(:contest) { create(:contest, upload_open: true) }

      it { expect(page).to have_content 'ВІДПРАВКА РОЗВ\'ЯЗКІВ' }
      it { expect(page).to have_no_content 'Відправка розв\'язків заборонена. Повідомте технічного працівника.' }
      it { expect(page).to have_css 'form', visible: :visible }
      it { expect(page).to have_button 'commit' }
    end
  end
end
