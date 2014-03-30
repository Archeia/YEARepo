#==============================================================================
# 
# ▼ Yanfly Engine Ace - Battle System Add-On: Free Turn Battle v1.02
# -- Last Updated: 2012.01.15
# -- Level: Normal, Hard
# -- Requires: Yanfly Engine Ace - Ace Battle Engine v1.15+
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-BattleSystem-FTB"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.15 - Bug fixed: Battle victory log doesn't play twice.
# 2012.01.11 - Bug fixed: Dead actors are no longer inputable.
# 2012.01.10 - Finished Script.
# 2012.01.09 - Started Script.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Free Turn Battle is a type of battle system made for Ace Battle Engine, where
# actors perform their actions immediately (unless under the effects of berserk
# or any other form of autobattle) as they're selected. After all of their
# actions have been performed, the enemies will take their turn in battling the
# actors. This becomes a system where actors and enemies will take turns
# attacking one another as a whole.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# First, set the default battle system for your game to be :ftb by either going
# to the Ace Battle Engine script and setting DEFAULT_BATTLE_SYSTEM as :ftb or
# by using the following script call: 
# 
# $game_system:set_battle_system(:ftb)
# 
# -----------------------------------------------------------------------------
# Actor Notetags - These notetags go in the actors notebox in the database.
# -----------------------------------------------------------------------------
# <ftb actions: +x>
# <ftb actions: -x>
# This increases or decreases the maximum number of actions available to an
# actor by x. While an actor's individual maximum can be any value, it does not
# provide more than the party maximum applied in the module. An actor's total
# maximum cannot go below 1.
# 
# -----------------------------------------------------------------------------
# Class Notetags - These notetags go in the classes notebox in the database.
# -----------------------------------------------------------------------------
# <ftb actions: +x>
# <ftb actions: -x>
# This increases or decreases the maximum number of actions available to an
# actor by x. While an actor's individual maximum can be any value, it does not
# provide more than the party maximum applied in the module. An actor's total
# maximum cannot go below 1.
# 
# -----------------------------------------------------------------------------
# Skill Notetags - These notetags go in the skills notebox in the database.
# -----------------------------------------------------------------------------
# <ftb cost: x>
# This causes the skill to have an FTB cost of x. The FTB Cost does not occur
# for individual chain skills, individual input skills, specialized input
# skills, or instant skills. However, an FTB Cost can be used to put a specific
# requirement on those listed types of skills.
# 
# -----------------------------------------------------------------------------
# Item Notetags - These notetags go in the items notebox in the database.
# -----------------------------------------------------------------------------
# <ftb cost: x>
# This causes the item to have an FTB cost of x. The FTB Cost does not occur
# for instant items. If items cost more actions than the party has available,
# then the items will not appear in the usable item list during battle.
# 
# -----------------------------------------------------------------------------
# Weapon Notetags - These notetags go in the weapons notebox in the database.
# -----------------------------------------------------------------------------
# <ftb actions: +x>
# <ftb actions: -x>
# This increases or decreases the maximum number of actions available to an
# actor by x. While an actor's individual maximum can be any value, it does not
# provide more than the party maximum applied in the module. An actor's total
# maximum cannot go below 1.
# 
# -----------------------------------------------------------------------------
# Armour Notetags - These notetags go in the armour notebox in the database.
# -----------------------------------------------------------------------------
# <ftb actions: +x>
# <ftb actions: -x>
# This increases or decreases the maximum number of actions available to an
# actor by x. While an actor's individual maximum can be any value, it does not
# provide more than the party maximum applied in the module. An actor's total
# maximum cannot go below 1.
# 
# -----------------------------------------------------------------------------
# State Notetags - These notetags go in the state notebox in the database.
# -----------------------------------------------------------------------------
# <ftb actions: +x>
# <ftb actions: -x>
# This increases or decreases the maximum number of actions available to an
# actor by x. While an actor's individual maximum can be any value, it does not
# provide more than the party maximum applied in the module. An actor's total
# maximum cannot go below 1.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
# This script requires Yanfly Engine Ace - Ace Battle Engine v1.15+ and the
# script must be placed under Ace Battle Engine in the script listing.
# 
#==============================================================================

