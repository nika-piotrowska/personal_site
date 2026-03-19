# frozen_string_literal: true

class Experience < ApplicationRecord
  belongs_to :profile

  validates :position, :company, :start_date, presence: true

  scope :recent, -> { order(start_date: :desc) }
end
