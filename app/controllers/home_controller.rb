class HomeController < ApplicationController
  #skip_before_filter :nombre, :only => :alive

  def robot
    render :layout => false, :content_type => "text/plain"
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

  def alive
    head :ok
  end
end