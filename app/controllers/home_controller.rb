class HomeController < ApplicationController  
  def suggest
    subject    = 'New Place Suggestion!'
    sent_on    =  Time.now
    # mail(:to => "fer@squarestays.com", :subject => subject, :date => sent_on) do |format|
    #   format.text
    #   format.html
    # end
    flash[:notice] = "Thank you for your message. SquareStays is expanding and we will let you know when #{params['city']} is available!"
    redirect_to root_path
  end
end
