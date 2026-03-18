# frozen_string_literal: true

class ContactsController < ApplicationController
  def new; end

  def create
    # później dodasz logikę formularza
    redirect_to contact_path, notice: 'Message sent'
  end
end
