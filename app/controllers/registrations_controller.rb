class RegistrationsController < Devise::RegistrationsController
  layout 'application'

  def new_dj
    @role = :agent
    new
  end
end
