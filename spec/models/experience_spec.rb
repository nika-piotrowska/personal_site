# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Experience, type: :model do
  subject(:experience) { build(:experience) }

  describe 'associations' do
    it 'belongs to profile' do
      association = described_class.reflect_on_association(:profile)

      expect(association&.macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(experience).to be_valid
    end

    it 'is invalid without a position' do
      experience.position = nil

      expect(experience).not_to be_valid
      expect(experience.errors[:position]).to include("can't be blank")
    end

    it 'is invalid without a company' do
      experience.company = nil

      expect(experience).not_to be_valid
      expect(experience.errors[:company]).to include("can't be blank")
    end

    it 'is invalid without a start_date' do
      experience.start_date = nil

      expect(experience).not_to be_valid
      expect(experience.errors[:start_date]).to include("can't be blank")
    end
  end
end
