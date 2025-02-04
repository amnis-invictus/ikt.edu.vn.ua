require 'rails_helper'

RSpec.describe ContestsController do
  describe '#contest' do
    context 'when variable assigned' do
      before { controller.instance_variable_set :@contest, :contest }

      its(:contest) { should eq :contest }
    end

    context 'when created' do
      let(:contest) { create :contest }

      before do
        allow(controller).to receive(:params).and_return(id: contest.id.to_s)
      end

      its(:contest) { should eq contest }
    end
  end

  describe '#collection' do
    context 'when variable assigned' do
      before { controller.instance_variable_set :@collection, :collection }

      its(:collection) { should eq :collection }
    end

    context 'without active contest' do
      let(:archived_contests) { create_list :contest, 2, :archived }

      before { create :contest, :future }

      its(:collection) { should eq archived_contests }
    end

    context 'with active contest' do
      before do
        create :contest, :archived
        create :contest, :active
      end

      its(:collection) { should be_empty }
    end
  end
end
