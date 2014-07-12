class PagesController < ApplicationController
  def home
    if current_user
      @matches = current_user.find_matches
    end
  end
end
