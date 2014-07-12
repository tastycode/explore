class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable, :omniauthable

  has_many :identities
  has_many :actions



  def find_matches
    ability_candidates = actions.abilities.map do |action|
      Action.wants.where("id != #{id}").where("title like '%#{action.title}%'").to_a
    end.flatten
    want_candidates = actions.wants.map do |action|
      Action.abilities.where("id != #{id}").where("title like '%#{action.title}%'").to_a
    end.flatten
    matches = ability_candidates | want_candidates
    matches.map(&:user).uniq
  end

  def last_ability
    actions.where(action_type: 'ability').last
  end

  def fb_avatar_url
    "http://graph.facebook.com/#{fb.uid}/picture?type=square"
  end

  def last_want
    actions.where(action_type: 'want').last
  end

  def fb
    identities.where(provider: "facebook").first
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
          name: auth.extra.raw_info.name,
          #username: auth.info.nickname || auth.uid,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

end
