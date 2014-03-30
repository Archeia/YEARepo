#==============================================================================
# 
# ▼ Yanfly Engine Ace - Convert Damage v1.02
# -- Last Updated: 2012.01.23
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-ConvertDamage"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2013.02.17 - Bug fixes.
# 2012.01.23 - Compatibility Update: Doppelganger
# 2011.12.21 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script gives actors, classes, equipment, enemies, and states passive
# convert damage HP/MP traits. By dealing physical or magical damage (dependant
# on the type of attack), attackers may recover HP or MP depending on what
# kinds of convert damage types they have.
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
# <convert hp physical: +x%>
# <convert hp physical: -x%>
# Converts any physical damage dealt to recover HP by x% of the damage dealt.
# Bonus converted damage rates are additive. There will be no effects if HP
# to be healed is 0 or below.
# 
# <convert hp magical: +x%>
# <convert hp magical: -x%>
# Converts any magical damage dealt to recover HP by x% of the damage dealt.
# Bonus converted damage rates are additive. There will be no effects if HP
# to be healed is 0 or below.
# 
# <convert mp physical: +x%>
# <convert mp physical: -x%>
# Converts any physical damage dealt to recover MP by x% of the damage dealt.
# Bonus converted damage rates are additive. There will be no effects if MP
# to be healed is 0 or below.
# 
# <convert mp magical: +x%>
# <convert mp magical: -x%>
# Converts any magical damage dealt to recover MP by x% of the damage dealt.
# Bonus converted damage rates are additive. There will be no effects if MP
# to be healed is 0 or below.
# 
# <anticonvert hp physical>
# <anticonvert hp magical>
# <anticonvert mp physical>
# <anticonvert mp magical>
# Prevents attackers from converting damage of those particular types. All
# converted recovery effects of that type will be reduced to 0.
# 
# -----------------------------------------------------------------------------
# Class Notetags - These notetags go in the class notebox in the database.
# -----------------------------------------------------------------------------
# <convert hp physical: +x%>
# <convert hp physical: -x%>
# Converts any physical damage dealt to recover HP by x% of the damage dealt.
# Bonus converted damage rates are additive. There will be no effects if HP
# to be healed is 0 or below.
# 
# <convert hp magical: +x%>
# <convert hp magical: -x%>
# Converts any magical damage dealt to recover HP by x% of the damage dealt.
# Bonus converted damage rates are additive. There will be no effects if HP
# to be healed is 0 or below.
# 
# <convert mp physical: +x%>
# <convert mp physical: -x%>
# Converts any physical damage dealt to recover MP by x% of the damage dealt.
# Bonus converted damage rates are additive. There will be no effects if MP
# to be healed is 0 or below.
# 
# <convert mp magical: +x%>
# <convert mp magical: -x%>
# Converts any magical damage dealt to recover MP by x% of the damage dealt.
# Bonus converted damage rates are additive. There will be no effects if MP
# to be healed is 0 or below.
# 
# <anticonvert hp physical>
# <anticonvert hp magical>
# <anticonvert mp physical>
# <anticonvert mp magical>
# Prevents attackers from converting damage of those particular types. All
# converted recovery effects of that type will be reduced to 0.
# 
# -----------------------------------------------------------------------------
# Skill Notetags - These notetags go in the skills notebox in the database.
# -----------------------------------------------------------------------------
# <no convert>
# Prevents any kind of converted damage effects from being applied when this
# skill is used.
# 
# -----------------------------------------------------------------------------
# Item Notetags - These notetags go in the items notebox in the database.
# -----------------------------------------------------------------------------
# <no convert>
# Prevents any kind of converted damage effects from being applied when this
# item is used.
# 
# -----------------------------------------------------------------------------
# Weapon Notetags - These notetags go in the weapons notebox in the database.
# -----------------------------------------------------------------------------
# <convert hp physical: +x%>
# <convert hp physical: -x%>
# Converts any physical damage dealt to recover HP by x% of the damage dealt.
# Bonus converted damage rates are additive. There will be no effects if HP
# to be healed is 0 or below.
# 
# <convert hp magical: +x%>
# <convert hp magical: -x%>
# Converts any magical damage dealt to recover HP by x% of the damage dealt.
# Bonus converted damage rates are additive. There will be no effects if HP
# to be healed is 0 or below.
# 
# <convert mp physical: +x%>
# <convert mp physical: -x%>
# Converts any physical damage dealt to recover MP by x% of the damage dealt.
# Bonus converted damage rates are additive. There will be no effects if MP
# to be healed is 0 or below.
# 
# <convert mp magical: +x%>
# <convert mp magical: -x%>
# Converts any magical damage dealt to recover MP by x% of the damage dealt.
# Bonus converted damage rates are additive. There will be no effects if MP
# to be healed is 0 or below.
# 
# <anticonvert hp physical>
# <anticonvert hp magical>
# <anticonvert mp physical>
# <anticonvert mp magical>
# Prevents attackers from converting damage of those particular types. All
# converted recovery effects of that type will be reduced to 0.
# 
# -----------------------------------------------------------------------------
# Armour Notetags - These notetags go in the armours notebox in the database.
# -----------------------------------------------------------------------------
# <convert hp physical: +x%>
# <convert hp physical: -x%>
# Converts any physical damage dealt to recover HP by x% of the damage dealt.
# Bonus converted damage rates are additive. There will be no effects if HP
# to be healed is 0 or below.
# 
# <convert hp magical: +x%>
# <convert hp magical: -x%>
# Converts any magical damage dealt to recover HP by x% of the damage dealt.
# Bonus converted damage rates are additive. There will be no effects if HP
# to be healed is 0 or below.
# 
# <convert mp physical: +x%>
# <convert mp physical: -x%>
# Converts any physical damage dealt to recover MP by x% of the damage dealt.
# Bonus converted damage rates are additive. There will be no effects if MP
# to be healed is 0 or below.
# 
# <convert mp magical: +x%>
# <convert mp magical: -x%>
# Converts any magical damage dealt to recover MP by x% of the damage dealt.
# Bonus converted damage rates are additive. There will be no effects if MP
# to be healed is 0 or below.
# 
# <anticonvert hp physical>
# <anticonvert hp magical>
# <anticonvert mp physical>
# <anticonvert mp magical>
# Prevents attackers from converting damage of those particular types. All
# converted recovery effects of that type will be reduced to 0.
# 
# -----------------------------------------------------------------------------
# Enemy Notetags - These notetags go in the enemies notebox in the database.
# -----------------------------------------------------------------------------
# <convert hp physical: +x%>
# <convert hp physical: -x%>
# Converts any physical damage dealt to recover HP by x% of the damage dealt.
# Bonus converted damage rates are additive. There will be no effects if HP
# to be healed is 0 or below.
# 
# <convert hp magical: +x%>
# <convert hp magical: -x%>
# Converts any magical damage dealt to recover HP by x% of the damage dealt.
# Bonus converted damage rates are additive. There will be no effects if HP
# to be healed is 0 or below.
# 
# <convert mp physical: +x%>
# <convert mp physical: -x%>
# Converts any physical damage dealt to recover MP by x% of the damage dealt.
# Bonus converted damage rates are additive. There will be no effects if MP
# to be healed is 0 or below.
# 
# <convert mp magical: +x%>
# <convert mp magical: -x%>
# Converts any magical damage dealt to recover MP by x% of the damage dealt.
# Bonus converted damage rates are additive. There will be no effects if MP
# to be healed is 0 or below.
# 
# <anticonvert hp physical>
# <anticonvert hp magical>
# <anticonvert mp physical>
# <anticonvert mp magical>
# Prevents attackers from converting damage of those particular types. All
# converted recovery effects of that type will be reduced to 0.
# 
# -----------------------------------------------------------------------------
# State Notetags - These notetags go in the states notebox in the database.
# -----------------------------------------------------------------------------
# <convert hp physical: +x%>
# <convert hp physical: -x%>
# Converts any physical damage dealt to recover HP by x% of the damage dealt.
# Bonus converted damage rates are additive. There will be no effects if HP
# to be healed is 0 or below.
# 
# <convert hp magical: +x%>
# <convert hp magical: -x%>
# Converts any magical damage dealt to recover HP by x% of the damage dealt.
# Bonus converted damage rates are additive. There will be no effects if HP
# to be healed is 0 or below.
# 
# <convert mp physical: +x%>
# <convert mp physical: -x%>
# Converts any physical damage dealt to recover MP by x% of the damage dealt.
# Bonus converted damage rates are additive. There will be no effects if MP
# to be healed is 0 or below.
# 
# <convert mp magical: +x%>
# <convert mp magical: -x%>
# Converts any magical damage dealt to recover MP by x% of the damage dealt.
# Bonus converted damage rates are additive. There will be no effects if MP
# to be healed is 0 or below.
# 
# <anticonvert hp physical>
# <anticonvert hp magical>
# <anticonvert mp physical>
# <anticonvert mp magical>
# Prevents attackers from converting damage of those particular types. All
# converted recovery effects of that type will be reduced to 0.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
# For maximum compatibility with Yanfly Engine Ace - Ace Battle Engine, place
# this script under Ace Battle Engine.
# 
#==============================================================================

