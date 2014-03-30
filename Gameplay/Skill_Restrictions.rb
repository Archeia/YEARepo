#==============================================================================
# 
# ▼ Yanfly Engine Ace - Skill Restrictions v1.02
# -- Last Updated: 2012.01.23
# -- Level: Normal, Hard, Lunatic
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-SkillRestrictions"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.23 - Compatibility Update: Doppelganger
# 2011.12.12 - Started Script and Finished.
#            - Added cooldown altering notetags for items.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Sometimes good game balance depends on restriction mechanics. Of these
# mechanics include skill cooldowns, warmups, and the amount of times a skill
# can be used (limited uses). Included in this script are features also to
# lock cooldowns, reduce cooldown rates, change cooldown values for skills,
# skill types, and more. If this isn't enough restriction power, switches may
# be used to restrict skills from being used as well as even code.
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
# <cooldown lock>
# A battler afflicted with cooldown lock will not have cooldowns count down
# every turn until the cooldown lock is removed.
# 
# <cooldown rate: x%>
# When cooldowns are applied from using skills in battle, the cooldown rate can
# reduce or increase the finalized amount of turns a battler would need to wait
# before being able to use that skill again.
# 
# <warmup rate: x%>
# Lowers/Raises the amount of turns needed to pass in battle before the warmup
# skills become available for usage.
# 
# -----------------------------------------------------------------------------
# Class Notetags - These notetags go in the class notebox in the database.
# -----------------------------------------------------------------------------
# <cooldown lock>
# A battler afflicted with cooldown lock will not have cooldowns count down
# every turn until the cooldown lock is removed.
# 
# <cooldown rate: x%>
# When cooldowns are applied from using skills in battle, the cooldown rate can
# reduce or increase the finalized amount of turns a battler would need to wait
# before being able to use that skill again.
# 
# <warmup rate: x%>
# Lowers/Raises the amount of turns needed to pass in battle before the warmup
# skills become available for usage.
# 
# -----------------------------------------------------------------------------
# Skill Notetags - These notetags go in the skills notebox in the database.
# -----------------------------------------------------------------------------
# <cooldown: x>
# Causes the skill to have a cooldown of x once it's used in battle. Skills
# with cooldowns cannot be used again until cooldown reaches 0 or until the
# battle is over.
# 
# <change cooldown: +x>
# <change cooldown: -x>
# This will cause the target's cooldowns for every skill to increase by x or
# decrease by x. This selects skills indiscriminately.
# 
# <skill cooldown x: +y>
# <skill cooldown x: -y>
# This will cause the target's specific skill x to receive a change in cooldown
# by either an increase or decrease of y amount.
# 
# <stype cooldown x: +y>
# <stype cooldown x: -y>
# This will cause all of the skills with skill type x to have its cooldowns
# changed by y amount. +y increases cooldown turns while -y decreases turns.
# 
# <limited uses: x>
# This will allow the skill to only be usable x times throughout the course of
# battle. Once the skill is used x times, it is disabled until the battle is
# over. This effect only takes place during battle.
# 
# <warmup: x>
# Causes the skill to be sealed until the x turns pass in battle. There's no
# way to speed up a warmup manually with the exception of warmup rates.
# 
# <restrict if switch: x>
# This will restrict the skill if switch x is ON. If switch x is OFF, this
# skill will no longer be restricted.
# 
# <restrict any switch: x>
# <restrict any switch: x, x>
# This will restrict the skill if any of the x switches are ON. If all of them
# are off, then the skill will not be restricted.
# 
# <restrict all switch: x>
# <restrict all switch: x, x>
# This will restrict the skill if all of the x switches are ON. If any of them
# are off, then the skill will not be restricted.
# 
# <restrict eval>
#  string
#  string
# </restrict eval>
# For the more advanced users, replace string with code to determine whether
# or not the skill is restricted. If multiple lines are used, they are all
# considered part of the same line.
# 
# -----------------------------------------------------------------------------
# Item Notetags - These notetags go in the items notebox in the database.
# -----------------------------------------------------------------------------
# <change cooldown: +x>
# <change cooldown: -x>
# This will cause the target's cooldowns for every skill to increase by x or
# decrease by x. This selects skills indiscriminately.
# 
# <skill cooldown x: +y>
# <skill cooldown x: -y>
# This will cause the target's specific skill x to receive a change in cooldown
# by either an increase or decrease of y amount.
# 
# <stype cooldown x: +y>
# <stype cooldown x: -y>
# This will cause all of the skills with skill type x to have its cooldowns
# changed by y amount. +y increases cooldown turns while -y decreases turns.
# 
# -----------------------------------------------------------------------------
# Weapon Notetags - These notetags go in the weapons notebox in the database.
# -----------------------------------------------------------------------------
# <cooldown lock>
# A battler afflicted with cooldown lock will not have cooldowns count down
# every turn until the cooldown lock is removed.
# 
# <cooldown rate: x%>
# When cooldowns are applied from using skills in battle, the cooldown rate can
# reduce or increase the finalized amount of turns a battler would need to wait
# before being able to use that skill again.
# 
# <warmup rate: x%>
# Lowers/Raises the amount of turns needed to pass in battle before the warmup
# skills become available for usage.
# 
# -----------------------------------------------------------------------------
# Armour Notetags - These notetags go in the armours notebox in the database.
# -----------------------------------------------------------------------------
# <cooldown lock>
# A battler afflicted with cooldown lock will not have cooldowns count down
# every turn until the cooldown lock is removed.
# 
# <cooldown rate: x%>
# When cooldowns are applied from using skills in battle, the cooldown rate can
# reduce or increase the finalized amount of turns a battler would need to wait
# before being able to use that skill again.
# 
# <warmup rate: x%>
# Lowers/Raises the amount of turns needed to pass in battle before the warmup
# skills become available for usage.
# 
# -----------------------------------------------------------------------------
# Enemy Notetags - These notetags go in the enemies notebox in the database.
# -----------------------------------------------------------------------------
# <cooldown lock>
# A battler afflicted with cooldown lock will not have cooldowns count down
# every turn until the cooldown lock is removed.
# 
# <cooldown rate: x%>
# When cooldowns are applied from using skills in battle, the cooldown rate can
# reduce or increase the finalized amount of turns a battler would need to wait
# before being able to use that skill again.
# 
# <warmup rate: x%>
# Lowers/Raises the amount of turns needed to pass in battle before the warmup
# skills become available for usage.
# 
# -----------------------------------------------------------------------------
# State Notetags - These notetags go in the states notebox in the database.
# -----------------------------------------------------------------------------
# <cooldown lock>
# A battler afflicted with cooldown lock will not have cooldowns count down
# every turn until the cooldown lock is removed.
# 
# <cooldown rate: x%>
# When cooldowns are applied from using skills in battle, the cooldown rate can
# reduce or increase the finalized amount of turns a battler would need to wait
# before being able to use that skill again.
# 
# <warmup rate: x%>
# Lowers/Raises the amount of turns needed to pass in battle before the warmup
# skills become available for usage.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module SKILL_RESTRICT
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Cooldown Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Skills with cooldowns cannot be used for some number of turns. Adjust the
    # settings here on how cooldowns appear in the menu. Cooldowns are only
    # applied in battle.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    COOLDOWN_COLOUR = 6          # Colour used from "Window" skin.
    COOLDOWN_SIZE   = 20         # Font size used for cooldowns.
    COOLDOWN_SUFFIX = "%sCD"     # Suffix used for cooldowns.
    COOLDOWN_ICON   = 0          # Icon used for cooldowns. Set 0 to disable.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Warmup Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Skills with warmups are unaffected by cooldowns. They become available to
    # use after a certain number of turns have passed. Warmups are only applied
    # in battle. Cooldown Rates do not affect warmups but Warmup Rates do.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    WARMUP_COLOUR   = 5          # Colour used from "Window" skin.
    WARMUP_SIZE     = 20         # Font size used for warmups.
    WARMUP_SUFFIX   = "%sWU"     # Suffix used for warmups.
    WARMUP_ICON     = 0          # Icon used for warmups. Set 0 to disable.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Limited Use Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Some skills have limited uses per battle. These limited uses are reset
    # at the start and end of each battle and do not apply when used outside of
    # battle. There are no effects that can affect limited uses.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    LIMITED_COLOUR  = 8          # Colour used from "Window" skin.
    LIMITED_SIZE    = 16         # Font size used for used up.
    LIMITED_TEXT    = "Used"     # Text used for used up.
    LIMITED_ICON    = 0          # Icon used for used up. Set 0 to disable.
    
  end # SKILL_RESTRICT
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module BASEITEM
    
    COOLDOWN_RATE = /<(?:COOL_DOWN_RATE|cooldown rate):[ ](\d+)([%％])>/i
    COOLDOWN_LOCK = /<(?:COOL_DOWN_LOCK|cooldown lock)>/i
    WARMUP_RATE   = /<(?:WARM_UP_RATE|warmup rate):[ ](\d+)([%％])>/i
    
  end # BASEITEM
  module SKILL
    
    COOLDOWN = /<(?:COOL_DOWN|cooldown):[ ](\d+)>/i
    WARMUP   = /<(?:WARM_UP|warmup):[ ](\d+)>/i
    LIMITED_USES = /<(?:LIMITED_USES|limited uses):[ ](\d+)>/i
    
    CHANGE_COOLDOWN = /<(?:CHANGE_COOL_DOWN|change cooldown):[ ]([\+\-]\d+)>/i
    STYPE_COOLDOWN =
      /<(?:STYPE_COOL_DOWN|stype cooldown)[ ](\d+):[ ]([\+\-]\d+)>/i
    SKILL_COOLDOWN =
      /<(?:SKILL_COOL_DOWN|skill cooldown)[ ](\d+):[ ]([\+\-]\d+)>/i
      
    RESTRICT_IF_SWITCH  = 
      /<(?:RESTRICT_IF_SWITCH|restrict if switch):[ ](\d+)>/i
    RESTRICT_ANY_SWITCH =
      /<(?:RESTRICT_ANY_SWITCH|restrict any switch):[ ]*(\d+(?:\s*,\s*\d+)*)>/i
    RESTRICT_ALL_SWITCH =
      /<(?:RESTRICT_ALL_SWITCH|restrict all switch):[ ]*(\d+(?:\s*,\s*\d+)*)>/i
    
    RESTRICT_EVAL_ON  = /<(?:RESTRICT_EVAL|restrict eval)>/i
    RESTRICT_EVAL_OFF = /<\/(?:RESTRICT_EVAL|restrict eval)>/i
    
  end # SKILL
  module ITEM
    
    CHANGE_COOLDOWN = /<(?:CHANGE_COOL_DOWN|change cooldown):[ ]([\+\-]\d+)>/i
    STYPE_COOLDOWN =
      /<(?:STYPE_COOL_DOWN|stype cooldown)[ ](\d+):[ ]([\+\-]\d+)>/i
    SKILL_COOLDOWN =
      /<(?:SKILL_COOL_DOWN|skill cooldown)[ ](\d+):[ ]([\+\-]\d+)>/i
    
  end # ITEM
  end # REGEXP
