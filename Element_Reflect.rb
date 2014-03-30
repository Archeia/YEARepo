#==============================================================================
# 
# ▼ Yanfly Engine Ace - Element Reflect v1.01
# -- Last Updated: 2012.01.23
# -- Level: Normal, Hard
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-ElementReflect"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.23 - Compatibility Update: Doppelganger
# 2011.12.14 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# The ability to reflect magic attacks already exists in RPG Maker VX Ace by
# default. However, the ability to reflect skills based on their element type
# does not exist. This script adds the ability to reflect skills back to the
# caster if the skill is a particular element type and provides a percent bonus
# to reflect it back at, too.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Actor Notetags - These notetags go in the actors notebox in the database.
# -----------------------------------------------------------------------------
# <element reflect x: +y%>
# <element reflect x: -y%>
# This tag causes the element x to reflect at a bonus y% rate. The reflect rate
# only applies if element x is involved with the skill used. To reflect more
# than one type of element, use multiple of this tag.
# 
# -----------------------------------------------------------------------------
# Class Notetags - These notetags go in the class notebox in the database.
# -----------------------------------------------------------------------------
# <element reflect x: +y%>
# <element reflect x: -y%>
# This tag causes the element x to reflect at a bonus y% rate. The reflect rate
# only applies if element x is involved with the skill used. To reflect more
# than one type of element, use multiple of this tag.
# 
# -----------------------------------------------------------------------------
# Weapon Notetags - These notetags go in the weapons notebox in the database.
# -----------------------------------------------------------------------------
# <element reflect x: +y%>
# <element reflect x: -y%>
# This tag causes the element x to reflect at a bonus y% rate. The reflect rate
# only applies if element x is involved with the skill used. To reflect more
# than one type of element, use multiple of this tag.
# 
# -----------------------------------------------------------------------------
# Armour Notetags - These notetags go in the armours notebox in the database.
# -----------------------------------------------------------------------------
# <element reflect x: +y%>
# <element reflect x: -y%>
# This tag causes the element x to reflect at a bonus y% rate. The reflect rate
# only applies if element x is involved with the skill used. To reflect more
# than one type of element, use multiple of this tag.
# 
# -----------------------------------------------------------------------------
# Enemy Notetags - These notetags go in the enemies notebox in the database.
# -----------------------------------------------------------------------------
# <element reflect x: +y%>
# <element reflect x: -y%>
# This tag causes the element x to reflect at a bonus y% rate. The reflect rate
# only applies if element x is involved with the skill used. To reflect more
# than one type of element, use multiple of this tag.
# 
# -----------------------------------------------------------------------------
# State Notetags - These notetags go in the states notebox in the database.
# -----------------------------------------------------------------------------
# <element reflect x: +y%>
# <element reflect x: -y%>
# This tag causes the element x to reflect at a bonus y% rate. The reflect rate
# only applies if element x is involved with the skill used. To reflect more
# than one type of element, use multiple of this tag.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
# This script also works with YEA - Ace Battle Engine v1.00+. To ensure it has
# the best possible compatibility, place this script below Ace Battle Engine.
# 
#==============================================================================

module YEA
  module ELEMENT_REFLECT
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Visual Reflect Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These settings affect reflected attacks and how they work. You can set
    # an animation to run whenever a reflected magic attack occurs successful.
    # If you don't want an animation to occur, set it to zero.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    REFLECTOR_ANIMATION_ID = 94     # Animation ID used for magic reflect.
    PLAY_ANIMATION_CASTER  = true   # Play the reflected skill ani on caster?
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Ace Battle Engine Popup -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # For those with Ace Battle Engine, a popup can occur indicating that the
    # skill/item is reflected. Adjust the popup settings here.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    POPUP_TEXT = "REFLECT"      # Text that appears when reflected.
    POPUP_RULE = "NEGATIVE"     # Popup rule used.
    
  end # ELEMENT_REFLECT
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module BASEITEM
    
    ELE_RFL = 
      /<(?:ELEMENT_REFLECT|element reflect)[ ](\d+):[ ]([\+\-]\d+)([%％])>/i
    
  end # BASEITEM
  end # REGEXP
end # YEA

#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_erfl load_database; end
  def self.load_database
    load_database_erfl
    load_notetags_erfl
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_erfl
  #--------------------------------------------------------------------------
  def self.load_notetags_erfl
    groups = [$data_actors, $data_classes, $data_weapons, $data_armors,
      $data_enemies, $data_states]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_erfl
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
  attr_accessor :element_reflect
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_erfl
  #--------------------------------------------------------------------------
  def load_notetags_erfl
    @element_reflect = {}
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::BASEITEM::ELE_RFL
        @element_reflect[$1.to_i] = $2.to_i * 0.01
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::BaseItem

#==============================================================================
# ■ Game_BattlerBase
#==============================================================================

class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # new method: element_reflect_rate
  #--------------------------------------------------------------------------
  def element_reflect_rate(element_id)
    n = 0.0
    if actor?
      if self.actor.element_reflect.include?(element_id)
        n += self.actor.element_reflect[element_id]
      end
      if self.class.element_reflect.include?(element_id)
        n += self.class.element_reflect[element_id]
      end
      for equip in equips
        next if equip.nil?
        next unless equip.element_reflect.include?(element_id)
        n += equip.element_reflect[element_id] 
      end
    else
      if self.enemy.element_reflect.include?(element_id)
        n += self.enemy.element_reflect[element_id]
      end
      if $imported["YEA-Doppelganger"] && !self.class.nil?
        if self.class.element_reflect.include?(element_id)
          n += self.class.element_reflect[element_id]
        end
      end
    end
    for state in states
      next if state.nil?
      next unless state.element_reflect.include?(element_id)
      n += state.element_reflect[element_id]
    end
    return n
  end
  
end # Game_BattlerBase

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias method: item_mrf
  #--------------------------------------------------------------------------
  alias game_battler_item_mrf_erfl item_mrf
  def item_mrf(user, item)
    result = game_battler_item_mrf_erfl(user, item)
    result += element_reflect_rate(item.damage.element_id)
    return result
  end
  
end # Game_Battler

#==============================================================================
# ■ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: invoke_magic_reflection
  #--------------------------------------------------------------------------
  alias scene_battle_invoke_magic_reflection_erfl invoke_magic_reflection
  def invoke_magic_reflection(target, item)
    show_reflected_magic_animation(target, item)
    scene_battle_invoke_magic_reflection_erfl(target, item)
    wait_for_animation
  end
  
  #--------------------------------------------------------------------------
  # new method: show_reflected_magic_animation
  #--------------------------------------------------------------------------
  def show_reflected_magic_animation(target, item)
    show_reflected_magic_popup(target)
    if YEA::ELEMENT_REFLECT::REFLECTOR_ANIMATION_ID > 0
      target.animation_id = YEA::ELEMENT_REFLECT::REFLECTOR_ANIMATION_ID
      target.animation_mirror = false
    end
    if YEA::ELEMENT_REFLECT::PLAY_ANIMATION_CASTER
      @subject.animation_id = item.animation_id
      @subject.animation_mirror = true
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: show_reflected_magic_popup
  #--------------------------------------------------------------------------
  def show_reflected_magic_popup(target)
    return unless $imported["YEA-BattleEngine"]
    text = YEA::ELEMENT_REFLECT::POPUP_TEXT
    rule = YEA::ELEMENT_REFLECT::POPUP_RULE
    target.create_popup(text, rule)
  end
  
end # Scene_Battle

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================