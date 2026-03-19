# frozen_string_literal: true

FactoryBot.define do
  factory :experience do
    association :profile
    position { Faker::Job.title }
    company { Faker::Company.name }
    start_date { Date.new(2023, 1, 1) }
    end_date { nil }
    description { Faker::Lorem.paragraph(sentence_count: 2) }
  end
end
