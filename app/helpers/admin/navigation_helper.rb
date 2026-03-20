# frozen_string_literal: true

module Admin
  module NavigationHelper
    def admin_nav_link_class(path, controller_name: nil)
      classes = ['admin-nav__link']

      active = if controller_name.present?
                 params[:controller] == controller_name
               else
                 current_page?(path)
               end

      classes << 'admin-nav__link--active' if active
      classes.join(' ')
    end
  end
end
