# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :profile

  acts_as_list scope: :profile

  validates :title, :slug, :short_description, presence: true
  validates :slug, uniqueness: true

  scope :ordered, -> { order(position: :asc) }
  scope :published, -> { where(published: true) }
  scope :featured, -> { where(featured: true) }

  def to_param
    slug
  end
end
