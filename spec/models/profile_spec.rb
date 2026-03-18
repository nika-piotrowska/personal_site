# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Profile, type: :model do
  subject(:profile) { build(:profile) }

  describe 'associations' do
    it 'belongs to user' do
      association = described_class.reflect_on_association(:user)

      expect(association&.macro).to eq(:belongs_to)
    end

    it 'has many projects with dependent destroy' do
      association = described_class.reflect_on_association(:projects)

      expect(association&.macro).to eq(:has_many)
      expect(association&.options&.[](:dependent)).to eq(:destroy)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(profile).to be_valid
    end

    context 'when user is missing' do
      subject(:profile) { build(:profile, user: nil) }

      it 'is invalid' do
        expect(profile).not_to be_valid
        expect(profile.errors[:user]).to include('must exist')
      end
    end

    context 'when headline is missing' do
      subject(:profile) { build(:profile, headline: nil) }

      it 'is invalid' do
        expect(profile).not_to be_valid
        expect(profile.errors[:headline]).to include("can't be blank")
      end
    end

    context 'when bio is missing' do
      subject(:profile) { build(:profile, bio: nil) }

      it 'is invalid' do
        expect(profile).not_to be_valid
        expect(profile.errors[:bio]).to include("can't be blank")
      end
    end

    context 'when email is missing' do
      subject(:profile) { build(:profile, email: nil) }

      it 'is invalid' do
        expect(profile).not_to be_valid
        expect(profile.errors[:email]).to include("can't be blank")
      end
    end
  end

  describe 'dependent destroy' do
    let!(:profile) { create(:profile) }
    let!(:project) { create(:project, profile: profile) } # rubocop:disable RSpec/LetSetup

    it 'destroys associated projects when profile is destroyed' do
      expect { profile.destroy }.to change(Project, :count).by(-1)
    end
  end
end
