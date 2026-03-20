# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Experiences', type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET /admin/experiences' do
    context 'when user has profile' do
      let!(:profile) { create(:profile, user: user) }
      let!(:experience) { create(:experience, profile: profile) }

      it 'returns http success' do
        get admin_experiences_path

        expect(response).to have_http_status(:ok)
      end

      it 'assigns experiences belonging to current user profile' do
        get admin_experiences_path

        expect(response.body).to include(experience.position)
        expect(response.body).to include(experience.company)
      end
    end

    context 'when user does not have profile' do
      it 'redirects to new admin profile path' do
        get admin_experiences_path

        expect(response).to redirect_to(new_admin_profile_path)
        expect(flash[:alert]).to eq('Create your profile first.')
      end
    end
  end

  describe 'GET /admin/experiences/:id' do
    let!(:profile) { create(:profile, user: user) }
    let!(:experience) { create(:experience, profile: profile) }

    it 'returns http success' do
      get admin_experience_path(experience)

      expect(response).to have_http_status(:ok)
    end

    it 'renders experience details' do
      get admin_experience_path(experience)

      expect(response.body).to include(experience.position)
      expect(response.body).to include(experience.company)
    end

    context 'when experience belongs to another profile' do
      let!(:other_experience) { create(:experience) }

      it 'returns not found' do
        get admin_experience_path(other_experience)

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET /admin/experiences/new' do
    context 'when user has profile' do
      let!(:profile) { create(:profile, user: user) } # rubocop:disable RSpec/LetSetup

      it 'returns http success' do
        get new_admin_experience_path

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user does not have profile' do
      it 'redirects to new admin profile path' do
        get new_admin_experience_path

        expect(response).to redirect_to(new_admin_profile_path)
        expect(flash[:alert]).to eq('Create your profile first.')
      end
    end
  end

  describe 'GET /admin/experiences/:id/edit' do
    let!(:profile) { create(:profile, user: user) }
    let!(:experience) { create(:experience, profile: profile) }

    it 'returns http success' do
      get edit_admin_experience_path(experience)

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /admin/experiences' do
    let!(:profile) { create(:profile, user: user) }

    let(:valid_params) do
      {
        experience: {
          position: 'Ruby on Rails Developer',
          company: 'YES Biżuteria',
          description: 'Building admin panel and portfolio features.',
          start_date: Date.new(2023, 1, 1),
          end_date: Date.new(2024, 1, 1)
        }
      }
    end

    let(:invalid_params) do
      {
        experience: {
          position: '',
          company: '',
          description: 'Missing required fields',
          start_date: nil,
          end_date: nil
        }
      }
    end

    context 'with valid params' do
      it 'creates a new experience' do
        expect do
          post admin_experiences_path, params: valid_params
        end.to change(profile.experiences, :count).by(1)
      end

      it 'redirects to experiences index' do
        post admin_experiences_path, params: valid_params

        expect(response).to redirect_to(admin_experiences_path)
        expect(flash[:notice]).to eq('Experience created successfully.')
      end
    end

    context 'with invalid params' do
      it 'does not create a new experience' do
        expect do
          post admin_experiences_path, params: invalid_params
        end.not_to change(Experience, :count)
      end

      it 'renders new with unprocessable content status' do
        post admin_experiences_path, params: invalid_params

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'PATCH /admin/experiences/:id' do
    let!(:profile) { create(:profile, user: user) }
    let!(:experience) { create(:experience, profile: profile) }

    let(:valid_params) do
      {
        experience: {
          position: 'Senior Ruby Developer',
          company: 'Updated Company',
          description: 'Updated description',
          start_date: Date.new(2022, 1, 1),
          end_date: Date.new(2025, 1, 1)
        }
      }
    end

    let(:invalid_params) do
      {
        experience: {
          position: '',
          company: '',
          start_date: nil
        }
      }
    end

    context 'with valid params' do
      it 'updates the experience' do # rubocop:disable RSpec/MultipleExpectations
        patch admin_experience_path(experience), params: valid_params

        experience.reload

        expect(experience.position).to eq('Senior Ruby Developer')
        expect(experience.company).to eq('Updated Company')
        expect(experience.description).to eq('Updated description')
        expect(experience.start_date).to eq(Date.new(2022, 1, 1))
        expect(experience.end_date).to eq(Date.new(2025, 1, 1))
      end

      it 'redirects to experiences index' do
        patch admin_experience_path(experience), params: valid_params

        expect(response).to redirect_to(admin_experiences_path)
        expect(flash[:notice]).to eq('Experience updated successfully.')
      end
    end

    context 'with invalid params' do
      it 'does not update the experience' do
        original_position = experience.position

        patch admin_experience_path(experience), params: invalid_params

        expect(response).to have_http_status(:unprocessable_content)
        expect(experience.reload.position).to eq(original_position)
      end
    end
  end

  describe 'DELETE /admin/experiences/:id' do
    let!(:profile) { create(:profile, user: user) }
    let!(:experience) { create(:experience, profile: profile) }

    it 'deletes the experience' do
      expect do
        delete admin_experience_path(experience)
      end.to change(Experience, :count).by(-1)
    end

    it 'redirects to experiences index' do
      delete admin_experience_path(experience)

      expect(response).to redirect_to(admin_experiences_path)
      expect(flash[:notice]).to eq('Experience deleted successfully.')
    end
  end

  describe 'authentication' do
    before do
      sign_out user
    end

    it 'redirects unauthenticated user from index' do
      get admin_experiences_path

      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
