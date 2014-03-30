#==============================================================================
# 
# ▼ Yanfly Engine Ace - Lunatic States v1.02
# -- Last Updated: 2012.01.30
# -- Level: Lunatic
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-LunaticStates"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.30 - Compatibility Update: Ace Battle Engine
# 2011.12.19 - Fixed Death State stacking error.
# 2011.12.15 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Lunatic mode effects have always been a core part of Yanfly Engine scripts.
# They exist to provide more effects for those who want more power and control
# for their items, skills, status effects, etc., but the users must be able to
# add them in themselves.
# 
# This script provides the base setup for state lunatic effects. These effects
# will occur under certain conditions, which can include when a state is
# applied, erased, leaves naturally, before taking damage, after taking damage,
# at the start of a turn, while an action finishes, and at the end of a turn.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # ● Welcome to Lunatic Mode
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Lunatic States allow allow states to trigger various scripted functions
  # throughout certain set periods of times or when certain conditions
  # trigger. These effects can occur when a state is applied, when a state is
  # erased, when a state leaves naturally, before damage is taken, after
  # damage is taken, at the beginning of a turn, while the turn is occuring,
  # and at the closing of a turn. These effects are separated by these eight
  # different notetags.
  # 
  #     <apply effect: string>     - Occurs when state is applied.
  #     <erase effect: string>     - Occurs when state is removed.
  #     <leave effect: string>     - Occurs when state timer hits 0.
  #     <react effect: string>     - Occurs before taking damage.
  #     <shock effect: string>     - Occurs after taking damage.
  #     <begin effect: string>     - Occurs at the start of each turn.
  #     <while effect: string>     - Occurs after performing an action.
  #     <close effect: string>     - Occurs at the end of a turn.
  # 
  # If multiple tags of the same type are used in the same skill/item's
  # notebox, then the effects will occur in that order. Replace "string" in
  # the tags with the appropriate flag for the method below to search for.
  # Note that unlike the previous versions, these are all upcase.
  # 
  # Should you choose to use multiple lunatic effects for a single state, you
  # may use these notetags in place of the ones shown above.
  # 
  #     <apply effect>      <erase effect>      <leave effect>
  #      string              string              string
  #      string              string              string
  #     </apply effect>     </erase effect>     </leave effect>
  # 
  #                <react effect>      <shock effect>
  #                 string              string
  #                 string              string
  #                </react effect>     </shock effect>
  # 
  #     <begin effect>      <while effect>      <close effect>
  #      string              string              string
  #      string              string              string
  #     </begin effect>     </while effect>     </close effect>
  # 
  # All of the string information in between those two notetags will be
  # stored the same way as the notetags shown before those. There is no
  # difference between using either.
  #--------------------------------------------------------------------------
  def lunatic_state_effect(type, state, user)
    return unless SceneManager.scene_is?(Scene_Battle)
    return if state.nil?
    case type
    when :apply; effects = state.apply_effects
    when :erase; effects = state.erase_effects
    when :leave; effects = state.leave_effects
    when :react; effects = state.react_effects
    when :shock; effects = state.shock_effects
    when :begin; effects = state.begin_effects
    when :while; effects = state.while_effects
    when :close; effects = state.close_effects
    else; return
    end
    log_window = SceneManager.scene.log_window
    state_origin = state_origin?(state.id)
    for effect in effects
      case effect.upcase
      #----------------------------------------------------------------------
      # Common Effect: Apply
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # This is a common effect that runs whenever a state is refreshly added
      # to the battler's state pool. There is no need to modify this unless
      # you see fit.
      #----------------------------------------------------------------------
      when /COMMON APPLY/i
        # No common apply effects added.
        
      #----------------------------------------------------------------------
      # Common Effect: Erase
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # This is a common effect that runs whenever a state is removed from
      # the battler's state pool. There is no need to modify this unless you
      # see fit.
      #----------------------------------------------------------------------
      when /COMMON ERASE/i
        # No common erase effects added.
        
      #----------------------------------------------------------------------
      # Common Effect: Leave
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # This is a common effect that runs whenever a state's turns reach 0
      # and leaves the battler's state pool. There is no need to modify this
      # unless you see fit.
      #----------------------------------------------------------------------
      when /COMMON LEAVE/i
        # No common leave effects added.
        
      #----------------------------------------------------------------------
      # Common Effect: React
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # This is a common effect that runs right before the battler is about
      # to take damage. There is no need to modify this unless you see fit.
      #----------------------------------------------------------------------
      when /COMMON REACT/i
        # No common react effects added.
        
      #----------------------------------------------------------------------
      # Common Effect: Shock
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # This is a common effect that runs right after the battler has taken
      # damage. There is no need to modify this unless you see fit.
      #----------------------------------------------------------------------
      when /COMMON SHOCK/i
        # No common shock effects added.
        
      #----------------------------------------------------------------------
      # Common Effect: Begin
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # This is a common effect that runs at the start of the party's turn. 
      # There is no need to modify this unless you see fit.
      #----------------------------------------------------------------------
      when /COMMON BEGIN/i
        # No common begin effects added.
        
      #----------------------------------------------------------------------
      # Common Effect: While
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # This is a common effect that runs at the end of the battler's turn. 
      # There is no need to modify this unless you see fit.
      #----------------------------------------------------------------------
      when /COMMON WHILE/i
        # No common while effects added.
        
      #----------------------------------------------------------------------
      # Common Effect: Close
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # This is a common effect that runs at the end of the party's turn. 
      # There is no need to modify this unless you see fit.
      #----------------------------------------------------------------------
      when /COMMON CLOSE/i
        # No common close effects added.
        
      #----------------------------------------------------------------------
      # Stop editting past this point.
      #----------------------------------------------------------------------
      else
        lunatic_state_extension(effect, state, user, state_origin, log_window)
      end
    end # for effect in effects
  end # lunatic_object_effect
  
