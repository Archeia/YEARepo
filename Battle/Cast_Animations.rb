#==============================================================================
# 
# ▼ Yanfly Engine Ace - Cast Animations v1.00
# -- Last Updated: 2011.12.18
# -- Level: Easy, Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-CastAnimations"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.18 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Casting animations are actually great visual tools to help players recognize
# and acknowledge which battler on the screen is currently taking an action.
# The other thing is that casting animations also provide eye candy. This
# script provides easy access to generate cast animations and to allow even
# separate animations for each individual skill.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Skill Notetags - These notetags go in the skills notebox in the database.
# -----------------------------------------------------------------------------
# <cast ani: x>
# Sets the casting animation for this skill to be x. This animation will always
# be played before this skill is used. If this tag isn't used, the default cast
# animation will be the one set by the script's module.
# 
# <no cast ani>
# Sets the casting animation for this skill to be 0, making it so that no cast
# animation will be played before this skill is used.
# 
# -----------------------------------------------------------------------------
# Item Notetags - These notetags go in the items notebox in the database.
# -----------------------------------------------------------------------------
# <cast ani: x>
# Sets the casting animation for this item to be x. This animation will always
# be played before this item is used. If this tag isn't used, the default cast
# animation will be the one set by the script's module.
# 
# <no cast ani>
# Sets the casting animation for this item to be 0, making it so that no cast
# animation will be played before this item is used.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module CAST_ANIMATIONS
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Default Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These settings set the default casting animations for all skills that do
    # not use a unique casting animation. If you don't want any of the settings
    # below to have a cast animation, set it to 0 to disable it.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    NORMAL_ATTACK_ANI  = 0     # Default animation for skill #1.
    DEFEND_ANIMATION   = 0     # Default animation for skill #2.
    PHYSICAL_ANIMATION = 81    # Default animation for physical skills.
    MAGICAL_ANIMATION  = 43    # Default animation for magical skills.
    ITEM_USE_ANIMATION = 0     # Default animation for using items.
    
  end # CAST_ANIMATIONS
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module USABLEITEM
    
    CAST_ANI    = /<(?:CAST_ANI|cast ani|cast animation):[ ](\d+)>/i
    NO_CAST_ANI = /<(?:NO_CAST_ANI|no cast ani|no cast animation)>/i
    
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
  class <<self; alias load_database_cani load_database; end
  def self.load_database
    load_database_cani
    load_notetags_cani
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_cani
  #--------------------------------------------------------------------------
  def self.load_notetags_cani
    groups = [$data_items, $data_skills]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_cani
      end
    end
  end
  
end # DataManager

#==============================================================================
# ■ RPG::UsableItem
#==============================================================================

class RPG::UsableItem < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variable
  #--------------------------------------------------------------------------
  attr_accessor :cast_ani
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_cani
  #--------------------------------------------------------------------------
  def load_notetags_cani
    @cast_ani = 0
    if self.is_a?(RPG::Skill)
      if @id == 1
        @cast_ani = YEA::CAST_ANIMATIONS::NORMAL_ATTACK_ANI
      elsif @id == 2
        @cast_ani = YEA::CAST_ANIMATIONS::DEFEND_ANIMATION
      elsif self.physical?
        @cast_ani = YEA::CAST_ANIMATIONS::PHYSICAL_ANIMATION
      elsif self.magical?
        @cast_ani = YEA::CAST_ANIMATIONS::MAGICAL_ANIMATION
      end
    else
      @cast_ani = YEA::CAST_ANIMATIONS::ITEM_USE_ANIMATION
    end
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::USABLEITEM::CAST_ANI
        @cast_ani = $1.to_i
      when YEA::REGEXP::USABLEITEM::NO_CAST_ANI
        @cast_ani = 0
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::UsableItem

#==============================================================================
# ■ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: use_item
  #--------------------------------------------------------------------------
  alias scene_battle_use_item_cani use_item
  def use_item
    process_casting_animation unless $imported["YEA-BattleEngine"]
    scene_battle_use_item_cani
  end
  
  #--------------------------------------------------------------------------
  # new method: process_casting_animation
  #--------------------------------------------------------------------------
  def process_casting_animation
    item = @subject.current_action.item
    cast_ani = item.cast_ani
    return if cast_ani <= 0
    show_animation([@subject], cast_ani)
  end
  
end # Scene_Battle

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================