# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Projects', type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET /admin/projects' do
    context 'when user has profile' do
      let!(:profile) { create(:profile, user: user) }
      let!(:project) { create(:project, profile: profile) }

      it 'returns http success' do
        get admin_projects_path

        expect(response).to have_http_status(:ok)
      end

      it 'renders projects' do
        get admin_projects_path

        expect(response.body).to include(project.title)
      end
    end

    context 'when user does not have profile' do
      it 'redirects to new profile page' do
        get admin_projects_path

        expect(response).to redirect_to(new_admin_profile_path)
      end
    end
  end

  describe 'GET /admin/projects/:id' do
    let!(:profile) { create(:profile, user: user) }
    let!(:project) { create(:project, profile: profile) }

    it 'returns http success' do
      get admin_project_path(project.slug)

      expect(response).to have_http_status(:ok)
    end

    it 'renders project details' do
      get admin_project_path(project.slug)

      expect(response.body).to include(project.title)
      expect(response.body).to include(project.slug)
    end

    context 'when project belongs to another profile' do
      let!(:other_project) { create(:project) }

      it 'returns not found' do
        get admin_project_path(other_project.slug)

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET /admin/projects/new' do
    context 'when profile exists' do
      let!(:profile) { create(:profile, user: user) } # rubocop:disable RSpec/LetSetup

      it 'returns http success' do
        get new_admin_project_path

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when profile does not exist' do
      it 'redirects to new profile page' do
        get new_admin_project_path

        expect(response).to redirect_to(new_admin_profile_path)
      end
    end
  end

  describe 'GET /admin/projects/:id/edit' do
    let!(:profile) { create(:profile, user: user) }
    let!(:project) { create(:project, profile: profile) }

    it 'returns http success' do
      get edit_admin_project_path(project.slug)

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /admin/projects' do
    let!(:profile) { create(:profile, user: user) }

    let(:valid_params) do
      {
        project: {
          title: 'Portfolio App',
          slug: 'portfolio-app',
          short_description: 'Short description',
          description: 'Full description',
          tech_stack: 'Rails, PostgreSQL',
          repo_url: 'https://github.com/test/repo',
          live_url: 'https://example.com',
          published: true,
          featured: false,
          position: 1
        }
      }
    end

    let(:invalid_params) do
      {
        project: {
          title: '',
          slug: '',
          short_description: '',
          position: nil
        }
      }
    end

    context 'with valid params' do
      it 'creates project' do
        expect do
          post admin_projects_path, params: valid_params
        end.to change(profile.projects, :count).by(1)
      end

      it 'redirects to index' do
        post admin_projects_path, params: valid_params

        expect(response).to redirect_to(admin_projects_path)
        expect(flash[:notice]).to eq('Project created.')
      end
    end

    context 'with invalid params' do
      it 'does not create project' do
        expect do
          post admin_projects_path, params: invalid_params
        end.not_to change(Project, :count)
      end

      it 'renders new with unprocessable status' do
        post admin_projects_path, params: invalid_params

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'PATCH /admin/projects/:id' do
    let!(:profile) { create(:profile, user: user) }
    let!(:project) { create(:project, profile: profile) }

    let(:valid_params) do
      {
        project: {
          title: 'Updated Project',
          slug: project.slug,
          short_description: 'Updated short',
          description: 'Updated description',
          tech_stack: 'Rails',
          repo_url: 'https://github.com/new',
          live_url: 'https://new.com',
          published: false,
          featured: true,
          position: 2
        }
      }
    end

    let(:invalid_params) do
      {
        project: {
          title: '',
          slug: '',
          short_description: ''
        }
      }
    end

    context 'with valid params' do
      it 'updates project' do
        patch admin_project_path(project.slug), params: valid_params

        project.reload

        expect(project.title).to eq('Updated Project')
        expect(project.position).to eq(2)
        expect(project.featured).to be(true)
      end

      it 'redirects to index' do
        patch admin_project_path(project.slug), params: valid_params

        expect(response).to redirect_to(admin_projects_path)
        expect(flash[:notice]).to eq('Project updated.')
      end
    end

    context 'with invalid params' do
      it 'does not update project' do
        original_title = project.title

        patch admin_project_path(project.slug), params: invalid_params

        expect(project.reload.title).to eq(original_title)
      end

      it 'renders edit with unprocessable status' do
        patch admin_project_path(project.slug), params: invalid_params

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'DELETE /admin/projects/:id' do
    let!(:profile) { create(:profile, user: user) }
    let!(:project) { create(:project, profile: profile) }

    it 'deletes project' do
      expect do
        delete admin_project_path(project.slug)
      end.to change(Project, :count).by(-1)
    end

    it 'redirects to index' do
      delete admin_project_path(project.slug)

      expect(response).to redirect_to(admin_projects_path)
      expect(flash[:notice]).to eq('Project deleted.')
    end
  end

  describe 'authentication' do
    before do
      sign_out user
    end

    it 'redirects unauthenticated user' do
      get admin_projects_path

      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
