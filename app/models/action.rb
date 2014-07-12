class Action < ActiveRecord::Base
  belongs_to :user
  def self.find_matches_for(user)
    ability_candidates = user.actions.where(action_type: 'ability').map do |action|
      Action.where(action_type: 'want').where("user_id != #{user.id}").where("title like '%#{action.title}%'").to_a
    end.flatten
    want_candidates = user.actions.where(action_type: 'want').map do |action|
      Action.where(action_type: 'ability').where("user_id != #{user.id}").where("title like '%#{action.title}%'").to_a
    end.flatten
    ability_candidates | want_candidates
  end
end
