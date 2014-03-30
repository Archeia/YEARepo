#==============================================================================
# 
# ▼ Yanfly Engine Ace - Class Specifics v1.00
# -- Last Updated: 2011.12.23
# -- Level: Normal
# -- Requires: YEA - Class System v1.03+
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-ClassSpecifics"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.23 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script allows for certain classes to be primary-only or sublcass-only.
# In addition to that, subclasses can require certain classes to be primary
# classes in order to be applied.
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
# <primary only>
# Makes this class equippable only if it's the primary class.
# 
# <subclass only>
# Makes this class equippable only if it's the subclass class.
# 
# <subclass to: x>
# <subclass to: x, x>
# This makes the class subclass only and only equippable if the primary class
# is one of the listed x classes.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
# This script requires Yanfly Engine Ace - Class System v1.03+.
# 
#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

if $imported["YEA-ClassSystem"]

module YEA
  module REGEXP
  module CLASS
    
    PRIMARY_ONLY  = /<(?:PRIMARY_ONLY|primary only)>/i
    SUBCLASS_ONLY = /<(?:SUBCLASS_ONLY|subclass only)>/i
    SUBCLASS_TO = /<(?:SUBCLASS_TO|subclass to):[ ]*(\d+(?:\s*,\s*\d+)*)>/i
    
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
  class <<self; alias load_database_csp load_database; end
  def self.load_database
    load_database_csp
    load_notetags_csp
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_csp
  #--------------------------------------------------------------------------
  def self.load_notetags_csp
    for obj in $data_classes
      next if obj.nil?
      obj.load_notetags_csp
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
  attr_accessor :primary_only
  attr_accessor :subclass_only
  attr_accessor :subclass_to
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_csp
  #--------------------------------------------------------------------------
  def load_notetags_csp
    @primary_only = false
    @subclass_only = false
    @subclass_to = []
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::CLASS::PRIMARY_ONLY
        @primary_only = true
        @subclass_only = false
        @subclass_to = []
      when YEA::REGEXP::CLASS::SUBCLASS_ONLY
        @primary_only = false
        @subclass_only = true
      when YEA::REGEXP::CLASS::SUBCLASS_TO
        @primary_only = false
        @subclass_only = true
        $1.scan(/\d+/).each { |num| 
        @subclass_to.push(num.to_i) if num.to_i > 0 }
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
  # alias method: change_class
  #--------------------------------------------------------------------------
  alias game_actor_change_class_csp change_class
  def change_class(class_id, keep_exp = false)
    return if $data_classes[class_id].subclass_only
    game_actor_change_class_csp(class_id, keep_exp)
    correct_subclass
  end
  
  #--------------------------------------------------------------------------
  # alias method: change_subclass
  #--------------------------------------------------------------------------
  alias game_actor_change_subclass_csp change_subclass
  def change_subclass(class_id)
    return unless subclass_requirements_met?(class_id)
    game_actor_change_subclass_csp(class_id)
  end
  
  #--------------------------------------------------------------------------
  # new method: subclass_requirements_met?
  #--------------------------------------------------------------------------
  def subclass_requirements_met?(class_id)
    subclass = $data_classes[class_id]
    return false if subclass.primary_only
    return subclass_to?(class_id) if subclass.subclass_to != []
    return true
  end
  
  #--------------------------------------------------------------------------
  # new method: subclass_to?
  #--------------------------------------------------------------------------
  def subclass_to?(class_id)
    return true if class_id == 0
    subclass = $data_classes[class_id]
    return false if subclass.nil?
    for class_id in subclass.subclass_to
      return true if class_id == self.class.id
    end
    return false
  end
  
  #--------------------------------------------------------------------------
  # new method: correct_subclass
  #--------------------------------------------------------------------------
  def correct_subclass
    return if @subclass_id == 0
    subclass = $data_classes[@subclass_id]
    return if subclass.nil?
    return if subclass.subclass_to == []
    @subclass_id = 0 if !subclass_to?(@subclass_id)
  end
  
end # Game_Actor

#==============================================================================
# ■ Window_ClassList
#==============================================================================

class Window_ClassList < Window_Selectable
  
  #--------------------------------------------------------------------------
  # alias method: enable?
  #--------------------------------------------------------------------------
  alias window_classlist_enable_csp enable?
  def enable?(item)
    case @command_window.current_symbol
    when :primary
      return false if item.subclass_only
    when :subclass
      return false if item.primary_only
      return @actor.subclass_to?(item.id) if item.subclass_to != []
    end
    return window_classlist_enable_csp(item)
  end
  
end # Window_ClassList

end # $imported["YEA-ClassSystem"]

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================