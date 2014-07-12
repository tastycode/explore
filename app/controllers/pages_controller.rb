class PagesController < ApplicationController
  def home
    if current_user
      @matches = Action.find_matches_for(current_user)
    end
  end
end
