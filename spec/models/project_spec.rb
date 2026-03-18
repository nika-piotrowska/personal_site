# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  subject(:project) do
    described_class.new(
      profile: profile,
      title: title,
      slug: slug,
      short_description: short_description
    )
  end

  let(:user) do
    User.create!(
      email: 'user@example.com',
      password: 'Password123!',
      password_confirmation: 'Password123!'
    )
  end

  let(:profile) do
    Profile.create!(
      user: user,
      headline: 'Ruby on Rails Developer',
      bio: 'I build maintainable web applications.',
      email: 'profile@example.com'
    )
  end

  let(:title) { 'whatever API' }
  let(:slug) { 'whatever-api' }
  let(:short_description) { 'API for checking whatever.' }

  describe 'associations' do
    it 'belongs to profile' do
      association = described_class.reflect_on_association(:profile)

      expect(association).not_to be_nil
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(project).to be_valid
    end

    context 'when profile is missing' do
      let(:profile) { nil }

      it 'is invalid' do
        expect(project).not_to be_valid
        expect(project.errors[:profile]).to include('must exist')
      end
    end

    context 'when title is missing' do
      let(:title) { nil }

      it 'is invalid' do
        expect(project).not_to be_valid
        expect(project.errors[:title]).to include("can't be blank")
      end
    end

    context 'when slug is missing' do
      let(:slug) { nil }

      it 'is invalid' do
        expect(project).not_to be_valid
        expect(project.errors[:slug]).to include("can't be blank")
      end
    end

    context 'when short_description is missing' do
      let(:short_description) { nil }

      it 'is invalid' do
        expect(project).not_to be_valid
        expect(project.errors[:short_description]).to include("can't be blank")
      end
    end

    context 'when slug is duplicated' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let!(:existing_project) do
        described_class.create!(
          profile: profile,
          title: 'First Project',
          slug: slug,
          short_description: 'First description'
        )
      end

      let(:title) { 'Second Project' }
      let(:short_description) { 'Second description' }

      it 'is invalid' do
        existing_project

        expect(project).not_to be_valid
        expect(project.errors[:slug]).to include('has already been taken')
      end
    end
  end

  describe '#to_param' do # rubocop:disable RSpec/MultipleMemoizedHelpers
    let(:persisted_project) do
      described_class.create!(
        profile: profile,
        title: title,
        slug: slug,
        short_description: short_description
      )
    end

    it 'returns slug' do
      expect(persisted_project.to_param).to eq(slug)
    end
  end

  describe 'acts_as_list' do # rubocop:disable RSpec/MultipleMemoizedHelpers
    let!(:first_project) do
      described_class.create!(
        profile: profile,
        title: 'Project 1',
        slug: 'project-1',
        short_description: 'Description 1'
      )
    end

    let!(:second_project) do
      described_class.create!(
        profile: profile,
        title: 'Project 2',
        slug: 'project-2',
        short_description: 'Description 2'
      )
    end

    describe 'within same profile' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      it 'orders projects by position' do
        expect(profile.projects.order(:position)).to eq([first_project, second_project])
      end

      it 'moves a project higher in the list' do
        second_project.move_higher

        expect(profile.projects.order(:position)).to eq([second_project, first_project])
      end
    end

    describe 'with another profile' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:another_user) do
        User.create!(
          email: 'another@example.com',
          password: 'Password123!',
          password_confirmation: 'Password123!'
        )
      end

      let(:another_profile) do
        Profile.create!(
          user: another_user,
          headline: 'Another Developer',
          bio: 'Another bio',
          email: 'another_profile@example.com'
        )
      end

      let!(:other_project) do
        described_class.create!(
          profile: another_profile,
          title: 'Other Project',
          slug: 'other-project',
          short_description: 'Other description'
        )
      end

      it 'does not affect projects from another profile' do # rubocop:disable RSpec/MultipleExpectations
        expect(profile.projects.order(:position)).to eq([first_project, second_project])
        expect(another_profile.projects.order(:position)).to eq([other_project])

        second_project.move_higher

        expect(profile.projects.order(:position)).to eq([second_project, first_project])
        expect(another_profile.projects.order(:position)).to eq([other_project])
        expect(other_project.reload.position).to eq(1)
      end
    end
  end
end
