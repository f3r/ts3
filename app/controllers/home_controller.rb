class HomeController < ApplicationController
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