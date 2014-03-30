#==============================================================================
# 
# ▼ Yanfly Engine Ace - Field State Effects v1.00
# -- Last Updated: 2012.01.11
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-FieldStateEffects"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.11 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Field States are states that are applied to all actors and enemies without
# discrimination. Field states cannot be removed through usual means and can
# only be applied through certain skills and items. Multiple field states can
# be added at once whether side by side or overwriting any previous field
# states. Skills and items can also alter the turns of existing field states.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Skill Notetags - These notetags go in the skill notebox in the database.
# -----------------------------------------------------------------------------
# <add field state: x>
# <add field state: x, x>
# Causes the action to add state x to the field, making it apply to everyone
# and cannot be removed through normal state removal means. Insert multiples of
# this tag to have the action cause multiple field states.
# 
# <remove field state: x>
# <remove field state: x, x>
# Causes the action to remove state x from the field. This does not remove
# states that were inflicted normally. Insert multiples of this tag to remove
# multiple field states.
# 
# <remove all field states>
# Causes the action to remove all field states. This does not remove states
# that were inflicted normally.
# 
# <overwrite field state: x>
# <overwrite field state: x, x>
# Causes the action to remove all field states and then add field states x,
# making it apply to everyone and cannot be removed through normal state
# removal means. Insert multiples of this tag to have the action overwrite and
# add more field states.
# 
# <field state x turns: +y>
# <field state x turns: -y>
# Changes the remaining turns on field state x by y amount. If a field state
# is to reach 0 or less turns through this process, the field state is removed.
# This effect does not add turns to field states that weren't inflicted. Insert
# multiples of this tag to adjust multiple field states at once.
# 
# <all field state turns: +x>
# <all field state turns: -x>
# Changes the remaining turns on all field states by x amount. If a field state
# is to reach 0 or less turns through this process, the field state is removed.
# 
# -----------------------------------------------------------------------------
# Item Notetags - These notetags go in the items notebox in the database.
# -----------------------------------------------------------------------------
# <add field state: x>
# <add field state: x, x>
# Causes the action to add state x to the field, making it apply to everyone
# and cannot be removed through normal state removal means. Insert multiples of
# this tag to have the action cause multiple field states.
# 
# <remove field state: x>
# <remove field state: x, x>
# Causes the action to remove state x from the field. This does not remove
# states that were inflicted normally. Insert multiples of this tag to remove
# multiple field states.
# 
# <remove all field states>
# Causes the action to remove all field states. This does not remove states
# that were inflicted normally.
# 
# <overwrite field state: x>
# <overwrite field state: x, x>
# Causes the action to remove all field states and then add field states x,
# making it apply to everyone and cannot be removed through normal state
# removal means. Insert multiples of this tag to have the action overwrite and
# add more field states.
# 
# <field state x turns: +y>
# <field state x turns: -y>
# Changes the remaining turns on field state x by y amount. If a field state
# is to reach 0 or less turns through this process, the field state is removed.
# This effect does not add turns to field states that weren't inflicted. Insert
# multiples of this tag to adjust multiple field states at once.
# 
# <all field state turns: +x>
# <all field state turns: -x>
# Changes the remaining turns on all field states by x amount. If a field state
# is to reach 0 or less turns through this process, the field state is removed.
# 
# -----------------------------------------------------------------------------
# State Notetags - These notetags go in the states notebox in the database.
# -----------------------------------------------------------------------------
# <field back 1: string>
# <field back 2: string>
# If this state is being used as a field state and this state is the state with
# the highest priority, these notetags will determine the battlebacks used
# while the field state is in effect. If this notetag is not used, there will
# be no changes to the battleback.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module FIELD_STATES
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Visual Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This setting causes a wave effect to play whenever the battlebacks change
    # due to field state effects.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    WAVE_EFFECT = true  # Plays a wave effect when the battleback changes.
    
  end # FIELD_STATES
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module USABLEITEM
    
    ADD_FIELD_STATE = 
      /<(?:ADD_FIELD_STATE|add field state):[ ](\d+(?:\s*,\s*\d+)*)>/i
    REMOVE_FIELD_STATE = 
      /<(?:REMOVE_FIELD_STATE|remove field state):[ ](\d+(?:\s*,\s*\d+)*)>/i
    REMOVE_ALL_FIELD_STATES = 
      /<(?:REMOVE_ALL_FIELD_STATES|remove all field states)>/i
    OVERWRITE_FIELD_STATE = 
    /<(?:OVERWRITE_FIELD_STATE|OVERWRITE field state):[ ](\d+(?:\s*,\s*\d+)*)>/i
    CHANGE_FIELD_STATE_TURN = 
      /<(?:FIELD state)[ ](\d+)[ ](?:TURN|turns):[ ]([\+\-]\d+)>/i
    CHANGE_ALL_FIELD_STATE_TURN = 
      /<(?:ALL_FIELD_STATE_TURNS|all field state turns):[ ]([\+\-]\d+)>/i
    
  end # USABLEITEM
  module STATE
    
    FIELD_BATTLEBACK1 = /<(?:FIELD_BACK1|field back1|field back 1):[ ](.*)>/i
    FIELD_BATTLEBACK2 = /<(?:FIELD_BACK2|field back2|field back 2):[ ](.*)>/i
    
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
  class <<self; alias load_database_fse load_database; end
  def self.load_database
    load_database_fse
    load_notetags_fse
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_fse
  #--------------------------------------------------------------------------
  def self.load_notetags_fse
    groups = [$data_skills, $data_items, $data_states]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_fse
      end
    end
  end
  
