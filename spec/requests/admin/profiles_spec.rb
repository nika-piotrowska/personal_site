# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Profiles', type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET /admin/profile' do
    context 'when profile exists' do
      let!(:profile) { create(:profile, user: user) }

      it 'returns http success' do
        get admin_profile_path

        expect(response).to have_http_status(:ok)
      end

      it 'renders profile details' do
        get admin_profile_path

        expect(response.body).to include(profile.headline)
        expect(response.body).to include(profile.email)
      end
    end

    context 'when profile does not exist' do
      it 'returns http success' do
        get admin_profile_path

        expect(response).to have_http_status(:ok)
      end

      it 'renders create profile CTA' do
        get admin_profile_path

        expect(response.body).to include('Create profile')
      end
    end
  end

  describe 'GET /admin/profile/new' do
    context 'when profile does not exist' do
      it 'returns http success' do
        get new_admin_profile_path

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when profile already exists' do
      let!(:profile) { create(:profile, user: user) } # rubocop:disable RSpec/LetSetup

      it 'redirects to profile show page' do
        get new_admin_profile_path

        expect(response).to redirect_to(admin_profile_path)
      end
    end
  end

  describe 'GET /admin/profile/edit' do
    context 'when profile exists' do
      let!(:profile) { create(:profile, user: user) } # rubocop:disable RSpec/LetSetup

      it 'returns http success' do
        get edit_admin_profile_path

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when profile does not exist' do
      it 'redirects to new profile page' do
        get edit_admin_profile_path

        expect(response).to redirect_to(new_admin_profile_path)
      end
    end
  end

  describe 'POST /admin/profile' do
    let(:valid_params) do
      {
        profile: {
          headline: 'Ruby on Rails Developer',
          bio: 'Building clean and maintainable web applications.',
          email: 'weronika@example.com',
          location: 'Warsaw, Poland',
          linkedin_url: 'https://linkedin.com/in/weronika',
          github_url: 'https://github.com/nika-piotrowska'
        }
      }
    end

    let(:invalid_params) do
      {
        profile: {
          headline: '',
          bio: '',
          email: '',
          location: 'Warsaw, Poland',
          linkedin_url: '',
          github_url: ''
        }
      }
    end

    context 'when profile does not exist' do
      it 'creates a profile' do
        expect do
          post admin_profile_path, params: valid_params
        end.to change(Profile, :count).by(1)
      end

      it 'creates profile for current user' do
        post admin_profile_path, params: valid_params

        expect(user.reload.profile).to be_present
        expect(user.profile.headline).to eq('Ruby on Rails Developer')
      end

      it 'redirects to profile page after successful creation' do
        post admin_profile_path, params: valid_params

        expect(response).to redirect_to(admin_profile_path)
        expect(flash[:notice]).to eq('Profile created successfully.')
      end
    end

    context 'when params are invalid' do
      it 'does not create profile' do
        expect do
          post admin_profile_path, params: invalid_params
        end.not_to change(Profile, :count)
      end

      it 'renders new with unprocessable content status' do
        post admin_profile_path, params: invalid_params

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'PATCH /admin/profile' do
    let!(:profile) { create(:profile, user: user) }

    let(:valid_params) do
      {
        profile: {
          headline: 'Senior Ruby Developer',
          bio: 'Updated bio content.',
          email: 'updated@example.com',
          location: 'Krakow, Poland',
          linkedin_url: 'https://linkedin.com/in/updated',
          github_url: 'https://github.com/updated'
        }
      }
    end

    let(:invalid_params) do
      {
        profile: {
          headline: '',
          bio: '',
          email: ''
        }
      }
    end

    context 'when params are valid' do
      it 'updates the profile' do # rubocop:disable RSpec/MultipleExpectations
        patch admin_profile_path, params: valid_params

        profile.reload

        expect(profile.headline).to eq('Senior Ruby Developer')
        expect(profile.bio).to eq('Updated bio content.')
        expect(profile.email).to eq('updated@example.com')
        expect(profile.location).to eq('Krakow, Poland')
        expect(profile.linkedin_url).to eq('https://linkedin.com/in/updated')
        expect(profile.github_url).to eq('https://github.com/updated')
      end

      it 'redirects to profile page after successful update' do
        patch admin_profile_path, params: valid_params

        expect(response).to redirect_to(admin_profile_path)
        expect(flash[:notice]).to eq('Profile updated successfully.')
      end
    end

    context 'when params are invalid' do
      it 'does not update the profile' do
        original_headline = profile.headline
        original_email = profile.email

        patch admin_profile_path, params: invalid_params

        profile.reload

        expect(profile.headline).to eq(original_headline)
        expect(profile.email).to eq(original_email)
      end

      it 'renders edit with unprocessable content status' do
        patch admin_profile_path, params: invalid_params

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'authentication' do
    before do
      sign_out user
    end

    it 'redirects unauthenticated user from show' do
      get admin_profile_path

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects unauthenticated user from new' do
      get new_admin_profile_path

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects unauthenticated user from edit' do
      get edit_admin_profile_path

      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
