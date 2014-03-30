#==============================================================================
# 
# ▼ Yanfly Engine Ace - Stop All Movement v1.00
# -- Last Updated: 2011.12.10
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-StopAllMovement"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.10 - Started Script and Finished..
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script provides two switches. One switch will stop all NPC events from
# being able to move when it's on. The other switch will prevent the player
# from being able to move when it's on (outside of an event).
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# Go to the module and bind the STOP_NPC_MOVEMENT_SWITCH and the
# STOP_PLAYER_MOVEMENT_SWITCH constants to a switch you want to stop NPC's and
# the player with.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module UTILITY
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Stop Movement Switches -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These switches control whether or not the respective events can move.
    # If the switches are off, then there is no locking them. If the switches
    # are on, then the events are locked from moving.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    STOP_NPC_MOVEMENT_SWITCH    = 22
    STOP_PLAYER_MOVEMENT_SWITCH = 23
    
  end # UTILITY
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

#==============================================================================
# ■ Switch
#==============================================================================

module Switch
  
  #--------------------------------------------------------------------------
  # self.Switch
  #--------------------------------------------------------------------------
  def self.stop_npc_movement
    return $game_switches[YEA::UTILITY::STOP_NPC_MOVEMENT_SWITCH]
  end
  
  #--------------------------------------------------------------------------
  # self.Switch
  #--------------------------------------------------------------------------
  def self.stop_player_movement
    return $game_switches[YEA::UTILITY::STOP_PLAYER_MOVEMENT_SWITCH]
  end
    
end # Switch

#==============================================================================
# ■ Game_Player
#==============================================================================

class Game_Player < Game_Character
  
  #--------------------------------------------------------------------------
  # alias method: move_by_input
  #--------------------------------------------------------------------------
  alias game_player_move_by_input_sam move_by_input
  def move_by_input
    return if Switch.stop_player_movement
    game_player_move_by_input_sam
  end
  
end # Game_Player

#==============================================================================
# ■ Game_Event
#==============================================================================

class Game_Event < Game_Character
  
  #--------------------------------------------------------------------------
  # alias method: update_self_movement
  #--------------------------------------------------------------------------
  alias game_event_update_self_movement_sam update_self_movement
  def update_self_movement
    return if Switch.stop_npc_movement
    game_event_update_self_movement_sam
  end
  
end # Game_Event

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================