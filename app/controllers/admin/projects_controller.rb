# frozen_string_literal: true

module Admin
  class ProjectsController < BaseController
    before_action :set_profile
    before_action :set_project, only: %i[show edit update destroy]

    def index
      @projects = @profile.projects.order(:position)
    end

    def show; end

    def new
      @project = @profile.projects.new
    end

    def edit; end

    def create
      @project = @profile.projects.new(project_params)

      if @project.save
        redirect_to admin_projects_path, notice: t('admin.flash.projects.created')
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      if @project.update(project_params)
        redirect_to admin_projects_path, notice: t('admin.flash.projects.updated')
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      @project.destroy
      redirect_to admin_projects_path, notice: t('admin.flash.projects.deleted')
    end

    private

    def set_profile
      @profile = current_user.profile
      redirect_to new_admin_profile_path unless @profile
    end

    def set_project
      @project = @profile.projects.find_by!(slug: params[:id])
    end

    def project_params # rubocop:disable Metrics/MethodLength
      params.expect(
        project: %i[
          title
          slug
          short_description
          description
          tech_stack
          repo_url
          live_url
          published
          featured
          position
        ]
      )
    end
  end
end
