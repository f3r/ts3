class AlertsController < ApplicationController
  layout 'plain'
  before_filter :login_required, :except => [:show_search_code]

  def index
    @alerts = Heypal::Alert.list(current_token)
  end

  def show_search_code
    @search_params = Heypal::Alert.get_search_params(params[:search_code])
    if !@search_params['query'].blank?
      redirect_to search_path(@search_params['query'])
    else
      flash[:error] = t(:error_invalid_or_expired_search)
      redirect_to root_path
    end
  end
  
  def show
    @alert = Heypal::Alert.show(params[:id], current_token)
    redirect_to search_path(@alert['alert']['query'])
  end
  
  def edit
    @alert = Heypal::Alert.show(params[:id], current_token)
    render :layout => false
  end

  def create
    alert_params = params.merge({:access_token => current_token})
    @alert = Heypal::Alert.create(alert_params)

    if @alert[0] == true
      flash[:success] = t(:message_alert_created)
      redirect_to alerts_path
    else
      puts @alert[1].inspect
      flash[:error] = t(:error_alert)
      redirect_to alerts_path
    end

  end

  def update
    @alert = Heypal::Alert.update(params[:id], current_token, params)
    if @alert[0] == true
      flash[:success] = t(:message_alert_unpaused)
    elsif @alert[0] == false && @alert[1]['query'].include?(119)
      flash[:error] = t(:error_alert_check_dates)
    else
      flash[:error] = t(:error_alert)
    end
    redirect_to alerts_path
  end

  def destroy
    @alert = Heypal::Alert.delete(params[:id], current_token)
    if @alert['stat'] == 'ok'
      flash[:success] = t(:message_alert_deleted)
    else
      flash[:error] = t(:error_alert)
    end
    redirect_to alerts_path
  end

  def pause
    @alert = Heypal::Alert.update(params[:alert_id], current_token, {:active => false})
    if @alert[0] == true
      flash[:success] = t(:message_alert_paused)
    else
      flash[:error] = t(:error_alert)
    end
    redirect_to alerts_path
  end

  def unpause
    @alert = Heypal::Alert.update(params[:alert_id], current_token, {:active => true})
    if @alert[0] == true
      flash[:success] = t(:message_alert_unpaused)
    elsif @alert[0] == false && @alert[1]['query'].include?(119)
      flash[:error] = t(:error_alert_check_dates)
    else
      flash[:error] = t(:error_alert)
    end
    redirect_to alerts_path
  end

end