class HomeController < ApplicationController  
  def suggest
    subject    = 'New Place Suggestion!'
    sent_on    =  Time.now
    puts "################################################"
    puts "Email on it's way bro!!"
    puts "FROM: #{params['email']}"
    puts "################################################"
    # mail(:to => "fer@squarestays.com", :subject => subject, :date => sent_on) do |format|
    #   format.text
    #   format.html
    # end
    flash[:notice] = "Message sent correctly!"
    redirect_to root_path
  end
end
