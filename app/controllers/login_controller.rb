class LoginController < ApplicationController

  def store_and_redirect
    binding.pry
    cookies[:ability] = params[:ability]
    cookies[:wants] = params[:wants]
    redirect_to user_omniauth_authorize_path(:facebook)
  end

  def login_params
    params.permit(:ability, :wants)
  end
end