end # DataManager

#==============================================================================
# ■ RPG::UsableItem
#==============================================================================

class RPG::UsableItem < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :add_field_state
  attr_accessor :remove_field_state
  attr_accessor :remove_all_field_states
  attr_accessor :change_field_state_turns
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_fse
  #--------------------------------------------------------------------------
  def load_notetags_fse
    @add_field_state = []
    @remove_field_state = []
    @remove_all_field_states = false
    @change_field_state_turns = {}
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::USABLEITEM::ADD_FIELD_STATE
        $1.scan(/\d+/).each { |num| 
        @add_field_state.push(num.to_i) if num.to_i > 0 }
      when YEA::REGEXP::USABLEITEM::REMOVE_FIELD_STATE
        $1.scan(/\d+/).each { |num| 
        @remove_field_state.push(num.to_i) if num.to_i > 0 }
      when YEA::REGEXP::USABLEITEM::REMOVE_ALL_FIELD_STATES
        @remove_all_field_states = true
      when YEA::REGEXP::USABLEITEM::OVERWRITE_FIELD_STATE
        @remove_all_field_states = true
        $1.scan(/\d+/).each { |num| 
        @add_field_state.push(num.to_i) if num.to_i > 0 }
      when YEA::REGEXP::USABLEITEM::CHANGE_FIELD_STATE_TURN
        @change_field_state_turns[$1.to_i] = $2.to_i
      when YEA::REGEXP::USABLEITEM::CHANGE_ALL_FIELD_STATE_TURN
        for i in 1...$data_states.size
          @change_field_state_turns[i] = $1.to_i
        end
      end
    } # self.note.split
    #---
  end
  
end # class RPG::UsableItem

#==============================================================================
# ■ RPG::State
#==============================================================================

class RPG::State < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :field_battlebacks
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_fse
  #--------------------------------------------------------------------------
  def load_notetags_fse
    @field_battlebacks = ["", ""]
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::STATE::FIELD_BATTLEBACK1
        @field_battlebacks[0] = $1.to_s
      when YEA::REGEXP::STATE::FIELD_BATTLEBACK2
        @field_battlebacks[1] = $1.to_s
      end
    } # self.note.split
    #---
  end
  
end # RPG::State

#==============================================================================
# ■ BattleManager
#==============================================================================

