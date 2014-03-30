#==============================================================================
# 
# ▼ Yanfly Engine Ace - Party System Add-On: Command Party v1.01
# -- Last Updated: 2012.01.10
# -- Level: Easy, Normal
# -- Requires: YEA - Party System v1.00+
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-CommandParty"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.10 - Compatibility Update: Ace Battle Engine v1.15+
# 2011.12.13 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# An add-on to the Yanfly Engine Ace - Party System script. This script allows
# the player to change party members during the middle of battle from the
# Party Command Window (the Fight/Escape window).
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# Note, if you do not give your player access to the party formation menu
# available in the Party System script, this script will disable itself.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
# This script requires Yanfly Engine Ace - Party System v1.00+.
# 
#==============================================================================

module YEA
  module COMMAND_PARTY
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Command Party Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This is just how the text appears visually in battle for your party and
    # how often the can change party in battle. Furthermore, there's two
    # switches that may be enabled or disabled to add the command to the
    # game. Adjust it as you see fit. Set the switches to 0 to not use them.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    COMMAND_TEXT   = "Party"    # Text used for the command.
    PARTY_COOLDOWN = 2          # Turns that must pass between each change.
    SHOW_SWITCH    = 0          # If switch is on, show command. 0 to disable.
    ENABLE_SWITCH  = 0          # If switch is on, enable command. 0 to disable.
    
  end # COMMAND_PARTY
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

if $imported["YEA-PartySystem"]

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
# ■ Game_Unit
#==============================================================================

class Game_Unit
  
  #--------------------------------------------------------------------------
  # alias method: on_battle_start
  #--------------------------------------------------------------------------
  alias game_unit_on_battle_start_cpt on_battle_start
  def on_battle_start
    game_unit_on_battle_start_cpt
    reset_party_cooldown
  end
  
  #--------------------------------------------------------------------------
  # new method: reset_party_cooldown
  #--------------------------------------------------------------------------
  def reset_party_cooldown
    @party_cooldown = 0
  end
  
  #--------------------------------------------------------------------------
  # new method: update_party_cooldown
  #--------------------------------------------------------------------------
  def update_party_cooldown
    reset_party_cooldown if @party_cooldown.nil?
    @party_cooldown = [@party_cooldown - 1, 0].max
  end
  
  #--------------------------------------------------------------------------
  # new method: battle_party_change?
  #--------------------------------------------------------------------------
  def battle_party_change?
    switch = YEA::COMMAND_PARTY::ENABLE_SWITCH
    enabled = switch <= 0 ? true : $game_switches[switch]
    return false unless enabled
    reset_party_cooldown if @party_cooldown.nil?
    return @party_cooldown <= 0
  end
  
  #--------------------------------------------------------------------------
  # new method: set_party_cooldown
  #--------------------------------------------------------------------------
  def set_party_cooldown
    @party_cooldown = YEA::COMMAND_PARTY::PARTY_COOLDOWN
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_battle_end
  #--------------------------------------------------------------------------
  alias game_unit_on_battle_end_cpt on_battle_end
  def on_battle_end
    game_unit_on_battle_end_cpt
    reset_party_cooldown
  end
  
end # Game_Unit

#==============================================================================
# ■ Window_PartyCommand
#==============================================================================

class Window_PartyCommand < Window_Command
  
  #--------------------------------------------------------------------------
  # alias method: make_command_list
  #--------------------------------------------------------------------------
  alias window_partycommand_make_command_list_cpt make_command_list
  def make_command_list
    window_partycommand_make_command_list_cpt
    return if $imported["YEA-BattleCommandList"]
    add_party_command
  end
  
  #--------------------------------------------------------------------------
  # new method: add_party_command
  #--------------------------------------------------------------------------
  def add_party_command
    return unless YEA::PARTY::ENABLE_MENU
    show = YEA::COMMAND_PARTY::SHOW_SWITCH
    continue = show == 0 ? true : $game_switches[show]
    continue = false if $game_party.all_members.size < 2
    return unless continue
    text = YEA::COMMAND_PARTY::COMMAND_TEXT
    add_command(text, :party, $game_party.battle_party_change?)
  end
  
end # Window_PartyCommand

#==============================================================================
# ■ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: create_party_command_window
  #--------------------------------------------------------------------------
  alias create_party_command_window_cpt create_party_command_window
  def create_party_command_window
    create_party_command_window_cpt
    @party_command_window.set_handler(:party, method(:command_party))
  end
  
  #--------------------------------------------------------------------------
  # new method: command_party
  #--------------------------------------------------------------------------
  def command_party
    Graphics.freeze
    @info_viewport.visible = false
    hide_extra_gauges if $imported["YEA-BattleEngine"]
    SceneManager.snapshot_for_background
    previous_party = $game_party.battle_members.clone
    index = @party_command_window.index
    oy = @party_command_window.oy
    #---
    SceneManager.call(Scene_Party)
    SceneManager.scene.main
    SceneManager.force_recall(self)
    #---
    show_extra_gauges if $imported["YEA-BattleEngine"]
    if previous_party != $game_party.battle_members
      $game_party.make_actions
      $game_party.set_party_cooldown
    end
    @info_viewport.visible = true
    @status_window.refresh
    @party_command_window.setup
    @party_command_window.select(index)
    @party_command_window.oy = oy
    perform_transition
  end
  
  #--------------------------------------------------------------------------
  # alias method: turn_end
  #--------------------------------------------------------------------------
  alias scene_battle_turn_end_cpt turn_end
  def turn_end
    scene_battle_turn_end_cpt
    return if $imported["YEA-BattleEngine"]
    update_party_cooldowns
  end
  
  #--------------------------------------------------------------------------
  # new method: update_party_cooldowns
  #--------------------------------------------------------------------------
  def update_party_cooldowns
    $game_party.update_party_cooldown
    $game_troop.update_party_cooldown
  end
  
end # Scene_Battle
end # $imported["YEA-PartySystem"]

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================