end # YEA

#==============================================================================
# ■ Icon
#==============================================================================

module Icon
  
  #--------------------------------------------------------------------------
  # self.cooldown
  #--------------------------------------------------------------------------
  def self.cooldown; return YEA::SKILL_RESTRICT::COOLDOWN_ICON; end
  
  #--------------------------------------------------------------------------
  # self.warmup
  #--------------------------------------------------------------------------
  def self.warmup; return YEA::SKILL_RESTRICT::WARMUP_ICON; end
  
  #--------------------------------------------------------------------------
  # self.limited
  #--------------------------------------------------------------------------
  def self.limited; return YEA::SKILL_RESTRICT::LIMITED_ICON; end
    
end # Icon

#==============================================================================
# ■ Numeric
#==============================================================================

class Numeric
  
  #--------------------------------------------------------------------------
  # new method: group_digits
  #--------------------------------------------------------------------------
  unless $imported["YEA-CoreEngine"]
  def group; return self.to_s; end
  end # $imported["YEA-CoreEngine"]
    
end # Numeric

#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_srs load_database; end
  def self.load_database
    load_database_srs
    load_notetags_srs
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_srs
  #--------------------------------------------------------------------------
  def self.load_notetags_srs
    groups = [$data_actors, $data_classes, $data_skills, $data_weapons,
      $data_armors, $data_enemies, $data_states, $data_items]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_srs
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
  attr_accessor :cooldown_rate
  attr_accessor :cooldown_lock
  attr_accessor :warmup_rate
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_srs
  #--------------------------------------------------------------------------
  def load_notetags_srs
    @cooldown_rate = 1.0
    @warmup_rate = 1.0
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::BASEITEM::COOLDOWN_RATE
        @cooldown_rate = $1.to_i * 0.01
      when YEA::REGEXP::BASEITEM::COOLDOWN_LOCK
        @cooldown_lock = true
      when YEA::REGEXP::BASEITEM::WARMUP_RATE
        @warmup_rate = $1.to_i * 0.01
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::BaseItem

