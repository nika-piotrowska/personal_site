# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  subject(:project) { build(:project) }

  describe 'associations' do
    it 'belongs to profile' do
      association = described_class.reflect_on_association(:profile)

      expect(association&.macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(project).to be_valid
    end

    context 'when profile is missing' do
      subject(:project) { build(:project, profile: nil) }

      it 'is invalid' do
        expect(project).not_to be_valid
        expect(project.errors[:profile]).to include('must exist')
      end
    end

    context 'when title is missing' do
      subject(:project) { build(:project, title: nil) }

      it 'is invalid' do
        expect(project).not_to be_valid
        expect(project.errors[:title]).to include("can't be blank")
      end
    end

    context 'when slug is missing' do
      subject(:project) { build(:project, slug: nil) }

      it 'is invalid' do
        expect(project).not_to be_valid
        expect(project.errors[:slug]).to include("can't be blank")
      end
    end

    context 'when short_description is missing' do
      subject(:project) { build(:project, short_description: nil) }

      it 'is invalid' do
        expect(project).not_to be_valid
        expect(project.errors[:short_description]).to include("can't be blank")
      end
    end

    context 'when slug is duplicated' do
      subject(:project) { build(:project, profile: profile, slug: 'duplicate-slug') }

      let(:profile) { create(:profile) }

      before do
        create(:project, profile: profile, slug: 'duplicate-slug')
      end

      it 'is invalid' do
        expect(project).not_to be_valid
        expect(project.errors[:slug]).to include('has already been taken')
      end
    end
  end

  describe '#to_param' do
    let(:project) { create(:project, slug: 'tor-exit-nodes-api') }

    it 'returns slug' do
      expect(project.to_param).to eq('tor-exit-nodes-api')
    end
  end

  describe 'acts_as_list' do
    let(:profile) { create(:profile) }
    let!(:first_project) { create(:project, profile: profile, title: 'Project 1', slug: 'project-1') }
    let!(:second_project) { create(:project, profile: profile, title: 'Project 2', slug: 'project-2') }

    describe 'within same profile' do
      it 'orders projects by position' do
        expect(profile.projects.order(:position)).to eq([first_project, second_project])
      end

      it 'moves a project higher in the list' do
        second_project.move_higher

        expect(profile.projects.order(:position)).to eq([second_project, first_project])
      end
    end

    describe 'with another profile' do
      let(:another_profile) { create(:profile) }
      let!(:other_project) { create(:project, profile: another_profile, title: 'Other Project', slug: 'other-project') }

      it 'does not affect projects from another profile' do
        second_project.move_higher

        expect(profile.projects.order(:position)).to eq([second_project, first_project])
        expect(another_profile.projects.order(:position)).to eq([other_project])
      end
    end
  end
end
