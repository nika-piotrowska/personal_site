# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :set_profile, only: %i[about experience]
  def home
    @profile = Profile.includes(:projects, :experiences).first
    @featured_projects = published_projects.featured.ordered.limit(3)
    @recent_experiences = experiences.recent.limit(3)
  end

  def about; end

  def experience
    @experiences = experiences.recent
  end

  private

  def current_profile
    @current_profile ||= Profile.first
  end

  def published_projects
    return Project.none unless current_profile

    current_profile.projects.published
  end

  def experiences
    return Experience.none unless current_profile

    current_profile.experiences
  end

  def set_profile
    @profile = Profile.first
  end
end
