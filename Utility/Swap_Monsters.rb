#==============================================================================
# 
# ▼ Yanfly Engine Ace - Swap Monsters v1.00
# -- Last Updated: 2011.12.20
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-SwapMonsters"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.20 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Ported from various VX Yanfly Engines, this script allows you to have one
# enemy be a basic randomizing swap dummy for other enemies. Insert enemy ID's
# of other enemies inside of the swap notetag and those enemies will take place
# of the swap monster at the start of a battle.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Enemy Notetags - These notetags go in the enemy notebox in the database.
# -----------------------------------------------------------------------------
# <swap: x>
# <swap: x, x>
# Makes the current enemy into a swap dummy. Insert the ID's of other enemies
# you want the current enemy to randomize into. Insert multiples of this tag if
# you want more randomized enemies.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module ENEMY
    
    SWAP = /<(?:SWAP|swap):[ ]*(\d+(?:\s*,\s*\d+)*)>/i
    
  end # ENEMY
  end # REGEXP
end # YEA

#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_swm load_database; end
  def self.load_database
    load_database_swm
    load_notetags_swm
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_swm
  #--------------------------------------------------------------------------
  def self.load_notetags_swm
    for enemy in $data_enemies
      next if enemy.nil?
      enemy.load_notetags_swm
    end
  end
  
end # DataManager

#==============================================================================
# ■ RPG::Enemy
#==============================================================================

class RPG::Enemy < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :swaps
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_swm
  #--------------------------------------------------------------------------
  def load_notetags_swm
    @swaps = []
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::ENEMY::SWAP
        $1.scan(/\d+/).each { |num| 
        next if num.to_i >= $data_enemies.size
        @swaps.push(num.to_i) if num.to_i > 0 }
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::Enemy

#==============================================================================
# ■ Game_Enemy
#==============================================================================

class Game_Enemy < Game_Battler
  
  #--------------------------------------------------------------------------
  # alias method: initialize
  #--------------------------------------------------------------------------
  alias game_enemy_initialize_swm initialize
  def initialize(index, enemy_id)
    if $data_enemies[enemy_id].swaps != []
      enemy_id = $data_enemies[enemy_id].swaps.sample
    end
    game_enemy_initialize_swm(index, enemy_id)
  end
  
end # Game_Enemy

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================