module YEA
  module FTB
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - General FTB Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These settings adjust various general Free Turn Battle constants such as
    # the icons used for actions and no actions, whether or not party members
    # will have limited actions (or unlimited).
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    ICON_ACTION = 188      # Icon displayed when there are actions left.
    ICON_EMPTY  = 185      # Icon displayed to indicate a used action.
    
    # For every x% above the base AGI, actors will gain an extra action. Change
    # the value below to adjust the percentage needed.
    EXTRA_FTB_ACTION_BONUS = 0.20
    
    # This is the maximum number of actions that the party can have despite the
    # maximum number of individual actor actions totalling to more than this.
    MAXIMUM_FTB_ACTIONS = 10
    
    # If this setting is on, then each member can only perform a limited amount
    # of actions per turn as opposed to freely performing actions until the
    # party's action usage is depleted.
    LIMITED_ACTIONS_PER_MEMBER = true
    
  end # FTB
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module BASEITEM
    
    FTB_ACTIONS = /<(?:FTB_ACTIONS|ftb actions):[ ]([\+\-]\d+)>/i
    
  end # BASEITEM
  module USABLEITEM
    
    FTB_COST = /<(?:FTB_COST|ftb cost):[ ](\d+)>/i
    
  end # USABLEITEM
  end # REGEXP
end # YEA

#==============================================================================
# ■ Icon
#==============================================================================

module Icon
  
  #--------------------------------------------------------------------------
  # self.ftb_action
  #--------------------------------------------------------------------------
  def self.ftb_action
    return YEA::FTB::ICON_ACTION
  end
  
  #--------------------------------------------------------------------------
  # self.ftb_empty
  #--------------------------------------------------------------------------
  def self.ftb_empty
    return YEA::FTB::ICON_EMPTY
  end
  
end # Icon

#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_ftb load_database; end
  def self.load_database
    load_database_ftb
    load_notetags_ftb
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_ftb
  #--------------------------------------------------------------------------
  def self.load_notetags_ftb
    groups = [$data_skills, $data_items, $data_actors, $data_classes,
      $data_weapons, $data_armors, $data_states]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_ftb
      end
    end
  end
  
end # DataManager

#==============================================================================
# ■ RPG::BaseItem
#==============================================================================

class RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :ftb_actions
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_ftb
  #--------------------------------------------------------------------------
  def load_notetags_ftb
    @ftb_actions = 0
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::BASEITEM::FTB_ACTIONS
        @ftb_actions = $1.to_i
      end
    } # self.note.split
    #---
  end
  
end # RPG::BaseItem

#==============================================================================
# ■ RPG::UsableItem
#==============================================================================

class RPG::UsableItem < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :ftb_cost
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_ftb
  #--------------------------------------------------------------------------
  def load_notetags_ftb
    @ftb_cost = 1
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::USABLEITEM::FTB_COST
        @ftb_cost = $1.to_i
      end
    } # self.note.split
    #---
  end
  
end # RPG::UsableItem

#==============================================================================
# ■ BattleManager
#==============================================================================

module BattleManager
  
  #--------------------------------------------------------------------------
  # alias method: make_action_orders
  #--------------------------------------------------------------------------
  class <<self; alias make_action_orders_ftb make_action_orders; end
  def self.make_action_orders
    make_action_orders_ftb
    make_ftb_action_orders if btype?(:ftb)
  end
  
  #--------------------------------------------------------------------------
  # new method: make_ftb_action_orders
  #--------------------------------------------------------------------------
  def self.make_ftb_action_orders
    @action_battlers = []
    @action_battlers += $game_party.members unless @surprise
    @action_battlers += $game_troop.members unless @preemptive
    @action_battlers.each { |battler| battler.make_speed }
    @action_battlers.sort! {|a,b| a.screen_x <=> b.screen_x }
  end
  
  #--------------------------------------------------------------------------
  # alias method: judge_win_loss
  #--------------------------------------------------------------------------
  class <<self; alias judge_win_loss_ftb judge_win_loss; end
  def self.judge_win_loss
    if @phase && $game_troop.all_dead? && SceneManager.scene_is?(Scene_Battle)
      SceneManager.scene.hide_ftb_gauge
    end
    judge_win_loss_ftb
  end
  
