module Admin::DashboardsHelper
  def histogram_view
    if params[:_type].present? && params[:_type] == "false"
      cummulative = true
    else
      cummulative = false
    end
    cummulative
  end
  
  def histogram_switch_text
    histogram_view == true ? "Absolute" : "Cumulative"
  end
end