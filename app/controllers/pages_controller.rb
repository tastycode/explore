class PagesController < ApplicationController
  def home
    if current_user
      @matches = User.all#current_user.find_matches
    end
  end
end
