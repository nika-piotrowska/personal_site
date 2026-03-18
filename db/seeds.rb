# frozen_string_literal: true

require 'faker'

Rails.logger.debug 'Seeding database...'

Faker::UniqueGenerator.clear
Faker::Config.random = Random.new(42)

Experience.delete_all
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
  bio: Faker::Lorem.paragraph(sentence_count: 5),
  location: Faker::Address.country,
  email: Faker::Internet.email,
  github_url: "https://github.com/#{Faker::Internet.username(specifier: 8..12)}",
  linkedin_url: "https://linkedin.com/in/#{Faker::Internet.username(specifier: 8..12)}"
)

experience_companies = [
  'Company One',
  'Company Two',
  'Company Three'
]

experience_positions = [
  'Ruby on Rails Developer',
  'Backend Developer',
  'Software Engineer'
]

3.times do |index|
  start_date = Date.current - (index + 3).years
  end_date = index.zero? ? nil : (start_date + 1.year + 6.months)

  profile.experiences.create!(
    company: experience_companies[index],
    position: experience_positions[index],
    start_date: start_date,
    end_date: end_date,
    description: Faker::Lorem.paragraph(sentence_count: 4)
  )
end

10.times do |index|
  profile.projects.create!(
    title: Faker::App.unique.name,
    slug: Faker::Internet.unique.slug,
    short_description: Faker::Lorem.sentence(word_count: 10),
    description: Faker::Lorem.paragraph(sentence_count: 5),
    tech_stack: %w[Ruby Rails PostgreSQL Redis Docker Turbo].sample(3).join(', '),
    repo_url: Faker::Internet.url(host: 'github.com'),
    live_url: Faker::Internet.url,
    featured: index < 3,
    published: true,
    position: index + 1
  )
end

Rails.logger.debug 'Done.'
