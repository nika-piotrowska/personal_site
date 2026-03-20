# frozen_string_literal: true

module ApplicationHelper
  def experience_period(experience)
    from = I18n.l(experience.start_date, format: '%b %Y')
    to = experience.end_date.present? ? I18n.l(experience.end_date, format: '%b %Y') : t('common.present')

    "#{from} – #{to}"
  end

  def external_link_to(url, label = nil, **options)
    return if url.blank?

    parsed_url = URI.parse(url)
    return unless parsed_url.is_a?(URI::HTTP) || parsed_url.is_a?(URI::HTTPS)

    link_to(label || parsed_url.to_s, parsed_url.to_s, { target: '_blank', rel: 'noopener' }.merge(options))
  rescue URI::InvalidURIError
    nil
  end
end
