class AvailabilitiesController < ApplicationController
  before_filter :login_required

  def create
    param = {}
    %w(availability_type date_start date_end price_per_night).each do |p|
      param[p.to_sym] = params[p]
    end
    param[:access_token] = current_token
    param[:place_id] = params[:place_id]

    availability = Heypal::Availability.new(param)

    if availability.save
      place = Heypal::Place.find(availability['place_id'].to_s)

      render :json => {:stat => true, :data => render_to_string(:_list, :locals => {:a => availability, :place => place}, :layout => false)}
    else
      render :json => {:stat => false, :data => 'Something went wrong. Please chech your availabilities again.'}
    end
  end

  def update
    param = {}
    %w(availability_type date_start date_end price_per_night).each do |p|
      param[p.to_sym] = params[p]
    end
    param[:access_token] = current_token
    param[:place_id] = params[:place_id]
    param[:id] = params[:id]

    if availability = Heypal::Availability.update(param)
      place = Heypal::Place.find(availability['place_id'].to_s)

      render :json => {:stat => true, :data => render_to_string(:_list, :locals => {:a => availability, :place => place}, :layout => false)}
    else
      render :json => {:stat => false, :data => 'Something went wrong. Please check your availabilities again.'}
    end
  end

  def destroy
    param = {}
    param[:access_token] = current_token
    param[:place_id] = params[:place_id]

    if Heypal::Availability.delete(params[:id], param)
      render :json => {:stat => true}
    else
      render :json => {:stat => false, :data => 'Something went wrong. Please check your availabilities again.'}
    end
  end
end
