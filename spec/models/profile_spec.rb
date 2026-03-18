# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Profile, type: :model do
  subject(:profile) do
    described_class.new(
      user: user,
      headline: headline,
      bio: bio,
      email: email
    )
  end

  let(:user) do
    User.create!(
      email: 'user@example.com',
      password: 'Password123!',
      password_confirmation: 'Password123!'
    )
  end

  let(:headline) { 'Ruby on Rails Developer' }
  let(:bio) { 'I build maintainable web applications.' }
  let(:email) { 'profile@example.com' }

  describe 'associations' do
    it 'belongs to user' do
      association = described_class.reflect_on_association(:user)

      expect(association&.macro).to eq(:belongs_to)
    end

    it 'has many projects with dependent destroy' do
      association = described_class.reflect_on_association(:projects)

      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(profile).to be_valid
    end

    context 'when user is missing' do
      let(:user) { nil }

      it 'is invalid' do
        expect(profile).not_to be_valid
        expect(profile.errors[:user]).to include('must exist')
      end
    end

    context 'when headline is missing' do
      let(:headline) { nil }

      it 'is invalid' do
        expect(profile).not_to be_valid
        expect(profile.errors[:headline]).to include("can't be blank")
      end
    end

    context 'when bio is missing' do
      let(:bio) { nil }

      it 'is invalid' do
        expect(profile).not_to be_valid
        expect(profile.errors[:bio]).to include("can't be blank")
      end
    end

    context 'when email is missing' do
      let(:email) { nil }

      it 'is invalid' do
        expect(profile).not_to be_valid
        expect(profile.errors[:email]).to include("can't be blank")
      end
    end
  end

  describe 'dependent destroy' do # rubocop:disable RSpec/MultipleMemoizedHelpers
    let!(:persisted_profile) do
      described_class.create!(
        user: user,
        headline: headline,
        bio: bio,
        email: email
      )
    end

    let!(:project) do
      persisted_profile.projects.create!(
        title: 'Test Project',
        slug: 'test-project',
        short_description: 'Short description'
      )
    end

    it 'destroys associated projects when profile is destroyed' do
      expect { persisted_profile.destroy }.to change(Project, :count).by(-1)
      expect { project.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