end # Game_BattlerBase

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module STATE
    
    APPLY_EFFECT_STR = /<(?:APPLY_EFFECT|apply effect):[ ](.*)>/i
    APPLY_EFFECT_ON  = /<(?:APPLY_EFFECT|apply effect)>/i
    APPLY_EFFECT_OFF = /<\/(?:APPLY_EFFECT|apply effect)>/i
    
    ERASE_EFFECT_STR = /<(?:ERASE_EFFECT|erase effect):[ ](.*)>/i
    ERASE_EFFECT_ON  = /<(?:ERASE_EFFECT|erase effect)>/i
    ERASE_EFFECT_OFF = /<\/(?:ERASE_EFFECT|erase effect)>/i
    
    LEAVE_EFFECT_STR = /<(?:LEAVE_EFFECT|leave effect):[ ](.*)>/i
    LEAVE_EFFECT_ON  = /<(?:LEAVE_EFFECT|leave effect)>/i
    LEAVE_EFFECT_OFF = /<\/(?:LEAVE_EFFECT|leave effect)>/i
    
    REACT_EFFECT_STR = /<(?:REACT_EFFECT|react effect):[ ](.*)>/i
    REACT_EFFECT_ON  = /<(?:REACT_EFFECT|react effect)>/i
    REACT_EFFECT_OFF = /<\/(?:REACT_EFFECT|react effect)>/i
    
    SHOCK_EFFECT_STR = /<(?:SHOCK_EFFECT|shock effect):[ ](.*)>/i
    SHOCK_EFFECT_ON  = /<(?:SHOCK_EFFECT|shock effect)>/i
    SHOCK_EFFECT_OFF = /<\/(?:SHOCK_EFFECT|shock effect)>/i
    
    BEGIN_EFFECT_STR = /<(?:BEGIN_EFFECT|begin effect):[ ](.*)>/i
    BEGIN_EFFECT_ON  = /<(?:BEGIN_EFFECT|begin effect)>/i
    BEGIN_EFFECT_OFF = /<\/(?:BEGIN_EFFECT|begin effect)>/i
    
    WHILE_EFFECT_STR = /<(?:WHILE_EFFECT|while effect):[ ](.*)>/i
    WHILE_EFFECT_ON  = /<(?:WHILE_EFFECT|while effect)>/i
    WHILE_EFFECT_OFF = /<\/(?:WHILE_EFFECT|while effect)>/i
    
    CLOSE_EFFECT_STR = /<(?:CLOSE_EFFECT|close effect):[ ](.*)>/i
    CLOSE_EFFECT_ON  = /<(?:CLOSE_EFFECT|close effect)>/i
    CLOSE_EFFECT_OFF = /<\/(?:CLOSE_EFFECT|close effect)>/i
    
  end # STATE
  end # REGEXP
end # YEA

#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_lsta load_database; end
  def self.load_database
    load_database_lsta
    load_notetags_lsta
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_lsta
  #--------------------------------------------------------------------------
  def self.load_notetags_lsta
    for state in $data_states
      next if state.nil?
      state.load_notetags_lsta
    end
  end
  
end # DataManager

#==============================================================================
# ■ RPG::State
#==============================================================================