module BattleManager
  
  #--------------------------------------------------------------------------
  # alias method: init_members
  #--------------------------------------------------------------------------
  class <<self; alias battlemanager_init_members_fse init_members; end
  def self.init_members
    battlemanager_init_members_fse
    clear_field_states
  end
  
  #--------------------------------------------------------------------------
  # new method: field_states
  #--------------------------------------------------------------------------
  def self.field_states
    return @field_states.collect {|id| $data_states[id] }
  end
  
  #--------------------------------------------------------------------------
  # new method: field_state_turns
  #--------------------------------------------------------------------------
  def self.field_state_turns(state_id)
    return @field_state_turns[state_id]
  end
  
  #--------------------------------------------------------------------------
  # new method: field_state?
  #--------------------------------------------------------------------------
  def self.field_state?(state_id)
    return @field_states.include?(state_id)
  end
  
  #--------------------------------------------------------------------------
  # new method: sort_field_states
  #--------------------------------------------------------------------------
  def self.sort_field_states
    @field_states = @field_states.sort_by { |id|
      [-$data_states[id].priority, id] }
    set_field_battlebacks
    set_field_state_icons
  end
  
  #--------------------------------------------------------------------------
  # new method: clear_field_states
  #--------------------------------------------------------------------------
  def self.clear_field_states
    @field_states = []
    @field_state_turns = {}
    @field_state_battleback = ["", ""]
    @field_state_icons = []
  end
  
  #--------------------------------------------------------------------------
  # new method: add_field_state
  #--------------------------------------------------------------------------
  def self.add_field_state(state_id)
    return if $data_states[state_id].nil?
    return if @field_states.include?(state_id)
    @field_states.push(state_id)
    state = $data_states[state_id]
    variance = 1 + [state.max_turns - state.min_turns, 0].max
    @field_state_turns[state_id] = state.min_turns + rand(variance)
    sort_field_states
  end
  
  #--------------------------------------------------------------------------
  # new method: remove_field_state
  #--------------------------------------------------------------------------
  def self.remove_field_state(state_id)
    return if $data_states[state_id].nil?
    return unless @field_states.include?(state_id)
    @field_states.delete(state_id)
    @field_state_turns.delete(state_id)
    sort_field_states
  end
  
  #--------------------------------------------------------------------------
  # new method: change_field_state_turns
  #--------------------------------------------------------------------------
  def self.change_field_state_turns(state_id, value)
    return unless field_state?(state_id)
    state_id = state_id.id if state_id.is_a?(RPG::State)
    return if $data_states[state_id].auto_removal_timing <= 0
    @field_state_turns[state_id] = 0 if @field_state_turns[state_id].nil?
    @field_state_turns[state_id] = [value, 0].max
    remove_field_state(state_id) if @field_state_turns[state_id] <= 0
  end
  
  #--------------------------------------------------------------------------
  # alias method: turn_end
  #--------------------------------------------------------------------------
  class <<self; alias battlemanager_turn_end_fse turn_end; end
  def self.turn_end
    battlemanager_turn_end_fse
    update_field_states
    remove_field_states_auto
  end
  
  #--------------------------------------------------------------------------
  # new method: update_field_states
  #--------------------------------------------------------------------------
  def self.update_field_states
    for state_id in @field_states
      next unless @field_state_turns[state_id] > 0
      @field_state_turns[state_id] -= 1
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: remove_field_states_auto
  #--------------------------------------------------------------------------
  def self.remove_field_states_auto
    for state_id in @field_states
      next if $data_states[state_id].auto_removal_timing <= 0
      remove_field_state(state_id) if @field_state_turns[state_id] <= 0
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: field_battlebacks
  #--------------------------------------------------------------------------
  def self.field_battlebacks
    return @field_state_battleback
  end
  
  #--------------------------------------------------------------------------
  # new method: set_field_battlebacks
  #--------------------------------------------------------------------------
  def self.set_field_battlebacks
    @field_state_battleback = ["", ""]
    for state in field_states
      next if state.field_battlebacks == ["", ""]
      @field_state_battleback = state.field_battlebacks
      return
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: field_state_icons
  #--------------------------------------------------------------------------
  def self.field_state_icons
    return @field_state_icons
  end
  
  #--------------------------------------------------------------------------
  # new method: set_field_state_icons
  #--------------------------------------------------------------------------
  def self.set_field_state_icons
    icons = field_states.collect {|state| state.icon_index }
    icons.delete(0)
    @field_state_icons = icons
  end
  
end # BattleManager

#==============================================================================
# ■ Game_BattlerBase
#==============================================================================

class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :anti_field_states
  
  #--------------------------------------------------------------------------
  # alias method: states
  #--------------------------------------------------------------------------
  alias game_battlerbase_states_fse states
  def states
    result = game_battlerbase_states_fse
    result |= field_states unless @anti_field_states
    return result
  end
  
  #--------------------------------------------------------------------------
  # new method: field_states
  #--------------------------------------------------------------------------
  def field_states
    return [] unless SceneManager.scene_is?(Scene_Battle)
    return BattleManager.field_states
  end
  
  #--------------------------------------------------------------------------
  # alias method: state?
  #--------------------------------------------------------------------------
  alias game_battlerbase_state_fse state?
  def state?(state_id)
    return true if field_states.include?($data_states[state_id])
    return game_battlerbase_state_fse(state_id)
  end
  