#==============================================================================
# ■ RPG::Skill
#==============================================================================

class RPG::Skill < RPG::UsableItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :cooldown
  attr_accessor :warmup
  attr_accessor :limited_uses
  attr_accessor :change_cooldown
  attr_accessor :skill_cooldown
  attr_accessor :restrict_any_switch
  attr_accessor :restrict_all_switch
  attr_accessor :restrict_eval
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_srs
  #--------------------------------------------------------------------------
  def load_notetags_srs
    @cooldown = 0
    @warmup = 0
    @limited_uses = 0
    @change_cooldown = {}
    @skill_cooldown = {}
    @restrict_any_switch = []
    @restrict_all_switch = []
    @restrict_eval = ""
    @restrict_eval_on = false
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::SKILL::COOLDOWN
        @cooldown = $1.to_i
      when YEA::REGEXP::SKILL::WARMUP
        @warmup = $1.to_i
      when YEA::REGEXP::SKILL::LIMITED_USES
        @limited_uses = $1.to_i
      #---
      when YEA::REGEXP::SKILL::CHANGE_COOLDOWN
        @change_cooldown[0] = $1.to_i
      when YEA::REGEXP::SKILL::STYPE_COOLDOWN
        @change_cooldown[$1.to_i] = $2.to_i
      when YEA::REGEXP::SKILL::SKILL_COOLDOWN
        @skill_cooldown[$1.to_i] = $2.to_i
      #---
      when YEA::REGEXP::SKILL::RESTRICT_IF_SWITCH
        @restrict_any_switch.push($1.to_i)
      when YEA::REGEXP::SKILL::RESTRICT_ANY_SWITCH
        $1.scan(/\d+/).each { |num| 
        @restrict_any_switch.push(num.to_i) if num.to_i > 0 }
      when YEA::REGEXP::SKILL::RESTRICT_ALL_SWITCH
        $1.scan(/\d+/).each { |num| 
        @restrict_all_switch.push(num.to_i) if num.to_i > 0 }
      #---
      when YEA::REGEXP::SKILL::RESTRICT_EVAL_ON
        @restrict_eval_on = true
      when YEA::REGEXP::SKILL::RESTRICT_EVAL_OFF
        @restrict_eval_off = true
      else
        @restrict_eval += line.to_s if @restrict_eval_on
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::Skill