class RPG::State < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :apply_effects
  attr_accessor :erase_effects
  attr_accessor :leave_effects
  attr_accessor :react_effects
  attr_accessor :shock_effects
  attr_accessor :begin_effects
  attr_accessor :while_effects
  attr_accessor :close_effects
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_lsta
  #--------------------------------------------------------------------------
  def load_notetags_lsta
    @apply_effects = ["COMMON APPLY"]
    @erase_effects = ["COMMON ERASE"]
    @leave_effects = ["COMMON LEAVE"]
    @react_effects = ["COMMON REACT"]
    @shock_effects = ["COMMON SHOCK"]
    @begin_effects = ["COMMON BEGIN"]
    @while_effects = ["COMMON WHILE"]
    @close_effects = ["COMMON CLOSE"]
    @apply_effects_on = false
    @erase_effects_on = false
    @leave_effects_on = false
    @react_effects_on = false
    @shock_effects_on = false
    @begin_effects_on = false
    @while_effects_on = false
    @close_effects_on = false
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::STATE::APPLY_EFFECT_STR
        @apply_effects.push($1.to_s)
      when YEA::REGEXP::STATE::ERASE_EFFECT_STR
        @erase_effects.push($1.to_s)
      when YEA::REGEXP::STATE::LEAVE_EFFECT_STR
        @leave_effects.push($1.to_s)
      when YEA::REGEXP::STATE::REACT_EFFECT_STR
        @react_effects.push($1.to_s)
      when YEA::REGEXP::STATE::SHOCK_EFFECT_STR
        @shock_effects.push($1.to_s)
      when YEA::REGEXP::STATE::BEGIN_EFFECT_STR
        @begin_effects.push($1.to_s)
      when YEA::REGEXP::STATE::WHILE_EFFECT_STR
        @while_effects.push($1.to_s)
      when YEA::REGEXP::STATE::CLOSE_EFFECT_STR
        @close_effects.push($1.to_s)
      #---
      when YEA::REGEXP::STATE::APPLY_EFFECT_ON
        @apply_effects_on = true
      when YEA::REGEXP::STATE::ERASE_EFFECT_ON
        @erase_effects_on = true
      when YEA::REGEXP::STATE::LEAVE_EFFECT_ON
        @leave_effects_on = true
      when YEA::REGEXP::STATE::REACT_EFFECT_ON
        @react_effects_on = true
      when YEA::REGEXP::STATE::SHOCK_EFFECT_ON
        @shock_effects_on = true
      when YEA::REGEXP::STATE::BEGIN_EFFECT_ON
        @begin_effects_on = true
      when YEA::REGEXP::STATE::WHILE_EFFECT_ON
        @while_effects_on = true
      when YEA::REGEXP::STATE::CLOSE_EFFECT_ON
        @close_effects_on = true
      #---
      when YEA::REGEXP::STATE::APPLY_EFFECT_OFF
        @apply_effects_on = false
      when YEA::REGEXP::STATE::ERASE_EFFECT_OFF
        @erase_effects_on = false
      when YEA::REGEXP::STATE::LEAVE_EFFECT_OFF
        @leave_effects_on = false
      when YEA::REGEXP::STATE::REACT_EFFECT_OFF
        @react_effects_on = false
      when YEA::REGEXP::STATE::SHOCK_EFFECT_OFF
        @shock_effects_on = false
      when YEA::REGEXP::STATE::BEGIN_EFFECT_OFF
        @begin_effects_on = false
      when YEA::REGEXP::STATE::WHILE_EFFECT_OFF
        @while_effects_on = false
      when YEA::REGEXP::STATE::CLOSE_EFFECT_OFF
        @close_effects_on = false
      #---
      else
        @apply_effects.push(line.to_s) if @after_effects_on
        @erase_effects.push(line.to_s) if @erase_effects_on
        @leave_effects.push(line.to_s) if @leave_effects_on
        @react_effects.push(line.to_s) if @react_effects_on
        @shock_effects.push(line.to_s) if @shock_effects_on
        @begin_effects.push(line.to_s) if @begin_effects_on
        @while_effects.push(line.to_s) if @while_effects_on
        @close_effects.push(line.to_s) if @close_effects_on
      end
    } # self.note.split
    #---
  end
  
end # RPG::State

#==============================================================================
# ■ Game_BattlerBase
#==============================================================================

