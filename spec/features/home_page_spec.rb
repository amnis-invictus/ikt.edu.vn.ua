require 'rails_helper'

RSpec.feature 'Home Page', :ui do
  before { create_list :contest, 2, :archived }

  describe 'content' do
    context 'with archived contests only' do
      before { visit '/' }

      it('links to the memo') { expect(page).to have_link("Пам'ятка учасника олімпіади") }

      it('links to the archive') { expect(page).to have_link('Архів') }
    end

    context 'with an active contest' do
      let!(:active_contest) { create :contest, :active }

      before { visit '/' }

      it('does not link to the archive') { expect(page).to have_no_link('Архів') }

      it('links to the active contest') { expect(page).to have_link(active_contest.display_name) }
    end

    context 'with future contests' do
      let!(:future_contests) { create_list :contest, 2, :future }

      before { visit '/' }

      it('links to the archive') { expect(page).to have_link('Архів') }

      it('links to the future contests') { future_contests.each { expect(page).to have_link(_1.display_name) } }
    end
  end
end
