#==============================================================================
# 
# ▼ Yanfly Engine Ace - Anti-Fail Message v1.00
# -- Last Updated: 2011.12.23
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-AntiFailMessage"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.23 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# For eventers or custom effect makers out there, when using a skill or item on
# an enemy without any damage or status effect changes, a fail message will
# occur even if there are common events or other effects happening. With this
# script, you can insert a notetag into the skill or item noteboxes to prevent
# that fail message from appearing.
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
# -----------------------------------------------------------------------------
# Skill Notetags - These notetags go in the skills notebox in the database.
# -----------------------------------------------------------------------------
# <anti fail>
# Insert this notetag inside of a skill's notebox to prevent it from showing a
# failed message despite having custom effects or running a common event.
# 
# -----------------------------------------------------------------------------
# Item Notetags - These notetags go in the skills notebox in the database.
# -----------------------------------------------------------------------------
# <anti fail>
# Insert this notetag inside of an item's notebox to prevent it from showing a
# failed message despite having custom effects or running a common event.
# 
#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module USABLEITEM
    
    ANTIFAIL = /<(?:ANTI_FAIL|anti fail|antifail)>/i
    
  end # USABLEITEM
  end # REGEXP
end # YEA

#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_antifail load_database; end
  def self.load_database
    load_database_antifail
    load_notetags_antifail
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_antifail
  #--------------------------------------------------------------------------
  def self.load_notetags_antifail
    groups = [$data_skills, $data_items]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_antifail
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
  attr_accessor :antifail
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_antifail
  #--------------------------------------------------------------------------
  def load_notetags_antifail
    @antifail = false
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::USABLEITEM::ANTIFAIL
        @antifail = true
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::UsableItem

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias method: item_user_effect
  #--------------------------------------------------------------------------
  alias game_battler_item_user_effect_antifail item_user_effect
  def item_user_effect(user, item)
    game_battler_item_user_effect_antifail(user, item)
    apply_antifail(item)
  end
  
  #--------------------------------------------------------------------------
  # new method: apply_antifail
  #--------------------------------------------------------------------------
  def apply_antifail(item)
    @result.success = true if item.antifail
  end
  
end # Game_Battler

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================