#==============================================================================
# ■ RPG::Item
#==============================================================================

class RPG::Item < RPG::UsableItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :change_cooldown
  attr_accessor :skill_cooldown
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_srs
  #--------------------------------------------------------------------------
  def load_notetags_srs
    @change_cooldown = {}
    @skill_cooldown = {}
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::ITEM::CHANGE_COOLDOWN
        @change_cooldown[0] = $1.to_i
      when YEA::REGEXP::ITEM::STYPE_COOLDOWN
        @change_cooldown[$1.to_i] = $2.to_i
      when YEA::REGEXP::ITEM::SKILL_COOLDOWN
        @skill_cooldown[$1.to_i] = $2.to_i
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::Item

#==============================================================================
# ■ Game_BattlerBase
#==============================================================================

class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias method: initialize
  #--------------------------------------------------------------------------
  alias game_battlerbase_initialize_srs initialize
  def initialize
    game_battlerbase_initialize_srs
    reset_cooldowns
    reset_times_used
  end
  
  #--------------------------------------------------------------------------
  # new method: reset_cooldowns
  #--------------------------------------------------------------------------
  def reset_cooldowns
    @cooldown = {}
  end
  
  #--------------------------------------------------------------------------
  # new method: reset_times_used
  #--------------------------------------------------------------------------
  def reset_times_used
    @times_used = {}
  end
  
  #--------------------------------------------------------------------------
  # alias method: skill_conditions_met?
  #--------------------------------------------------------------------------
  alias game_battlerbase_skill_conditions_met_srs skill_conditions_met?
  def skill_conditions_met?(skill)
    return false if skill_restriction?(skill)
    return game_battlerbase_skill_conditions_met_srs(skill)
  end
  
  #--------------------------------------------------------------------------
  # alias method: pay_skill_cost
  #--------------------------------------------------------------------------
  alias game_battlerbase_pay_skill_cost_srs pay_skill_cost
  def pay_skill_cost(skill)
    game_battlerbase_pay_skill_cost_srs(skill)
    pay_skill_cooldown(skill)
  end
  
  #--------------------------------------------------------------------------
  # new method: skill_restriction?
  #--------------------------------------------------------------------------
  def skill_restriction?(skill)
    if $game_party.in_battle
      return true if cooldown?(skill) > 0
      return true if warmup?(skill) > $game_troop.turn_count
      return true if limit_restricted?(skill)
    end
    return true if switch_restricted?(skill)
    return true if restrict_eval?(skill)
    return false
  end
  
  #--------------------------------------------------------------------------
  # new method: cooldown?
  #--------------------------------------------------------------------------
  def cooldown?(skill)
    skill = skill.id if skill.is_a?(RPG::Skill)
    return @cooldown[skill].nil? ? 0 : @cooldown[skill]
  end
  
  #--------------------------------------------------------------------------
  # new method: warmup?(skill)
  #--------------------------------------------------------------------------
  def warmup?(skill)
    skill = skill.id if skill.is_a?(RPG::Skill)
    return [$data_skills[skill].warmup * wur, 0].max.to_i
  end
  
  #--------------------------------------------------------------------------
  # new method: limit_restricted?
  #--------------------------------------------------------------------------
  def limit_restricted?(skill)
    return false if skill.limited_uses <= 0
    return times_used?(skill) >= skill.limited_uses
  end
  
  #--------------------------------------------------------------------------
  # new method: times_used?
  #--------------------------------------------------------------------------
  def times_used?(skill)
    skill = skill.id if skill.is_a?(RPG::Skill)
    return @times_used[skill].nil? ? 0 : @times_used[skill]
  end
  
  #--------------------------------------------------------------------------
  # new method: update_times_used
  #--------------------------------------------------------------------------
  def update_times_used(skill)
    skill = skill.id if skill.is_a?(RPG::Skill)
    reset_times_used if @times_used.nil?
    @times_used[skill] = 0 if @times_used[skill].nil?
    @times_used[skill] += 1
  end
  
  #--------------------------------------------------------------------------
  # new method: cdr
  #--------------------------------------------------------------------------
  def cdr
    n = 1.0
    if actor?
      n *= self.actor.cooldown_rate
      n *= self.class.cooldown_rate
      for equip in equips
        next if equip.nil?
        n *= equip.cooldown_rate
      end
    else
      n *= self.enemy.cooldown_rate
      if $imported["YEA-Doppelganger"] && !self.class.nil?
        n *= self.class.cooldown_rate
      end
    end
    for state in states
      next if state.nil?
      n *= state.cooldown_rate
    end
    return n
  end
  
  #--------------------------------------------------------------------------
  # new method: pay_skill_cooldown
  #--------------------------------------------------------------------------
  def pay_skill_cooldown(skill)
    return unless $game_party.in_battle
    skill = skill.id if skill.is_a?(RPG::Skill)
    set_cooldown(skill, $data_skills[skill].cooldown * cdr)
  end
  
  #--------------------------------------------------------------------------
  # new method: set_cooldown
  #--------------------------------------------------------------------------
  def set_cooldown(skill, amount = 0)
    return unless $game_party.in_battle
    skill = skill.id if skill.is_a?(RPG::Skill)
    @cooldown[skill] = [amount, 0].max.to_i
  end
  
  #--------------------------------------------------------------------------
  # new method: cooldown_lock?
  #--------------------------------------------------------------------------
  def cooldown_lock?
    if actor?
      return true if self.actor.cooldown_lock
      return true if self.class.cooldown_lock
      for equip in equips
        next if equip.nil?
        return true if equip.cooldown_lock
      end
    else
      return true if self.enemy.cooldown_lock
    end
    for state in states
      next if state.nil?
      return true if state.cooldown_lock
    end
    return false
  end
  
  #--------------------------------------------------------------------------
  # new method: update_cooldowns
  #--------------------------------------------------------------------------
  def update_cooldowns(amount = -1, stype_id = 0, skill_id = 0)
    return if cooldown_lock?
    reset_cooldowns if @cooldown.nil?
    for skill in skills
      skill = $data_skills[skill] if !skill.is_a?(RPG::Skill)
      next if stype_id != 0 && skill.stype_id != stype_id
      next if skill_id != 0 && skill.id != skill_id
      set_cooldown(skill, cooldown?(skill) + amount)
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: wur
  #--------------------------------------------------------------------------
  def wur
    n = 1.0
    if actor?
      n *= self.actor.warmup_rate
      n *= self.class.warmup_rate
      for equip in equips
        next if equip.nil?
        n *= equip.warmup_rate
      end
    else
      n *= self.enemy.warmup_rate
      if $imported["YEA-Doppelganger"] && !self.class.nil?
        n *= self.class.warmup_rate
      end
    end
    for state in states
      next if state.nil?
      n *= state.warmup_rate
    end
    return n
  end
  
  #--------------------------------------------------------------------------
  # new method: switch_restricted?
  #--------------------------------------------------------------------------
  def switch_restricted?(skill)
    return true if restrict_any_switch?(skill)
    return true if restrict_all_switch?(skill)
    return false
  end
  
  #--------------------------------------------------------------------------
  # new method: restrict_any_switch?
  #--------------------------------------------------------------------------
  def restrict_any_switch?(skill)
    for switch_id in skill.restrict_any_switch
      return true if $game_switches[switch_id]
    end
    return false
  end
  
  #--------------------------------------------------------------------------
  # new method: restrict_all_switch?
  #--------------------------------------------------------------------------
  def restrict_all_switch?(skill)
    return false if skill.restrict_all_switch == []
    for switch_id in skill.restrict_all_switch
      return false unless $game_switches[switch_id]
    end
    return true
  end
  
  #--------------------------------------------------------------------------
  # new method: restrict_eval?
  #--------------------------------------------------------------------------
  def restrict_eval?(skill)
    return false if skill.restrict_eval == ""
    return eval(skill.restrict_eval)
  end
  
