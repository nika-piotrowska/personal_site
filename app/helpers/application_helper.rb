# frozen_string_literal: true

module ApplicationHelper
  def experience_period(experience)
    from = I18n.l(experience.start_date, format: '%b %Y')
    to = experience.end_date.present? ? I18n.l(experience.end_date, format: '%b %Y') : 'Present'

    "#{from} – #{to}"
  end
end