end # BattleManager

#==============================================================================
# ■ Game_BattlerBase
#==============================================================================

class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # new method: init_ftb_actions
  #--------------------------------------------------------------------------
  def init_ftb_actions
    @used_ftb_actions = 0
  end
  
  #--------------------------------------------------------------------------
  # new method: ftb_actions
  #--------------------------------------------------------------------------
  def ftb_actions
    init_ftb_actions if @used_ftb_actions.nil?
    return @used_ftb_actions
  end
  
  #--------------------------------------------------------------------------
  # new method: max_ftb_actions
  #--------------------------------------------------------------------------
  def max_ftb_actions
    n = make_action_times
    n += agi_bonus_max_ftb_actions
    n += trait_bonus_max_ftb_actions
    return [n, 1].max
  end
  
  #--------------------------------------------------------------------------
  # new method: agi_bonus_max_ftb_actions
  #--------------------------------------------------------------------------
  def agi_bonus_max_ftb_actions
    bonus_agi = agi - param_base(6)
    value_agi = param_base(6) * YEA::FTB::EXTRA_FTB_ACTION_BONUS
    return (bonus_agi / value_agi).to_i
  end
  
  #--------------------------------------------------------------------------
  # new method: trait_bonus_max_ftb_actions
  #--------------------------------------------------------------------------
  def trait_bonus_max_ftb_actions
    n = 0
    if actor?
      n += self.actor.ftb_actions
      n += self.class.ftb_actions
      for equip in equips
        next if equip.nil?
        n += equip.ftb_actions
      end
    end
    for state in states
      next if state.nil?
      n += state.ftb_actions
    end
    return n
  end
  
  #--------------------------------------------------------------------------
  # new method: use_ftb_action
  #--------------------------------------------------------------------------
  def use_ftb_action(value = 1)
    init_ftb_actions if @used_ftb_actions.nil?
    @used_ftb_actions += value
  end
  
  #--------------------------------------------------------------------------
  # alias method: inputable?
  #--------------------------------------------------------------------------
  alias game_battlerbase_inputable_ftb inputable?
  def inputable?
    result = game_battlerbase_inputable_ftb
    return false unless result
    return result unless SceneManager.scene_is?(Scene_Battle)
    return result unless BattleManager.btype?(:ftb)
    return result unless YEA::FTB::LIMITED_ACTIONS_PER_MEMBER
    return max_ftb_actions > ftb_actions
  end
  
  #--------------------------------------------------------------------------
  # alias method: skill_conditions_met?
  #--------------------------------------------------------------------------
  alias game_battlerbase_skill_conditions_met_ftb skill_conditions_met?
  def skill_conditions_met?(skill)
    return false unless ftb_item_conditions_met?(skill)
    return game_battlerbase_skill_conditions_met_ftb(skill)
  end
  
  #--------------------------------------------------------------------------
  # alias method: item_conditions_met?
  #--------------------------------------------------------------------------
  alias game_battlerbase_item_conditions_met_ftb item_conditions_met?
  def item_conditions_met?(item)
    return false unless ftb_item_conditions_met?(item)
    return game_battlerbase_item_conditions_met_ftb(item)
  end
  
  #--------------------------------------------------------------------------
  # new method: ftb_item_conditions_met?
  #--------------------------------------------------------------------------
  def ftb_item_conditions_met?(item)
    return true unless actor?
    return true unless SceneManager.scene_is?(Scene_Battle)
    return true unless BattleManager.btype?(:ftb)
    return true if BattleManager.in_turn?
    return $game_party.ftb_actions_remaining >= item.ftb_cost
  end
  
