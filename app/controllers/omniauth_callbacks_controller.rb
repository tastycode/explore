class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        @user = User.find_for_oauth(env["omniauth.auth"], current_user)

        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication
        else
          session["devise.#{provider}_data"] = env["omniauth.auth"]
          redirect_to new_user_registration_url
        end
      end
    }
  end

  [:twitter, :facebook, :linked_in].each do |provider|
    provides_callback_for provider
  end

  def after_sign_in_path_for(resource)
    if has_initial_profile?
      ability_exists = current_user.actions.abilities.find_by(title: cookies[:ability]).present?
      Action.create(
       user_id: current_user.id,
       action_type: 'ability',
       title: cookies[:ability]
      ) unless ability_exists
      want_exists = current_user.actions.wants.find_by(title: cookies[:wants]).present?
      Action.create(
       user_id: current_user.id,
       action_type: 'want',
       title: cookies[:wants]
      ) unless want_exists
    end
    super resource
  end

  def has_initial_profile?
    cookies[:ability].presence && cookies[:wants].presence
  end
end
