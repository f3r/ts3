class HomeController < ApplicationController
  def suggest
    Heypal::User.feedback(
      :access_token => current_token,
      :type => :city_suggestion,
      :message => {
        :city => params[:city],
        :email => params[:email]
      }
    )
    flash[:notice] = t("pages.suggest_thank_you_message", :city => params['city'])
    redirect_to root_path
  end

  def robot
    robots = File.read(Rails.root + "config/robots.#{Rails.env}.txt")
    render :text => robots, :layout => false, :content_type => "text/plain"
  end

  def set_ref
    respond_to do |format|
      session[:user_return_to] = params[:ref] if params[:ref] && !params[:ref].blank?
      format.json { render :inline => "ok" }
    end
  end

  def staticpage
    #get the content from back-end
    @staticpage = Cmspage.find_by_url(params[:pages])
    raise ActiveRecord::RecordNotFound unless @staticpage
  end

  def photo_faq
    render :template => 'home/photo_faq'
  end
end