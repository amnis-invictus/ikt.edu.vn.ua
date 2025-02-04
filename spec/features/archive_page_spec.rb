require 'rails_helper'

RSpec.feature 'Archive Page', :ui do
  let!(:archived_contests) { create_list :contest, 2, :archived }

  describe 'content' do
    context 'with archived contests only' do
      before { visit '/contests' }

      it('has no sidebar') { expect(page).to have_no_css('#sidebar') }

      it('lists the archived contests') { archived_contests.each { expect(page).to have_link(_1.display_name) } }
    end

    context 'with an active contest' do
      before do
        create :contest, :active
        visit '/contests'
      end

      it('is empty') { expect(page).to have_no_css('#contents *') }
    end

    context 'with a future contest' do
      before do
        create :contest, :future
        visit '/contests'
      end

      it('lists the archived contests') { archived_contests.each { expect(page).to have_link(_1.display_name) } }
    end
  end
end
