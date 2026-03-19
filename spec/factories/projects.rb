# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    association :profile
    sequence(:title) { |n| "Project #{n}" }
    sequence(:slug) { |n| "project-#{n}" }
    short_description { Faker::Lorem.sentence(word_count: 6) }
    description { Faker::Lorem.paragraph(sentence_count: 3) }
    tech_stack { %w[Ruby Rails PostgreSQL Turbo].sample(3).join(', ') }
    repo_url { Faker::Internet.url }
    live_url { Faker::Internet.url }
    featured { false }
    published { true }

    trait :featured do
      featured { true }
    end

    trait :unpublished do
      published { false }
    end
  end
end
