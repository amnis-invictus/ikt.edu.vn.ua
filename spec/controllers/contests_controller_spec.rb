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
      let(:contest) { create :contest, archived: true }

      before do
        create :contest, archived: false, upload_open: false, registration_open: false
      end

      its(:collection) { should eq [contest] }
    end

    context 'with active contest' do
      before do
        create :contest, archived: true
        create :contest, archived: false, upload_open: true, registration_open: true
      end

      its(:collection) { should be_empty }
    end
  end
end