module YEA
  module CONVERT_DAMAGE
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Limit Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Adjust the maximum converted damage rate for dealing damage (so that an
    # attacker cannot gain huge amounts of recovery).
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    MAXIMUM_RATE = 1.0   # Maximum gain from dealing damage.
    
  end # CONVERT_DAMAGE
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module BASEITEM
    
    CONVERT_DMG = /<(?:CONVERT|convert)[ ](.*)[ ](.*):[ ]([\+\-]\d+)([%％])>/i
    ANTICONVERT = /<(?:ANTI_CONVERT|anti convert|anticonvert)[ ](.*)[ ](.*)>/i
    
  end # BASEITEM
  module USABLEITEM
    
    NO_CONVERT = /<(?:NO_CONVERT|no convert)>/i
    
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
  class <<self; alias load_database_convertdmg load_database; end
  def self.load_database
    load_database_convertdmg
    load_notetags_convertdmg
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_convertdmg
  #--------------------------------------------------------------------------
  def self.load_notetags_convertdmg
    groups = [$data_actors, $data_classes, $data_weapons, $data_armors,
      $data_enemies, $data_states, $data_skills, $data_items]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_convertdmg
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
  attr_accessor :convert_dmg
  attr_accessor :anticonvert
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_convertdmg
  #--------------------------------------------------------------------------
  def load_notetags_convertdmg
    @convert_dmg ={
      :hp_physical => 0.0,
      :hp_magical  => 0.0,
      :mp_physical => 0.0,
      :mp_magical  => 0.0,
    } # Do not remove this.
    @anticonvert = []
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::BASEITEM::CONVERT_DMG
        case $1.upcase
        when "HP"
          case $2.upcase
          when "PHYSICAL"; type = :hp_physical
          when "MAGICAL";  type = :hp_magical
          else; next
          end
        when "MP"
          case $2.upcase
          when "PHYSICAL"; type = :mp_physical
          when "MAGICAL";  type = :mp_magical
          else; next
          end
        else; next
        end
        @convert_dmg[type] = $3.to_i * 0.01
      #---
      when YEA::REGEXP::BASEITEM::ANTICONVERT
        case $1.upcase
        when "HP"
          case $2.upcase
          when "PHYSICAL"; type = :hp_physical
          when "MAGICAL";  type = :hp_magical
          else; next
          end
        when "MP"
          case $2.upcase
          when "PHYSICAL"; type = :mp_physical
          when "MAGICAL";  type = :mp_magical
          else; next
          end
        else; next
        end
        @anticonvert.push(type)
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::BaseItem

#==============================================================================
# ■ RPG::UsableItem
#==============================================================================

class RPG::UsableItem < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :no_convert
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_convertdmg
  #--------------------------------------------------------------------------
  def load_notetags_convertdmg
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::USABLEITEM::NO_CONVERT
        @no_convert = true
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::UsableItem

#==============================================================================
# ■ Game_BattlerBase
#==============================================================================

class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # new method: convert_dmg_rate
  #--------------------------------------------------------------------------
  def convert_dmg_rate(type)
    n = 0.0
    if actor?
      n += self.actor.convert_dmg[type]
      n += self.class.convert_dmg[type]
      for equip in equips
        next if equip.nil?
        n += equip.convert_dmg[type]
      end
    else
      n += self.enemy.convert_dmg[type]
      if $imported["YEA-Doppelganger"] && !self.class.nil?
        n += self.class.convert_dmg[type]
      end
    end
    for state in states
      next if state.nil?
      n += state.convert_dmg[type]
    end
    max_rate = YEA::CONVERT_DAMAGE::MAXIMUM_RATE
    return [[n, max_rate].min, -max_rate].max
  end
  
  #--------------------------------------------------------------------------
  # new method: anti_convert?
  #--------------------------------------------------------------------------
  def anti_convert?(type)
    if actor?
      return true if self.actor.anticonvert.include?(type)
      return true if self.class.anticonvert.include?(type)
      for equip in equips
        next if equip.nil?
        return true if equip.anticonvert.include?(type)
      end
    else
      return true if self.enemy.anticonvert.include?(type)
    end
    for state in states
      next if state.nil?
      return true if state.anticonvert.include?(type)
    end
    return false
  end
  
end # Game_BattlerBase

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias method: execute_damage
  #--------------------------------------------------------------------------
  alias game_battler_execute_damage_convertdmg execute_damage
  def execute_damage(user)
    apply_vampire_effects(user)
    game_battler_execute_damage_convertdmg(user)
  end
  
  #--------------------------------------------------------------------------
  # new method: apply_vampire_effect
  #--------------------------------------------------------------------------
  def apply_vampire_effects(user)
    return unless $game_party.in_battle
    return unless @result.hp_damage > 0 || @result.mp_damage > 0
    return if user.current_action.nil?
    action = user.current_action.item
    return if action.no_convert
    apply_convert_physical_effect(user) if action.physical?
    apply_convert_magical_effect(user) if action.magical?
  end
  
  #--------------------------------------------------------------------------
  # new method: apply_convert_physical_effect
  #--------------------------------------------------------------------------
  def apply_convert_physical_effect(user)
    hp_rate = user.convert_dmg_rate(:hp_physical)
    hp_rate = 0 if anti_convert?(:hp_physical)
    hp_healed = (@result.hp_damage * hp_rate).to_i
    mp_rate = user.convert_dmg_rate(:mp_physical)
    mp_rate = 0 if anti_convert?(:mp_physical)
    mp_healed = (@result.mp_damage * mp_rate).to_i
    if hp_healed != 0
      user.hp += hp_healed
      make_ace_battle_engine_convert_hp_popup(user, hp_healed)
    end
    if mp_healed != 0
      user.mp += mp_healed
      make_ace_battle_engine_convert_mp_popup(user, mp_healed)
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: apply_convert_magical_effect
  #--------------------------------------------------------------------------
  def apply_convert_magical_effect(user)
    hp_rate = user.convert_dmg_rate(:hp_magical)
    hp_rate = 0 if anti_convert?(:hp_magical)
    hp_healed = (@result.hp_damage * hp_rate).to_i
    mp_rate = user.convert_dmg_rate(:mp_magical)
    mp_rate = 0 if anti_convert?(:mp_magical)
    mp_healed = (@result.mp_damage * mp_rate).to_i
    if hp_healed != 0
      user.hp += hp_healed
      make_ace_battle_engine_convert_hp_popup(user, hp_healed)
    end
    if mp_healed != 0
      user.mp += mp_healed
      make_ace_battle_engine_convert_mp_popup(user, mp_healed)
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: make_ace_battle_engine_convert_hp_popup
  #--------------------------------------------------------------------------
  def make_ace_battle_engine_convert_hp_popup(user, hp_healed)
    return unless $imported["YEA-BattleEngine"]
    setting = hp_healed > 0 ? :hp_heal : :hp_dmg
    rules = hp_healed > 0 ? "HP_HEAL" : "HP_DMG"
    value = hp_healed.abs
    text = sprintf(YEA::BATTLE::POPUP_SETTINGS[setting], value.group)
    user.create_popup(text, rules)
  end
  
  #--------------------------------------------------------------------------
  # new method: make_ace_battle_engine_convert_mp_popup
  #--------------------------------------------------------------------------
  def make_ace_battle_engine_convert_mp_popup(user, mp_healed)
    return unless $imported["YEA-BattleEngine"]
    setting = mp_healed > 0 ? :mp_heal : :mp_dmg
    rules = mp_healed > 0 ? "MP_HEAL" : "MP_DMG"
    value = mp_healed.abs
    text = sprintf(YEA::BATTLE::POPUP_SETTINGS[setting], value.group)
    user.create_popup(text, rules)
  end
  
end # Game_Battler

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================