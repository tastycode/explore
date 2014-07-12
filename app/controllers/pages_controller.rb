class PagesController < ApplicationController
  def home
    if current_user
      @matches = current_user.actions#Action.find_matches_for(current_user)
    end
  end
end
