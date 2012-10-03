module Admin::DashboardsHelper
  def histogram_view
    params[:_type].present? && params[:_type] == "false"
  end

  def histogram_switch_text
    histogram_view ? "Absolute" : "Cumulative"
  end
end