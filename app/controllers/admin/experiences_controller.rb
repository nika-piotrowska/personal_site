# frozen_string_literal: true

module Admin
  class ExperiencesController < BaseController
    before_action :set_profile
    before_action :set_experience, only: %i[show edit update destroy]

    def index
      @experiences = @profile.experiences.order(start_date: :desc)
    end

    def show; end

    def new
      @experience = @profile.experiences.new
    end

    def edit; end

    def create
      @experience = @profile.experiences.new(experience_params)

      if @experience.save
        redirect_to admin_experiences_path, notice: t('admin.flash.experiences.created')
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      if @experience.update(experience_params)
        redirect_to admin_experiences_path, notice: t('admin.flash.experiences.updated')
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      @experience.destroy
      redirect_to admin_experiences_path, notice: t('admin.flash.experiences.deleted')
    end

    private

    def set_profile
      @profile = current_user.profile
      redirect_to new_admin_profile_path, alert: t('admin.flash.create_profile_first') unless @profile
    end

    def set_experience
      @experience = @profile.experiences.find(params[:id])
    end

    def experience_params
      params.expect(
        experience: %i[
          position
          company
          description
          start_date
          end_date
        ]
      )
    end
  end
end
