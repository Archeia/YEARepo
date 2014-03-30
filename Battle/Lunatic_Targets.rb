#==============================================================================
# 
# ▼ Yanfly Engine Ace - Lunatic Targets v1.00
# -- Last Updated: 2012.01.02
# -- Level: Lunatic
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-LunaticTargets"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.02 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Lunatic mode effects have always been a core part of Yanfly Engine scripts.
# They exist to provide more effects for those who want more power and control
# for their items, skills, status effects, etc., but the users must be able to
# add them in themselves.
# 
# This script provides the base setup for state lunatic targeting. This script
# lets you select a custom scope of targets that can be either dynmaic or a set
# scope. This script will work with YEA - Target Manager as long as it's placed
# above YEA - Target Manager.
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
# This script is compatible with Yanfly Engine Ace - Target Manager v1.01+.
# Place this script above Yanfly Engine Ace - Target Manager v1.01+.
# 
#==============================================================================

class Game_Action
  
  #--------------------------------------------------------------------------
  # ● Welcome to Lunatic Mode
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Lunatic Targets allow allow skills and items to select a custom set of
  # targets for their scope. To make use of a Lunatic Target scope, use the
  # following notetag:
  # 
  #     <custom target: string>
  # 
  # If multiple tags of the same type are used in the same skill/item's
  # notebox, then the targets will be selected in that order. Replace "string"
  # in the tags with the appropriate flag for the method below to search for.
  # Note that unlike the previous versions, these are all upcase.
  # 
  # Should you choose to use multiple lunatic target scopes for a single
  # object, you may use these notetags in place of the ones shown above.
  # 
  #     <custom target>
  #      string
  #      string
  #     </custom target>
  # 
  # All of the string information in between those two notetags will be
  # stored the same way as the notetags shown before those. There is no
  # difference between using either.
  #--------------------------------------------------------------------------
  def lunatic_target(smooth_target)
    user = subject
    targets = []
    for effect in item.custom_targets
      case effect.upcase
      #----------------------------------------------------------------------
      # Common Before Target
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # This is a common scope that runs at the start of a targeting scope.
      # Any changes made here will affect the targeting of all skills/items.
      #----------------------------------------------------------------------
      when /COMMON BEFORE TARGET/i
        # No common targeting effects applied.
        
      #----------------------------------------------------------------------
      # Common After Target
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # This is a common scope that runs at the end of a targeting scope.
      # Any changes made here will affect the targeting of all skills/items.
      #----------------------------------------------------------------------
      when /COMMON AFTER TARGET/i
        # No common targeting effects applied.
        
      #----------------------------------------------------------------------
      # Default Targets
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # If this tag is used, then the default targets will be added to the
      # total scope of targets.
      #----------------------------------------------------------------------
      when /DEFAULT TARGET/i
        targets += default_target_set
        
      #----------------------------------------------------------------------
      # Stop editting past this point.
      #----------------------------------------------------------------------
      else
        targets = lunatic_targets_extension(effect, user, smooth_target, targets)
      end
    end
    return targets
  end
  
end # Game_Action

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module USABLEITEM
    
    CUSTOM_TARGET_STR =
      /<(?:CUSTOM_TARGET|custom target|custom targets):[ ](.*)>/i
    CUSTOM_TARGET_ON  =
      /<(?:CUSTOM_TARGET|custom target|custom targets)>/i
    CUSTOM_TARGET_OFF =
      /<\/(?:CUSTOM_TARGET|custom target|custom targets)>/i
    
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
  class <<self; alias load_database_ltar load_database; end
  def self.load_database
    load_database_ltar
    load_notetags_ltar
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_ltar
  #--------------------------------------------------------------------------
  def self.load_notetags_ltar
    groups = [$data_items, $data_skills]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_ltar
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
  attr_accessor :custom_targets
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_ltar
  #--------------------------------------------------------------------------
  def load_notetags_ltar
    @custom_targets = ["COMMON BEFORE TARGET"]
    @custom_targets_on  = false
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::USABLEITEM::CUSTOM_TARGET_STR
        @custom_targets.push($1.to_s)
      #---
      when YEA::REGEXP::USABLEITEM::CUSTOM_TARGET_ON
        @custom_targets_on = true
      when YEA::REGEXP::USABLEITEM::CUSTOM_TARGET_OFF
        @custom_targets_on = false
      #---
      else
        @custom_targets.push(line.to_s) if @custom_targets_on
      end
    } # self.note.split
    #---
    @custom_targets.push("DEFAULT TARGET") if @custom_targets.size == 1
    @custom_targets.push("COMMON AFTER TARGET")
  end
  
end # RPG::UsableItem

#==============================================================================
# ■ Game_Action
#==============================================================================

class Game_Action
  
  #--------------------------------------------------------------------------
  # alias method: make_targets
  #--------------------------------------------------------------------------
  alias game_action_make_targets_ltar make_targets
  def make_targets
    group = item.for_friend? ? friends_unit : opponents_unit
    smooth_target = group.smooth_target(@target_index)
    return lunatic_target(smooth_target)
  end
  
  #--------------------------------------------------------------------------
  # new method: default_target_set
  #--------------------------------------------------------------------------
  def default_target_set
    return game_action_make_targets_ltar
  end
  
  #--------------------------------------------------------------------------
  # new method: lunatic_targets_extension
  #--------------------------------------------------------------------------
  def lunatic_targets_extension(effect, user, smooth_target, targets)
    # Reserved for future Add-ons.
    return targets
  end
  
end # Game_Action

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================