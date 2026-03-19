# frozen_string_literal: true

module Admin
  class ProfilesController < BaseController
    before_action :set_profile

    def show; end

    def new
      redirect_to admin_profile_path if @profile.present?
      @profile = current_user.build_profile
    end

    def edit
      redirect_to new_admin_profile_path if @profile.blank?
    end

    def create
      @profile = current_user.build_profile(profile_params)

      if @profile.save
        redirect_to admin_profile_path, notice: 'Profile created successfully.'
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      if @profile.update(profile_params)
        redirect_to admin_profile_path, notice: 'Profile updated successfully.'
      else
        render :edit, status: :unprocessable_content
      end
    end

    private

    def set_profile
      @profile = current_user.profile
    end

    def profile_params
      params.expect(
        profile: %i[
          headline
          bio
          email
          location
          linkedin_url
          github_url
        ]
      )
    end
  end
end
