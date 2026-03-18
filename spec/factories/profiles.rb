# frozen_string_literal: true

FactoryBot.define do
  factory :profile do
    association :user
    headline { Faker::Job.title }
    bio { Faker::Lorem.paragraph(sentence_count: 2) }
    sequence(:email) { |n| "profile#{n}@example.com" }
    location { Faker::Address.country }
    github_url { "https://github.com/#{Faker::Internet.username(specifier: 8..12)}" }
    linkedin_url { "https://linkedin.com/in/#{Faker::Internet.username(specifier: 8..12)}" }
  end
end
