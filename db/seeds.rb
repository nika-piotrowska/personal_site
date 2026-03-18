# frozen_string_literal: true

require 'faker'

Rails.logger.debug 'Seeding database...'

Faker::UniqueGenerator.clear

Project.delete_all
Profile.delete_all
User.delete_all

user = User.create!(
  email: 'admin@example.com',
  password: 'Password123!',
  password_confirmation: 'Password123!'
)

profile = user.create_profile!(
  headline: Faker::Job.title,
  bio: Faker::Lorem.paragraph,
  location: Faker::Address.country,
  email: Faker::Internet.email,
  github_url: "https://github.com/#{Faker::Internet.username}",
  linkedin_url: "https://linkedin.com/in/#{Faker::Internet.username}"
)

10.times do
  profile.projects.create!(
    title: Faker::App.unique.name,
    slug: Faker::Internet.unique.slug,
    short_description: Faker::Lorem.sentence(word_count: 10),
    description: Faker::Lorem.paragraph(sentence_count: 5),
    tech_stack: %w[Ruby Rails PostgreSQL Redis Docker Turbo].sample(3).join(', '),
    repo_url: Faker::Internet.url,
    live_url: Faker::Internet.url,
    featured: [true, false].sample,
    published: true
  )
end

Rails.logger.debug 'Done.'
