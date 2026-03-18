# frozen_string_literal: true

class Experience < ApplicationRecord
  belongs_to :profile

  validates :position, :company, :start_date, presence: true
end