end # Game_BattlerBase

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias method: on_battle_start
  #--------------------------------------------------------------------------
  alias game_battler_on_battle_start_ftb on_battle_start
  def on_battle_start
    game_battler_on_battle_start_ftb
    init_ftb_actions
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_turn_end
  #--------------------------------------------------------------------------
  alias game_battler_on_turn_end_ftb on_turn_end
  def on_turn_end
    game_battler_on_turn_end_ftb
    init_ftb_actions
  end
  
  #--------------------------------------------------------------------------
  # alias method: make_action_times
  #--------------------------------------------------------------------------
  alias game_battler_make_action_times_ftb make_action_times
  def make_action_times
    if SceneManager.scene_is?(Scene_Battle) && BattleManager.btype?(:ftb)
      return make_ftb_action_times
    else
      return game_battler_make_action_times_ftb
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: make_ftb_action_times
  #--------------------------------------------------------------------------
  def make_ftb_action_times
    return action_plus_set.inject(1) {|r, p| p > 0.01 ? r + 1 : r }
  end
  
end # Game_Battler

#==============================================================================
# ■ Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  
  #--------------------------------------------------------------------------
  # alias method: next_command
  #--------------------------------------------------------------------------
  alias game_actor_next_command_ftb next_command
  def next_command
    if SceneManager.scene_is?(Scene_Battle) && BattleManager.btype?(:ftb)
      return false
    end
    return game_actor_next_command_ftb
  end
  
  #--------------------------------------------------------------------------
  # alias method: prior_command
  #--------------------------------------------------------------------------
  alias game_actor_prior_command_ftb prior_command
  def prior_command
    if SceneManager.scene_is?(Scene_Battle) && BattleManager.btype?(:ftb)
      return false
    end
    return game_actor_prior_command_ftb
  end
  
end # Game_Actor

#==============================================================================
# ■ Game_Party
#==============================================================================

class Game_Party < Game_Unit
  
  #--------------------------------------------------------------------------
  # alias method: inputable?
  #--------------------------------------------------------------------------
  alias game_party_inputable_ftb inputable?
  def inputable?
    return false unless meet_ftb_requirements?
    return game_party_inputable_ftb
  end
  
  #--------------------------------------------------------------------------
  # new method: meet_ftb_requirements?
  #--------------------------------------------------------------------------
  def meet_ftb_requirements?
    return true unless BattleManager.btype?(:ftb)
    return ftb_actions_remaining > 0
  end
  
  #--------------------------------------------------------------------------
  # new method: ftb_actions_remaining
  #--------------------------------------------------------------------------
  def ftb_actions_remaining
    return ftb_actions_maximum - ftb_actions_used
  end
  
  #--------------------------------------------------------------------------
  # new method: ftb_actions_maximum
  #--------------------------------------------------------------------------
  def ftb_actions_maximum
    n = 0
    for member in $game_party.members
      next unless member.game_battlerbase_inputable_ftb
      n += member.max_ftb_actions
    end
    return [n, YEA::FTB::MAXIMUM_FTB_ACTIONS].min
  end
  
  #--------------------------------------------------------------------------
  # new method: ftb_actions_used
  #--------------------------------------------------------------------------
  def ftb_actions_used
    n = 0
    for member in $game_party.members
      next unless member.game_battlerbase_inputable_ftb
      n += member.ftb_actions
    end
    return n
  end
  
end # Game_Party

#==============================================================================
# ■ Window_BattleStatus
#==============================================================================

