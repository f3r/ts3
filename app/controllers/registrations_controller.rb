class RegistrationsController < Devise::RegistrationsController
  layout 'single'

  def new_dj
    @role = :new
    new
  end
end