end # Game_BattlerBase

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias method: item_apply
  #--------------------------------------------------------------------------
  alias game_battler_item_apply_fse item_apply
  def item_apply(user, item)
    game_battler_item_apply_fse(user, item)
    apply_field_state_effect(item)
  end
  
  #--------------------------------------------------------------------------
  # new method: apply_field_state_effect
  #--------------------------------------------------------------------------
  def apply_field_state_effect(item)
    return if item.nil?
    return unless $game_party.in_battle
    return unless SceneManager.scene_is?(Scene_Battle)
    return @result.success = true if item.add_field_state != []
    return @result.success = true if item.remove_field_state != []
    return @result.success = true if item.remove_all_field_states
    for key in item.change_field_state_turns
      return @result.success = true if BattleManager.field_state?(key[0])
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_restrict
  #--------------------------------------------------------------------------
  alias game_battler_on_restrict_fse on_restrict
  def on_restrict
    @anti_field_states = true
    game_battler_on_restrict_fse
    @anti_field_states = nil
  end
  
  #--------------------------------------------------------------------------
  # alias method: update_state_turns
  #--------------------------------------------------------------------------
  alias game_battler_update_state_turns_fse update_state_turns
  def update_state_turns
    @anti_field_states = true
    game_battler_update_state_turns_fse
    @anti_field_states = nil
  end
  
  #--------------------------------------------------------------------------
  # alias method: remove_battle_states
  #--------------------------------------------------------------------------
  alias game_battler_remove_battle_states_fse remove_battle_states
  def remove_battle_states
    @anti_field_states = true
    game_battler_remove_battle_states_fse
    @anti_field_states = nil
  end
  
  #--------------------------------------------------------------------------
  # alias method: remove_states_auto
  #--------------------------------------------------------------------------
  alias game_battler_remove_states_auto_fse remove_states_auto
  def remove_states_auto(timing)
    @anti_field_states = true
    game_battler_remove_states_auto_fse(timing)
    @anti_field_states = nil
  end
  
  #--------------------------------------------------------------------------
  # alias method: remove_states_by_damage
  #--------------------------------------------------------------------------
  alias game_battler_remove_states_by_damage_fse remove_states_by_damage
  def remove_states_by_damage
    @anti_field_states = true
    game_battler_remove_states_by_damage_fse
    @anti_field_states = nil
  end
  
end # Game_Battler

#==============================================================================
# ■ Spriteset_Battle
#==============================================================================