class Window_BattleStatus < Window_Selectable
  
  #--------------------------------------------------------------------------
  # alias method: action_icon
  #--------------------------------------------------------------------------
  alias window_battlestatus_action_icon_ftb action_icon
  def action_icon(actor)
    if SceneManager.scene_is?(Scene_Battle) && BattleManager.btype?(:ftb)
      return Icon.ftb_action if act_ftb_valid?(actor)
    end
    return window_battlestatus_action_icon_ftb(actor)
  end
  
  #--------------------------------------------------------------------------
  # new method: act_ftb_valid?
  #--------------------------------------------------------------------------
  def act_ftb_valid?(actor)
    return false unless actor.current_action.nil? ||
      actor.current_action.item.nil?
    return true unless YEA::FTB::LIMITED_ACTIONS_PER_MEMBER
    return actor.max_ftb_actions > actor.ftb_actions
  end
  
end # Window_BattleStatus

#==============================================================================
# ■ Window_FTB_Gauge
#==============================================================================

class Window_FTB_Gauge < Window_Base
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(help_window)
    @help_window = help_window
    super(0, 0, Graphics.width, fitting_height(1))
    self.opacity = 0
    self.contents_opacity = 0
    self.z = 200
  end
  
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_empty_icons
    draw_filled_icons
  end
  
  #--------------------------------------------------------------------------
  # draw_empty_icons
  #--------------------------------------------------------------------------
  def draw_empty_icons
    n = $game_party.ftb_actions_maximum
    dx = contents.width
    n.times do
      dx -= 24
      draw_icon(Icon.ftb_empty, dx, 0)
    end
  end
  
  #--------------------------------------------------------------------------
  # draw_filled_icons
  #--------------------------------------------------------------------------
  def draw_filled_icons
    n = $game_party.ftb_actions_maximum - $game_party.ftb_actions_used
    dx = contents.width
    n.times do
      dx -= 24
      draw_icon(Icon.ftb_action, dx, 0)
    end
  end
  
  #--------------------------------------------------------------------------
  # update
  #--------------------------------------------------------------------------
  def update
    super
    self.contents_opacity = 0 unless SceneManager.scene_is?(Scene_Battle)
    return unless SceneManager.scene_is?(Scene_Battle)
    return unless BattleManager.btype?(:ftb)
    change_contents_opacity
    change_y_position
  end
  
  #--------------------------------------------------------------------------
  # change_contents_opacity
  #--------------------------------------------------------------------------
  def change_contents_opacity
    rate = BattleManager.in_turn? ? -8 : 8
    self.contents_opacity += rate
  end
  
  #--------------------------------------------------------------------------
  # change_y_position
  #--------------------------------------------------------------------------
  def change_y_position
    self.y = @help_window.visible ? @help_window.height : 0
  end
  
end # Window_FTB_Gauge