end # Game_BattlerBase

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias method: on_battle_start
  #--------------------------------------------------------------------------
  alias game_battler_on_battle_start_srs on_battle_start
  def on_battle_start
    game_battler_on_battle_start_srs
    reset_cooldowns
    reset_times_used
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_battle_end
  #--------------------------------------------------------------------------
  alias game_battler_on_battle_end_srs on_battle_end
  def on_battle_end
    game_battler_on_battle_end_srs
    reset_cooldowns
    reset_times_used
  end
  
  #--------------------------------------------------------------------------
  # alias method: item_apply
  #--------------------------------------------------------------------------
  alias game_battler_item_apply_srs item_apply
  def item_apply(user, item)
    game_battler_item_apply_srs(user, item)
    updated_limited_uses(user, item)
  end
  
  #--------------------------------------------------------------------------
  # new method: updated_limited_uses
  #--------------------------------------------------------------------------
  def updated_limited_uses(user, item)
    return unless $game_party.in_battle
    return if item.nil?
    return unless item.is_a?(RPG::Skill)
    user.update_times_used(item)
  end
  
  #--------------------------------------------------------------------------
  # alias method: item_user_effect
  #--------------------------------------------------------------------------
  alias game_battler_item_user_effect_srs item_user_effect
  def item_user_effect(user, item)
    game_battler_item_user_effect_srs(user, item)
    apply_cooldown_changes(user, item)
  end
  
  #--------------------------------------------------------------------------
  # new method: apply_cooldown_changes
  #--------------------------------------------------------------------------
  def apply_cooldown_changes(user, item)
    return unless $game_party.in_battle
    return if item.nil?
    #---
    if item.change_cooldown != {}
      for key in item.change_cooldown
        stype_id = key[0]
        update_cooldowns(item.change_cooldown[stype_id], stype_id)
      end
      @result.success = true
    end
    #---
    if item.skill_cooldown != {}
      for key in item.skill_cooldown
        skill_id = key[0]
        update_cooldowns(item.skill_cooldown[skill_id], 0, skill_id)
      end
      @result.success = true
    end
  end
  