class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias method: clear_states
  #--------------------------------------------------------------------------
  alias game_battlerbase_clear_states_lsta clear_states
  def clear_states
    game_battlerbase_clear_states_lsta
    clear_state_origins
  end
  
  #--------------------------------------------------------------------------
  # alias method: erase_state
  #--------------------------------------------------------------------------
  alias game_battlerbase_erase_state_lsta erase_state
  def erase_state(state_id)
    lunatic_state_effect(:erase, $data_states[state_id], self)
    change_state_origin(:erase)
    game_battlerbase_erase_state_lsta(state_id)
  end
  
  #--------------------------------------------------------------------------
  # new method: clear_state_origins
  #--------------------------------------------------------------------------
  def clear_state_origins
    @state_origins = {}
  end
  
  #--------------------------------------------------------------------------
  # new method: change_state_origin
  #--------------------------------------------------------------------------
  def change_state_origin(state_id, type = :apply)
    return unless $game_party.in_battle
    return if state_id == death_state_id
    if :apply && SceneManager.scene_is?(Scene_Battle)
      subject = SceneManager.scene.subject
      clear_state_origins if @state_origins.nil?
      if subject.nil?
        @state_origins[state_id] = [:actor, self.id] if self.actor?
        @state_origins[state_id] = [:enemy, self.index] unless self.actor?
      elsif subject.actor?
        @state_origins[state_id] = [:actor, subject.id]
      else
        @state_origins[state_id] = [:enemy, subject.index]
      end
    else # :erase
      @state_origins[state_id] = nil
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: state_origin?
  #--------------------------------------------------------------------------
  def state_origin?(state_id)
    return self unless $game_party.in_battle
    return self if @state_origins[state_id].nil?
    team = @state_origins[state_id][0]
    subject = @state_origins[state_id][1]
    if team == :actor
      return $game_actors[subject]
    else # :enemy
      return $game_troop.members[subject]
    end
  end
  
end # Game_BattlerBase

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias method: on_battle_start
  #--------------------------------------------------------------------------
  alias game_battler_on_battle_start_lsta on_battle_start
  def on_battle_start
    game_battler_on_battle_start_lsta
    clear_state_origins
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_battle_end
  #--------------------------------------------------------------------------
  alias game_battler_on_battle_end_lsta on_battle_end
  def on_battle_end
    game_battler_on_battle_end_lsta
    clear_state_origins
  end
  
  #--------------------------------------------------------------------------
  # alias method: add_new_state
  #--------------------------------------------------------------------------
  alias game_battler_add_new_state_lsta add_new_state
  def add_new_state(state_id)
    change_state_origin(state_id, :apply)
    lunatic_state_effect(:apply, $data_states[state_id], self)
    game_battler_add_new_state_lsta(state_id)
  end
  
  #--------------------------------------------------------------------------
  # alias method: remove_states_auto
  #--------------------------------------------------------------------------
  alias game_battler_remove_states_auto_lsta remove_states_auto
  def remove_states_auto(timing)
    states.each do |state|
      if @state_turns[state.id] == 0 && state.auto_removal_timing == timing
        lunatic_state_effect(:leave, state, self)
      end
    end
    game_battler_remove_states_auto_lsta(timing)
  end
  
  #--------------------------------------------------------------------------
  # alias method: execute_damage
  #--------------------------------------------------------------------------
  alias game_battler_execute_damage_lsta execute_damage
  def execute_damage(user)
    for state in states; run_lunatic_states(:react); end
    game_battler_execute_damage_lsta(user)
    @result.restore_damage if $imported["YEA-BattleEngine"]
    for state in states; run_lunatic_states(:shock); end
    return unless $imported["YEA-BattleEngine"]
    @result.store_damage
    @result.clear_damage_values
  end
  
  #--------------------------------------------------------------------------
  # new method: run_lunatic_states
  #--------------------------------------------------------------------------
  def run_lunatic_states(type)
    for state in states; lunatic_state_effect(type, state, self); end
  end
  
end # Game_Battler

#==============================================================================
# ■ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :log_window
  attr_accessor :subject
  
  #--------------------------------------------------------------------------
  # alias method: turn_start
  #--------------------------------------------------------------------------
  alias scene_battle_turn_start_lsta turn_start
  def turn_start
    scene_battle_turn_start_lsta
    for member in all_battle_members; member.run_lunatic_states(:begin); end
  end
  
  #--------------------------------------------------------------------------
  # alias method: turn_end
  #--------------------------------------------------------------------------
  alias scene_battle_turn_end_lsta turn_end
  def turn_end
    for member in all_battle_members; member.run_lunatic_states(:close); end
    scene_battle_turn_end_lsta
  end
  
  #--------------------------------------------------------------------------
  # alias method: execute_action
  #--------------------------------------------------------------------------
  alias scene_battle_execute_action_lsta execute_action
  def execute_action
    scene_battle_execute_action_lsta
    @subject.run_lunatic_states(:while)
  end
  
end # Scene_Battle

#==============================================================================
# ■ Game_BattlerBase
#==============================================================================

class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # new method: lunatic_state_extension
  #--------------------------------------------------------------------------
  def lunatic_state_extension(effect, state, user, state_origin, log_window)
    # Reserved for future Add-ons.
  end
  
end # Game_BattlerBase

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================