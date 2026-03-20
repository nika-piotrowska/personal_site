# frozen_string_literal: true

module Admin
  class BaseController < ApplicationController
    include Admin::NavigationHelper

    before_action :authenticate_user!
    layout 'admin'
  end
end
