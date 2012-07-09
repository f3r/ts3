class AlertsController < ApplicationController
  layout 'plain'
  before_filter :login_required, :except => [:show_search_code]

  def index
    @alerts = current_user.alerts
  end
  
  def edit
    @alert = current_user.alerts.find(params[:id])
    render :layout => false
  end

  def create
    @alert = current_user.alerts.new(params[:alert])
    if @alert.save
      flash[:success] = t("alerts.message_alert_created")
      redirect_to alerts_path
    else
      puts @alert.inspect
      flash[:error] = t("alerts.error_alert")
      redirect_to alerts_path
    end
  end

  def update
    params[:alert][:search_attributes][:category_ids] = params[:alert][:search_attributes][:category_ids] || []
    params[:alert][:search_attributes][:amenity_ids] = params[:alert][:search_attributes][:amenity_ids] || []
    
    @alert = current_user.alerts.find(params[:id])    
    if @alert.update_attributes(params[:alert])
      flash[:success] = t("alerts.message_alert_updated")
    #elsif @alert[0] == false && @alert[1]['query'].include?(119)
    #  flash[:error] = t("alerts.error_alert_check_dates")
    else
      flash[:error] = t("alerts.error_alert")
    end
    redirect_to alerts_path
  end

  def destroy
    @alert = current_user.alerts.find(params[:id])
    if @alert.soft_delete
      flash[:success] = t("alerts.message_alert_deleted")
    else
      flash[:error] = t("alerts.error_alert")
    end
    redirect_to alerts_path
  end

  def pause
    @alert = current_user.alerts.find(params[:id])
    @alert.active = false
    if @alert.save
      flash[:success] = t("alerts.message_alert_paused")
    else
      flash[:error] = t("alerts.error_alert")
    end
    redirect_to alerts_path
  end

  def unpause
    @alert = current_user.alerts.find(params[:id])
    @alert.active = true
    if @alert.save
      flash[:success] = t("alerts.message_alert_unpaused")
#    elsif @alert[0] == false && @alert[1]['query'].include?(119)
#     flash[:error] = t("alerts.error_alert_check_dates")
    else
      flash[:error] = t("alerts.error_alert")
    end
    redirect_to alerts_path
  end

end