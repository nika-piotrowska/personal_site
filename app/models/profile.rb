# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user
  has_many :experiences, dependent: :destroy
  has_many :projects, dependent: :destroy

  validates :headline, :bio, :email, presence: true
end
