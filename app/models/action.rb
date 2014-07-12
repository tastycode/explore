class Action < ActiveRecord::Base
  belongs_to :user
  scope 'abilities', -> { where(action_type: 'ability') }
  scope 'wants', -> { where(action_type: 'want') }
  def self.find_matches_for(user)
    ability_candidates = user.actions.abilities.map do |action|
      Action.wants.where("user_id != #{user.id}").where("title like '%#{action.title}%'").to_a
    end.flatten
    want_candidates = user.actions.wants.map do |action|
      Action.abilities.where("user_id != #{user.id}").where("title like '%#{action.title}%'").to_a
    end.flatten
    ability_candidates | want_candidates
  end
end
