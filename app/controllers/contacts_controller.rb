# frozen_string_literal: true

class ContactsController < ApplicationController
  def show
    @profile = Profile.first
  end
end