end # Game_Battler

#==============================================================================
# ■ Game_Enemy
#==============================================================================

class Game_Enemy < Game_Battler
  
  #--------------------------------------------------------------------------
  # new method: skills
  #--------------------------------------------------------------------------
  def skills
    data = []
    for action in enemy.actions
      next if data.include?(action.skill_id)
      data.push(action.skill_id)
    end
    return data
  end
  
end # Game_Enemy

#==============================================================================
# ■ Game_Unit
#==============================================================================

class Game_Unit
  
  #--------------------------------------------------------------------------
  # new method: update_restrictions
  #--------------------------------------------------------------------------
  def update_restrictions
    for member in members; member.update_cooldowns; end
  end
  
end # Game_Unit

#==============================================================================
# ■ Window_Base
#==============================================================================

class Window_Base < Window
  
  #--------------------------------------------------------------------------
  # new methods: restrict_colours
  #--------------------------------------------------------------------------
  def cooldown_colour; text_color(YEA::SKILL_RESTRICT::COOLDOWN_COLOUR); end;
  def warmup_colour; text_color(YEA::SKILL_RESTRICT::WARMUP_COLOUR); end;
  def limited_colour; text_color(YEA::SKILL_RESTRICT::LIMITED_COLOUR); end;
  
end # Window_Base

