# frozen_string_literal: true

class ProjectsController < ApplicationController
  def index
    @projects = []
  end

  def show
    @project = {}
  end
end
