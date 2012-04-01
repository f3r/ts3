class AlertsController < ApplicationController
  layout 'plain'
  before_filter :login_required

  def index
    @alerts = Heypal::Alert.list(current_token)
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
      flash[:error] = t(:error)
      redirect_to alerts_path
    end

  end

  def update
    @alert = Heypal::Alert.update(params[:id], current_token, params)
    if @alert[0] == true
      flash[:success] = t(:message_alert_updated)
    else
      flash[:error] = t(:error)
    end
    redirect_to alerts_path
  end

  def destroy
    @alert = Heypal::Alert.delete(params[:id], current_token)
    if @alert['stat'] == 'ok'
      flash[:success] = t(:message_alert_deleted)
    else
      flash[:error] = t(:error)
    end
    redirect_to alerts_path
  end

  def pause
    @alert = Heypal::Alert.update(params[:alert_id], current_token, {:active => false})
    if @alert[0] == true
      flash[:success] = t(:message_alert_paused)
    else
      flash[:error] = t(:error)
    end
    redirect_to alerts_path
  end

  def unpause
    @alert = Heypal::Alert.update(params[:alert_id], current_token, {:active => true})
    if @alert[0] == true
      flash[:success] = t(:message_alert_unpaused)
    else
      flash[:error] = t(:error)
    end
    redirect_to alerts_path
  end

end