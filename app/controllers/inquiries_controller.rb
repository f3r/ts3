class InquiriesController < ApplicationController
  def create
    # :name             => params[:name],
    # :email            => params[:email],
    # :date_start       => params[:date_start],
    # :length_stay      => params[:length_stay],
    # :length_stay_type => params[:length_stay_type],
    # :message          => params[:questions]

    @place = Place.with_permissions_to(:read).find(params[:place_id])

    user = current_user

    unless user
      user = User.auto_signup(params[:name], params[:email])
      @just_created = true
    end

    unless user
      #return_message(200, :fail, :err => {:user => [100] })
      return
    end

    if Inquiry.create_and_notify(@place, user, params)
      if @just_created
        #return_message(200, :ok, {:authentication_token => user.authentication_token, :role => user.role})
      else
        #return_message(200, :ok)
      end
    else
      #return_message(200, :fail, :err => {:place => [] })
    end
  end
end
