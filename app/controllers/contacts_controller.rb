# frozen_string_literal: true

class ContactsController < ApplicationController
  def show
    @profile = Profile.order(created_at: :desc).first
  end
end
