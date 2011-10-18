class SessionsController < ApplicationController
  
  def create
    @heypal_session = Heypal::Session.create(params)

    if @heypal_session.valid?

    end
    
  end

end
