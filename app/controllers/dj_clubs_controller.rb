class DjClubsController < ApplicationController
  def list
    @clubs = DjClub.all
  end
end
