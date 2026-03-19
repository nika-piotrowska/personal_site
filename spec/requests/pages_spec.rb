# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Pages', type: :request do
  describe 'GET /' do
    context 'when profile exists' do
      let!(:profile) do
        create(
          :profile,
          headline: 'Ruby on Rails Developer',
          bio: 'Building reliable backend applications.',
          email: 'weronika@example.com',
          location: 'Poland'
        )
      end

      let!(:featured_project) do
        create(
          :project,
          profile: profile,
          title: 'Portfolio App',
          short_description: 'Personal site built with Rails',
          featured: true,
          published: true,
          position: 1
        )
      end

      let(:non_featured_project) do
        create(
          :project,
          profile: profile,
          title: 'Internal Admin Tool',
          short_description: 'Tool for operations team',
          featured: false,
          published: true,
          position: 2
        )
      end

      let!(:experience) do
        create(
          :experience,
          profile: profile,
          position: 'Backend Developer',
          company: 'Example Company'
        )
      end

      it 'returns http success' do
        get '/'

        expect(response).to have_http_status(:success)
      end

      it 'renders profile headline and bio' do
        get '/'

        expect(response.body).to include(profile.headline)
        expect(response.body).to include(profile.bio)
      end

      it 'renders featured projects section content' do
        get '/'

        expect(response.body).to include(featured_project.title)
        expect(response.body).to include(featured_project.short_description)
      end

      it 'renders recent experience section content' do
        get '/'

        expect(response.body).to include(experience.position)
        expect(response.body).to include(experience.company)
      end
    end

    context 'when profile does not exist' do
      it 'returns http success' do
        get '/'

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET /about' do
    context 'when profile exists' do
      let!(:profile) do
        create(
          :profile,
          bio: 'About page bio content',
          email: 'weronika@example.com',
          github_url: 'https://github.com/nika-piotrowska',
          linkedin_url: 'https://linkedin.com/in/nika-piotrowska',
          location: 'Poland'
        )
      end

      it 'returns http success' do
        get '/about'

        expect(response).to have_http_status(:success)
      end

      it 'renders profile details' do # rubocop:disable RSpec/MultipleExpectations
        get '/about'

        expect(response.body).to include(profile.bio)
        expect(response.body).to include(profile.email)
        expect(response.body).to include(profile.github_url)
        expect(response.body).to include(profile.linkedin_url)
        expect(response.body).to include(profile.location)
      end
    end

    context 'when profile does not exist' do
      it 'returns http success' do
        get '/about'

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET /experience' do
    context 'when profile exists' do
      let!(:profile) { create(:profile) }

      let!(:newer_experience) do
        create(
          :experience,
          profile: profile,
          position: 'Senior Backend Developer',
          company: 'Company B',
          start_date: Date.new(2024, 1, 1)
        )
      end

      let!(:older_experience) do
        create(
          :experience,
          profile: profile,
          position: 'Backend Developer',
          company: 'Company A',
          start_date: Date.new(2022, 1, 1)
        )
      end

      it 'returns http success' do
        get '/experience'

        expect(response).to have_http_status(:success)
      end

      it 'renders experiences' do # rubocop:disable RSpec/MultipleExpectations
        get '/experience'

        expect(response.body).to include(newer_experience.position)
        expect(response.body).to include(newer_experience.company)
        expect(response.body).to include(older_experience.position)
        expect(response.body).to include(older_experience.company)
      end

      it 'renders experiences ordered by start date descending' do
        get '/experience'

        expect(response.body.index(newer_experience.position))
          .to be < response.body.index(older_experience.position)
      end
    end

    context 'when profile does not exist' do
      it 'returns http success' do
        get '/experience'

        expect(response).to have_http_status(:success)
      end
    end
  end
end