#==============================================================================
# ■ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: create_all_windows
  #--------------------------------------------------------------------------
  alias scene_battle_create_all_windows_ftb create_all_windows
  def create_all_windows
    scene_battle_create_all_windows_ftb
    create_ftb_gauge
  end
  
  #--------------------------------------------------------------------------
  # new method: create_ftb_gauge
  #--------------------------------------------------------------------------
  def create_ftb_gauge
    @ftb_gauge = Window_FTB_Gauge.new(@help_window)
  end
  
  #--------------------------------------------------------------------------
  # alias method: start_party_command_selection
  #--------------------------------------------------------------------------
  alias start_party_command_selection_ftb start_party_command_selection
  def start_party_command_selection
    start_party_command_selection_ftb
    refresh_ftb_gauge
  end
  
  #--------------------------------------------------------------------------
  # alias method: start_actor_command_selection
  #--------------------------------------------------------------------------
  alias start_actor_command_selection_ftb start_actor_command_selection
  def start_actor_command_selection
    start_actor_command_selection_ftb
    refresh_ftb_gauge
  end
  
  #--------------------------------------------------------------------------
  # new method: refresh_ftb_gauge
  #--------------------------------------------------------------------------
  def refresh_ftb_gauge
    @ftb_gauge.refresh
  end
  
  #--------------------------------------------------------------------------
  # new method: hide_ftb_gauge
  #--------------------------------------------------------------------------
  def hide_ftb_gauge
    @ftb_gauge.hide
  end
  
  #--------------------------------------------------------------------------
  # alias method: next_command
  #--------------------------------------------------------------------------
  alias scene_battle_next_command_ftb next_command
  def next_command
    if ftb_action?
      perform_ftb_action
    else
      scene_battle_next_command_ftb
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: ftb_action?
  #--------------------------------------------------------------------------
  def ftb_action?
    return false unless BattleManager.btype?(:ftb)
    return false if BattleManager.actor.nil?
    return false if BattleManager.actor.current_action.nil?
    action = BattleManager.actor.current_action.item
    return !action.nil?
  end
  
  #--------------------------------------------------------------------------
  # new method: perform_ftb_action
  #--------------------------------------------------------------------------
  def perform_ftb_action
    hide_ftb_action_windows
    @subject = BattleManager.actor
    item = @subject.current_action.item
    execute_action
    process_event
    loop do
      @subject.remove_current_action
      break if $game_troop.all_dead?
      break unless @subject.current_action
      @subject.current_action.prepare
      execute_action if @subject.current_action.valid?
    end
    return if $game_troop.alive_members.size <= 0
    process_action_end
    consume_ftb_action(item)
    @subject.make_actions
    @subject = nil
    show_ftb_action_windows
  end
  
  #--------------------------------------------------------------------------
  # new method: consume_ftb_action
  #--------------------------------------------------------------------------
  def consume_ftb_action(item)
    @subject.use_ftb_action(item.ftb_cost) unless item.nil?
    refresh_ftb_gauge
  end
  
  #--------------------------------------------------------------------------
  # new method: hide_ftb_action_windows
  #--------------------------------------------------------------------------
  def hide_ftb_action_windows
    @info_viewport.visible = true
    @status_aid_window.hide
    @status_window.show
    @actor_command_window.show
  end
  
  #--------------------------------------------------------------------------
  # new method: show_ftb_action_windows
  #--------------------------------------------------------------------------
  def show_ftb_action_windows
    @info_viewport.visible = true
    end_ftb_action
  end
  
  #--------------------------------------------------------------------------
  # new method: end_ftb_action
  #--------------------------------------------------------------------------
  def end_ftb_action
    if $game_party.inputable?
      select_next_member
    else
      status_redraw_target(BattleManager.actor)
      BattleManager.next_command
      turn_start
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: select_next_member
  #--------------------------------------------------------------------------
  def select_next_member
    status_redraw_target(BattleManager.actor)
    last_index = $game_party.battle_members.size - 1
    for member in $game_party.battle_members.reverse
      break if member.inputable?
      last_index -= 1
    end
    next_command if next_ftb_member?(last_index)
    return if BattleManager.actor.nil?
    if BattleManager.actor.index >= last_index && !BattleManager.actor.inputable?
      prior_command
    else
      start_actor_command_selection
      status_redraw_target(BattleManager.actor)
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: next_ftb_member?
  #--------------------------------------------------------------------------
  def next_ftb_member?(last_index)
    actor = BattleManager.actor
    return true if actor.nil?
    return false if actor.max_ftb_actions > actor.ftb_actions
    return false if BattleManager.actor.index >= last_index
    return BattleManager.actor.index != last_index
  end
  
  #--------------------------------------------------------------------------
  # alias method: hide_extra_gauges
  #--------------------------------------------------------------------------
  alias scene_battle_hide_extra_gauges_ftb hide_extra_gauges
  def hide_extra_gauges
    scene_battle_hide_extra_gauges_ftb
    @ftb_gauge.hide
  end
  
  #--------------------------------------------------------------------------
  # alias method: show_extra_gauges
  #--------------------------------------------------------------------------
  alias scene_battle_show_extra_gauges_ftb show_extra_gauges
  def show_extra_gauges
    scene_battle_show_extra_gauges_ftb
    @ftb_gauge.show
  end
  
end # Scene_Battle

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================