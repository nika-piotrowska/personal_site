# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_profile
  before_action :set_project, only: :show

  def index
    @projects = @profile.projects.published.ordered
  end

  def show; end

  private

  def set_profile
    @profile = Profile.order(created_at: :desc).first
  end

  def set_project
    @project = @profile.projects.published.find_by!(slug: params[:id])
  end
end
