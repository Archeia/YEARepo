$imported = {} if $imported.nil?
$imported["Yami-DeathCause"] = true

# Usage: Use those script call to get cause of death
#
# get_death_cause(actorID, variableID)
# this script call will get enemy ID that killed actor into a variable, if
# variable is set to -1, it means that actor was killed by a state
#
# get_item_cause(actorID, variableID)
# this script call will get skill ID or state ID that killed actor into a variable,
# this will be skill ID if death cause > 0, will be state ID if death cause == -1
# this script only get state if actor dead because of a degen state (like poison)

class Game_Actor < Game_Battler
  
  attr_reader :death_cause
  attr_reader :item_cause
  
  alias yami_death_cause_setup setup
  def setup(actor_id)
    yami_death_cause_setup(actor_id)
    setup_death_cause
  end
  
  def setup_death_cause
    @death_cause = 0
    @item_cause  = 0
  end
  
  alias yami_death_cause_item_apply item_apply
  def item_apply(user, item)
    yami_death_cause_item_apply(user, item)
    return unless dead?
    return unless user
    return unless user.enemy?
    @death_cause = user.enemy.id
    @item_cause  = item.id
  end
  
  alias yami_death_cause_regenerate_all regenerate_all
  def regenerate_all
    temp_hp = @hp
    state = get_degen_states[0]
    yami_death_cause_regenerate_all
    return if not dead? || temp_hp <= 0
    return unless state
    @death_cause = -1
    @item_cause  = state
  end
  
  def get_degen_states
    result = []
    states.each { |state|
      next unless state.features.any? { |f| 
        f.code == 22 && f.data_id == 7 && f.value < 0
      }
      result.push(state)
    }
    result
  end
  
end

class Game_Interpreter
  
  def get_death_cause(actor_id, variable_id)
    $game_variables[variable_id] = $game_actors[actor_id].death_cause
  end
  
  def get_item_cause(actor_id, variable_id)
    $game_variables[variable_id] = $game_actors[actor_id].item_cause
  end
  
end