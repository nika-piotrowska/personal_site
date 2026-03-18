# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  describe 'associations' do
    it 'has one profile' do
      association = described_class.reflect_on_association(:profile)

      expect(association&.macro).to eq(:has_one)
      expect(association&.options&.[](:dependent)).to eq(:destroy)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    context 'when email is missing' do
      subject(:user) { build(:user, email: nil) }

      it 'is invalid' do
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("can't be blank")
      end
    end

    context 'when email is duplicated' do
      before do
        create(:user, email: user.email)
      end

      it 'is invalid' do
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include('has already been taken')
      end
    end
  end
end
