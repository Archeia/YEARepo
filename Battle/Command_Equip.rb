#==============================================================================
# 
# ▼ Yanfly Engine Ace - Command Equip v1.01
# -- Modified by : Doogy
# -- Last Updated: 2015.02.17
# -- Level: Easy, Normal
# -- Requires: Yanfly Engine Ace - Equip Engine
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-CommandEquip"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.10 - Compatibility Update: Ace Battle Engine v1.15+
# 2011.12.13 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This command allows your actors to be able to change equipment in the middle
# of battle by directly accessing the equip scene in the middle of battle, and
# returning back to the battle scene exactly as it was. Furthermore, you can
# limit how frequently your player can switch equipment for each of the actors.
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

module YEA
  module COMMAND_EQUIP
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Battle Equip Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This is just how the text appears visually in battle for your actors and
    # how often they can change equips in battle.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    COMMAND_TEXT   = "Equip"      # Text used for the command.
    EQUIP_COOLDOWN = 1            # Turns to wait before re-equipping.
    EQUIP_SKIPTURN = true         # If true, it will cost a turn to equip.
    EQUIP_FIXEDSLOT = [2,3,4,5,6]  # list of fixed slots in combat.
    
  end # COMMAND_EQUIP
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

#==============================================================================
# ■ SceneManager
#==============================================================================

module SceneManager
  
  #--------------------------------------------------------------------------
  # new method: self.force_recall
  #--------------------------------------------------------------------------
  def self.force_recall(scene_class)
    @scene = scene_class
  end
  
end # SceneManager

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias method: on_battle_start
  #--------------------------------------------------------------------------
  alias game_battler_on_battle_start_ceq on_battle_start
  def on_battle_start
    game_battler_on_battle_start_ceq
    reset_equip_cooldown
  end
  
  #--------------------------------------------------------------------------
  # new method: reset_equip_cooldown
  #--------------------------------------------------------------------------
  def reset_equip_cooldown
    @equip_cooldown = 0
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_turn_end
  #--------------------------------------------------------------------------
  alias game_battler_on_turn_end_ceq on_turn_end
  def on_turn_end
    game_battler_on_turn_end_ceq
    update_equip_cooldown
  end
  
  #--------------------------------------------------------------------------
  # new method: update_equip_cooldown
  #--------------------------------------------------------------------------
  def update_equip_cooldown
    reset_equip_cooldown if @equip_cooldown.nil?
    @equip_cooldown = [@equip_cooldown - 1, 0].max
  end
  
  #--------------------------------------------------------------------------
  # new method: battle_equippable?
  #--------------------------------------------------------------------------
  def battle_equippable?
    reset_equip_cooldown if @equip_cooldown.nil?
    return @equip_cooldown <= 0
  end
  
  #--------------------------------------------------------------------------
  # new method: set_equip_cooldown
  #--------------------------------------------------------------------------
  def set_equip_cooldown
    @equip_cooldown = YEA::COMMAND_EQUIP::EQUIP_COOLDOWN
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_battle_end
  #--------------------------------------------------------------------------
  alias game_battler_on_battle_end_ceq on_battle_end
  def on_battle_end
    game_battler_on_battle_end_ceq
    reset_equip_cooldown
  end
  
end # Game_Battler

#==============================================================================
# ■ Window_EquipCommand
#==============================================================================

class Window_EquipCommand < Window_HorzCommand
  
  #--------------------------------------------------------------------------
  # overwrite method: handle?
  #--------------------------------------------------------------------------
  def handle?(symbol)
    if [:pageup, :pagedown].include?(symbol) && $game_party.in_battle
      return false
    end
    return super(symbol)
  end
  
end # Window_EquipCommand

#==============================================================================
# ■ Window_ActorCommand
#==============================================================================

class Window_ActorCommand < Window_Command
  
  #--------------------------------------------------------------------------
  # alias method: make_command_list
  #--------------------------------------------------------------------------
  alias window_actorcommand_make_command_list_ceq make_command_list
  def make_command_list
    window_actorcommand_make_command_list_ceq
    return unless @actor
    return if $imported["YEA-BattleCommandList"]
    add_equip_command
  end
  
  #--------------------------------------------------------------------------
  # new method: add_equip_command
  #--------------------------------------------------------------------------
  def add_equip_command
    text = YEA::COMMAND_EQUIP::COMMAND_TEXT
    add_command(text, :equip, @actor.battle_equippable?)
  end
  
end # Window_ActorCommand

#==============================================================================
# ■ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: create_actor_command_window
  #--------------------------------------------------------------------------
  alias create_actor_command_window_ceq create_actor_command_window
  def create_actor_command_window
    create_actor_command_window_ceq
    @actor_command_window.set_handler(:equip, method(:command_equip))
  end
  
  #--------------------------------------------------------------------------
  # new method: command_equip
  #--------------------------------------------------------------------------
  def command_equip
    remove = []
    fixed_slot = YEA::COMMAND_EQUIP::EQUIP_FIXEDSLOT
    Graphics.freeze
    @info_viewport.visible = false
    hide_extra_gauges if $imported["YEA-BattleEngine"]
    SceneManager.snapshot_for_background
    actor = $game_party.battle_members[@status_window.index]
    for etype_id in fixed_slot
      if not actor.equip_type_fixed?(etype_id)
        actor.actor.fixed_equip_type.push(etype_id)
        remove.push(etype_id)
      end
    end
    $game_party.menu_actor = actor
    previous_equips = actor.equips.clone
    index = @actor_command_window.index
    oy = @actor_command_window.oy
    #---
    
    SceneManager.call(Scene_Equip)
    SceneManager.scene.main
    SceneManager.force_recall(self)
    
    #---
    show_extra_gauges if $imported["YEA-BattleEngine"]
    actor.set_equip_cooldown if previous_equips != actor.equips
    @info_viewport.visible = true
    @status_window.refresh
    @actor_command_window.setup(actor)
    @actor_command_window.select(index)
    @actor_command_window.oy = oy
    for etype_id in remove
        actor.actor.fixed_equip_type.delete(etype_id)
    end
    perform_transition
    next_command if YEA::COMMAND_EQUIP::EQUIP_SKIPTURN
  end
  
end # Scene_Battle

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================