#==============================================================================
# ■ Window_SkillList
#==============================================================================

class Window_SkillList < Window_Selectable
  
  #--------------------------------------------------------------------------
  # alias method: draw_item
  #--------------------------------------------------------------------------
  alias window_skilllist_draw_item_srs draw_item
  def draw_item(index)
    if skill_restriction?(index)
      draw_skill_restriction(index)
    else
      window_skilllist_draw_item_srs(index)
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: skill_restriction?
  #--------------------------------------------------------------------------
  def skill_restriction?(index)
    skill = @data[index]
    return false if @actor.nil?
    return @actor.skill_restriction?(skill)
  end
  
  #--------------------------------------------------------------------------
  # new method: draw_item
  #--------------------------------------------------------------------------
  def draw_skill_restriction(index)
    skill = @data[index]
    rect = item_rect(index)
    rect.width -= 4
    draw_item_name(skill, rect.x, rect.y, enable?(skill))
    if @actor.limit_restricted?(skill)
      draw_skill_limited(rect, skill)
    elsif @actor.cooldown?(skill) > 0
      draw_skill_cooldown(rect, skill)
    elsif warmup_restriction?(skill)
      draw_skill_warmup(rect, skill)
    else
      draw_skill_cost(rect, skill)
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: draw_skill_limited
  #--------------------------------------------------------------------------
  def draw_skill_limited(rect, skill)
    change_color(limited_colour, enable?(skill))
    icon = Icon.limited
    if icon > 0
      draw_icon(icon, rect.x + rect.width-24, rect.y, enable?(skill))
      rect.width -= 24
    end
    contents.font.size = YEA::SKILL_RESTRICT::LIMITED_SIZE
    text = YEA::SKILL_RESTRICT::LIMITED_TEXT
    draw_text(rect, text, 2)
    reset_font_settings
  end
  
  #--------------------------------------------------------------------------
  # new method: draw_skill_cooldown
  #--------------------------------------------------------------------------
  def draw_skill_cooldown(rect, skill)
    change_color(cooldown_colour, enable?(skill))
    icon = Icon.cooldown
    if icon > 0
      draw_icon(icon, rect.x + rect.width-24, rect.y, enable?(skill))
      rect.width -= 24
    end
    contents.font.size = YEA::SKILL_RESTRICT::COOLDOWN_SIZE
    value = @actor.cooldown?(skill)
    text = sprintf(YEA::SKILL_RESTRICT::COOLDOWN_SUFFIX, value.group)
    draw_text(rect, text, 2)
    reset_font_settings
  end
  
  #--------------------------------------------------------------------------
  # new method: warmup_restriction?
  #--------------------------------------------------------------------------
  def warmup_restriction?(skill)
    return false unless $game_party.in_battle
    return @actor.warmup?(skill) > $game_troop.turn_count
  end
  
  #--------------------------------------------------------------------------
  # new method: draw_skill_warmup
  #--------------------------------------------------------------------------
  def draw_skill_warmup(rect, skill)
    change_color(warmup_colour, enable?(skill))
    icon = Icon.warmup
    if icon > 0
      draw_icon(icon, rect.x + rect.width-24, rect.y, enable?(skill))
      rect.width -= 24
    end
    contents.font.size = YEA::SKILL_RESTRICT::WARMUP_SIZE
    value = @actor.warmup?(skill) - $game_troop.turn_count
    text = sprintf(YEA::SKILL_RESTRICT::WARMUP_SUFFIX, value.group)
    draw_text(rect, text, 2)
    reset_font_settings
  end
  
end # Window_SkillList

#==============================================================================
# ■ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: turn_start
  #--------------------------------------------------------------------------
  alias scene_battle_turn_start_srs turn_start
  def turn_start
    $game_party.update_restrictions
    $game_troop.update_restrictions
    scene_battle_turn_start_srs
  end
  
end # Scene_Battle

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================