class Spriteset_Battle
  
  #--------------------------------------------------------------------------
  # alias method: create_viewports
  #--------------------------------------------------------------------------
  alias spriteset_battle_create_viewports_fse create_viewports
  def create_viewports
    spriteset_battle_create_viewports_fse
    create_field_state_effect
  end
  
  #--------------------------------------------------------------------------
  # new method: create_field_state_effect
  #--------------------------------------------------------------------------
  def create_field_state_effect
    @field_state_battleback = ["", ""]
    @field_state_effect_sprite1 = Sprite.new(@viewport1)
    @field_state_effect_sprite1.bitmap = Bitmap.new(640, 480)
    @field_state_effect_sprite1.opacity = 0
    @field_state_effect_sprite1.z = 3
    @field_state_effect_sprite2 = Sprite.new(@viewport1)
    @field_state_effect_sprite2.bitmap = Bitmap.new(640, 480)
    @field_state_effect_sprite2.opacity = 0
    @field_state_effect_sprite2.z = 4
  end
  
  #--------------------------------------------------------------------------
  # alias method: dispose
  #--------------------------------------------------------------------------
  alias spriteset_battle_dispose_fse dispose
  def dispose
    dispose_field_state_effect
    spriteset_battle_dispose_fse
  end
  
  #--------------------------------------------------------------------------
  # new method: dispose_field_state_effect
  #--------------------------------------------------------------------------
  def dispose_field_state_effect
    @field_state_effect_sprite1.bitmap.dispose
    @field_state_effect_sprite1.dispose
    @field_state_effect_sprite2.bitmap.dispose
    @field_state_effect_sprite2.dispose
  end
  
  #--------------------------------------------------------------------------
  # alias method: update
  #--------------------------------------------------------------------------
  alias spriteset_battle_update_fse update
  def update
    update_field_state_effect
    spriteset_battle_update_fse
  end
  
  #--------------------------------------------------------------------------
  # new method: update_field_state_effect
  #--------------------------------------------------------------------------
  def update_field_state_effect
    update_field_battleback_images
    update_field_battleback_opacity
    #---
    @field_state_effect_sprite1.update
    @field_state_effect_sprite2.update
  end
  
  #--------------------------------------------------------------------------
  # new method: update_field_battleback_images
  #--------------------------------------------------------------------------
  def update_field_battleback_images
    return if @field_state_battleback == BattleManager.field_battlebacks
    @field_state_battleback = BattleManager.field_battlebacks.clone
    change_field_battleback_images
  end
  
  #--------------------------------------------------------------------------
  # new method: change_field_battleback_images
  #--------------------------------------------------------------------------
  def change_field_battleback_images
    #---
    @field_state_effect_sprite1.bitmap.dispose
    @field_state_effect_sprite1.bitmap =  @back1_sprite.bitmap.clone
    @field_state_effect_sprite1.opacity = 255
    @field_state_effect_sprite1.wave_amp = 0
    center_sprite(@field_state_effect_sprite1)
    #---
    @field_state_effect_sprite2.bitmap.dispose
    @field_state_effect_sprite2.bitmap = @back2_sprite.bitmap.clone
    @field_state_effect_sprite2.opacity = 255
    @field_state_effect_sprite2.wave_amp = 0
    center_sprite(@field_state_effect_sprite2)
    #---
    if YEA::FIELD_STATES::WAVE_EFFECT
      @field_state_effect_sprite1.wave_amp = 16
      @field_state_effect_sprite2.wave_amp = 16
    end
    #---
    @back1_sprite.bitmap.dispose
    @back2_sprite.bitmap.dispose
    if BattleManager.field_battlebacks == ["", ""]
      bb1 = battleback1_bitmap
      bb2 = battleback2_bitmap
    else
      bb1 = Cache.battleback1(BattleManager.field_battlebacks[0])
      bb2 = Cache.battleback2(BattleManager.field_battlebacks[1])
    end
    @back1_sprite.bitmap = bb1
    @back2_sprite.bitmap = bb2
    center_sprite(@back1_sprite)
    center_sprite(@back2_sprite)
  end
  
  #--------------------------------------------------------------------------
  # new method: update_field_battleback_opacity
  #--------------------------------------------------------------------------
  def update_field_battleback_opacity
    return if @field_state_effect_sprite1.opacity <= 0
    @field_state_effect_sprite1.opacity -= 1
    @field_state_effect_sprite2.opacity -= 1
  end
  
end # Spriteset_Battle

#==============================================================================
# ■ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: use_item
  #--------------------------------------------------------------------------
  alias scene_battle_use_item_fse use_item
  def use_item
    item = @subject.current_action.item
    scene_battle_use_item_fse
    apply_field_state_effects(item)
  end
  
  #--------------------------------------------------------------------------
  # new method: apply_field_state_effects
  #--------------------------------------------------------------------------
  def apply_field_state_effects(item)
    return if item.nil?
    remove_all_field_state_effects(item)
    remove_field_state_effects(item)
    add_field_state_effects(item)
    change_field_state_turns(item)
    refresh_all_battlers
  end
  
  #--------------------------------------------------------------------------
  # new method: remove_all_field_state_effects
  #--------------------------------------------------------------------------
  def remove_all_field_state_effects(item)
    return unless item.remove_all_field_states
    BattleManager.clear_field_states
  end
  
  #--------------------------------------------------------------------------
  # new method: remove_field_state_effects
  #--------------------------------------------------------------------------
  def remove_field_state_effects(item)
    return if BattleManager.field_states == []
    return if item.remove_field_state == []
    for state_id in item.remove_field_state
      BattleManager.remove_field_state(state_id)
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: add_field_state_effects
  #--------------------------------------------------------------------------
  def add_field_state_effects(item)
    return if item.add_field_state == []
    for state_id in item.add_field_state
      BattleManager.add_field_state(state_id)
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: change_field_state_turns
  #--------------------------------------------------------------------------
  def change_field_state_turns(item)
    return if item.change_field_state_turns == {}
    for key in item.change_field_state_turns
      state_id = key[0]
      next unless BattleManager.field_state?(state_id)
      next unless $data_states[state_id].auto_removal_timing > 0
      turns = BattleManager.field_state_turns(state_id)
      BattleManager.change_field_state_turns(state_id, turns + key[1])
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: change_field_state_turns
  #--------------------------------------------------------------------------
  def refresh_all_battlers
    all_battle_members.each { |battler| battler.refresh }
    @status_window.refresh
  end
  
end # Scene_Battle

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================