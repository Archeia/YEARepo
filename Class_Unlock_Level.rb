#==============================================================================
# 
# ▼ Yanfly Engine Ace - Class System Add-On: Class Unlock Level v1.00
# -- Last Updated: 2011.12.20
# -- Level: Normal
# -- Requires: YEA - Class System v1.01+
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-ClassUnlockLevel"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.20 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script allows for classes to be unlocked after a class reaches a certain
# level. Note that this script is made for the Class System script and not
# using the MAINTAIN_LEVELS feature. Requirements for unlocking a class can be
# multiple level requirements as well.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Class Notetags - These notetags go in the class notebox in the database.
# -----------------------------------------------------------------------------
# <level unlock requirements>
#   class x: level y
#   class x: level y
# </level unlock requirements>
# Sets the requirements for unlocking that particular class. The unlocking of
# the class will require classes x to be at level y. Insert multiple of the
# strings in between the two opening and closing notetags to require all of the
# class levels to be met.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
# This script requires Yanfly Engine Ace - Class System v1.01+.
# 
#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

if $imported["YEA-ClassSystem"] && !YEA::CLASS_SYSTEM::MAINTAIN_LEVELS

module YEA
  module REGEXP
  module CLASS
    
    LV_UNLOCK_ON =
      /<(?:LEVEL_UNLOCK_REQUIREMENTS|level unlock requirements)>/i
    LV_UNLOCK_OFF =
      /<\/(?:LEVEL_UNLOCK_REQUIREMENTS|level unlock requirements)>/i
    LV_UNLOCK_STR = /CLASS[ ](\d+): LEVEL[ ](\d+)/i
    
  end # CLASS
  end # REGEXP
end # YEA

#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_cul load_database; end
  def self.load_database
    load_database_cul
    load_notetags_cul
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_cul
  #--------------------------------------------------------------------------
  def self.load_notetags_cul
    for obj in $data_classes
      next if obj.nil?
      obj.load_notetags_cul
    end
  end
  
end # DataManager

#==============================================================================
# ■ RPG::Class
#==============================================================================

class RPG::Class < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :level_unlock
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_cul
  #--------------------------------------------------------------------------
  def load_notetags_cul
    @level_unlock = {}
    @level_unlock_on = false
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::CLASS::LV_UNLOCK_ON
        @level_unlock_on = true
      when YEA::REGEXP::CLASS::LV_UNLOCK_OFF
        @level_unlock_on = false
      when YEA::REGEXP::CLASS::LV_UNLOCK_STR
        next unless @level_unlock_on
        @level_unlock[$1.to_i] = $2.to_i
      end
    } # self.note.split
    #---
  end
  
end # RPG::Class

#==============================================================================
# ■ Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  
  #--------------------------------------------------------------------------
  # check_level_unlocked_classes
  #--------------------------------------------------------------------------
  def check_level_unlocked_classes
    for item in $data_classes
      next if item.nil?
      next if unlocked_classes.include?(item.id)
      next if item.level_unlock == {}
      next unless class_unlock_level_requirements_met?(item)
      unlock_class(item.id)
    end
  end
  
  #--------------------------------------------------------------------------
  # class_unlock_level_requirements_met?
  #--------------------------------------------------------------------------
  def class_unlock_level_requirements_met?(item)
    for key in item.level_unlock
      class_id = key[0]
      level_req = key[1]
      return false if class_level(class_id) < level_req
    end
    return true
  end
  
end # Game_Actor

#==============================================================================
# ■ Window_ClassList
#==============================================================================

class Window_ClassList < Window_Selectable
  
  #--------------------------------------------------------------------------
  # alias method: actor=
  #--------------------------------------------------------------------------
  alias window_classlist_actor_equals_cul actor=
  def actor=(actor)
    return if @actor == actor
    actor.check_level_unlocked_classes
    window_classlist_actor_equals_cul(actor)
  end
  
end # Window_ClassList

end # $imported["YEA-ClassSystem"] && !YEA::CLASS_SYSTEM::MAINTAIN_LEVELS

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================