#==============================================================================
# 
# ▼ Yanfly Engine Ace - Skill Cost Manager v1.03
# -- Last Updated: 2012.01.23
# -- Level: Normal, Hard, Lunatic
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-SkillCostManager"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.08.06 - Restore SP-Paramater: TCR
# 2012.01.23 - Compatibility Update: Doppelganger
# 2011.12.11 - Started Script and Finished.
#            - Added max and min notetags.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script adds more functionality towards skill costs. Skills can now cost
# HP, more MP, more TP, gold, and even have custom costs. The way the skill
# costs are drawn in the display windows are changed to deliver more effective
# and reliable information to the player. And if four skill costs aren't enough
# to satisfy you, you can even make your own custom skill costs.
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
# <hp cost rate: x%>
# Allows the actor to drop the HP cost of skills to x%.
# 
# <tp cost rate: x%>
# Allows the actor to drop the TP cost of skills to x%.
# 
# <gold cost rate: x%>
# Allows the actor to drop the Gold cost of skills to x%.
# 
# -----------------------------------------------------------------------------
# Class Notetags - These notetags go in the class notebox in the database.
# -----------------------------------------------------------------------------
# <hp cost rate: x%>
# Allows the class to drop the HP cost of skills to x%.
# 
# <tp cost rate: x%>
# Allows the class to drop the TP cost of skills to x%.
# 
# <gold cost rate: x%>
# Allows the class to drop the Gold cost of skills to x%.
# 
# -----------------------------------------------------------------------------
# Skill Notetags - These notetags go in the skills notebox in the database.
# -----------------------------------------------------------------------------
# <hp cost: x>
# Sets the skill's HP cost to x. This function did not exist by default in
# RPG Maker VX Ace.
# 
# <hp cost: x%>
# Sets the HP cost to a percentage of the actor's MaxHP. If a normal HP cost is
# present on the skill, too, then this value is added to the HP cost.
# 
# <hp cost max: x>
# <hp cost min: x>
# Sets the maximum and minimum range of the HP Cost of the skill. If you do not
# use this tag, there will be no maximum and/or minimum range.
# 
# <mp cost: x>
# Sets the skill's MP cost to x. Allows MP cost to exceed 9999, which is RPG
# Maker VX Ace's database editor's maximum limit.
# 
# <mp cost: x%>
# Sets the MP cost to a percentage of the actor's MaxMP. If a normal MP cost is
# present on the skill, too, then this value is added to the MP cost.
# 
# <mp cost max: x>
# <mp cost min: x>
# Sets the maximum and minimum range of the MP Cost of the skill. If you do not
# use this tag, there will be no maximum and/or minimum range.
# 
# <tp cost: x>
# Sets the skill's TP cost to x. Allows TP cost to exceed 100, which is RPG
# Maker VX Ace's database editor's maximum limit.
# 
# <tp cost: x%>
# Sets the TP cost to a percentage of the actor's MaxTP. If a normal TP cost is
# present on the skill, too, then this value is added to the TP cost.
# 
# <tp cost max: x>
# <tp cost min: x>
# Sets the maximum and minimum range of the TP Cost of the skill. If you do not
# use this tag, there will be no maximum and/or minimum range.
# 
# <gold cost: x>
# Sets the skill's gold cost to x. Enemies with skills that cost gold do not
# use gold. If the player does not have enough gold, the skill can't be used.
# 
# <gold cost: x%>
# Sets the skill's gold cost equal to a percentage of the party's total gold.
# If both a regular gold cost and a percentile gold cost is used, the total of
# both values will be the skill's gold cost.
# 
# <gold cost max: x>
# <gold cost min: x>
# Sets the maximum and minimum range of the Gold Cost of the skill. If you do
# not use this tag, there will be no maximum and/or minimum range.
# 
# --- Making Your Own Custom Costs ---
# 
# <custom cost: string>
# If you decide to have a custom cost for your game, insert this notetag to
# change what displays in the skill menu visually.
# 
# <custom cost colour: x>
# This is the "Window" skin text colour used for the custom cost. By default,
# it is text colour 0, which is the white colour.
# 
# <custom cost size: x>
# This is the text font size used for the custom cost in the display windows.
# By default, it is font size 20.
# 
# <custom cost icon: x>
# If you wish to use an icon for your custom cost, replace x with the icon ID
# you wish to show in display windows. By default, it is 0 (and not shown).
# 
# <custom cost requirement>
#  string
#  string
# </custom cost requirement>
# Sets the custom cost requirement of the skill with an eval function using the
# strings in between. The strings are a part of one line even if in the notebox
# they are on separate lines.
# 
# <custom cost perform>
#  string
#  string
# </custom cost perform>
# Sets how the custom cost payment is done with an eval function using the
# strings in between. The strings are a part of one line even if in the notebox
# they are on separate lines.
# 
# -----------------------------------------------------------------------------
# Weapon Notetags - These notetags go in the weapons notebox in the database.
# -----------------------------------------------------------------------------
# <hp cost rate: x%>
# Allows the weapon to drop the HP cost of skills to x% when worn.
# 
# <tp cost rate: x%>
# Allows the weapon to drop the TP cost of skills to x% when worn.
# 
# <gold cost rate: x%>
# Allows the weapon to drop the Gold cost of skills to x% when worn.
# 
# -----------------------------------------------------------------------------
# Armour Notetags - These notetags go in the armours notebox in the database.
# -----------------------------------------------------------------------------
# <hp cost rate: x%>
# Allows the armour to drop the HP cost of skills to x% when worn.
# 
# <tp cost rate: x%>
# Allows the armour to drop the TP cost of skills to x% when worn.
# 
# <gold cost rate: x%>
# Allows the armour to drop the TP cost of skills to x% when worn.
# 
# -----------------------------------------------------------------------------
# Enemy Notetags - These notetags go in the enemies notebox in the database.
# -----------------------------------------------------------------------------
# <hp cost rate: x%>
# Allows the enemy to drop the HP cost of skills to x%.
# 
# <tp cost rate: x%>
# Allows the enemy to drop the TP cost of skills to x%.
# 
# -----------------------------------------------------------------------------
# State Notetags - These notetags go in the states notebox in the database.
# -----------------------------------------------------------------------------
# <hp cost rate: x%>
# Allows the state to drop the HP cost of skills to x% when afflicted.
# 
# <tp cost rate: x%>
# Allows the state to drop the TP cost of skills to x% when afflicted.
# 
# <gold cost rate: x%>
# Allows the state to drop the Gold cost of skills to x% when afflicted.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module SKILL_COST
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - HP Cost Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # New to this script are HP costs. HP costs require the battler to have
    # sufficient HP before being able to use the skill. The text colour that's
    # used, the suffix, or whether or not to use an icon. If you do not wish
    # to use an icon, set the icon to 0.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    HP_COST_COLOUR = 21         # Colour used from "Window" skin.
    HP_COST_SIZE   = 20         # Font size used for HP costs.
    HP_COST_SUFFIX = "%sHP"     # Suffix used for HP costs.
    HP_COST_ICON   = 0          # Icon used for HP costs. Set 0 to disable.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - MP Cost Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Here, you can change the settings for MP costs: the text colour that's
    # used, the suffix, or whether or not to use an icon. If you do not wish
    # to use an icon, set the icon to 0.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    MP_COST_COLOUR = 23         # Colour used from "Window" skin. Default: 23
    MP_COST_SIZE   = 20         # Font size used for MP costs. Default: 24
    MP_COST_SUFFIX = "%sMP"     # Suffix used for MP costs. No suffix default.
    MP_COST_ICON   = 0          # Icon used for MP costs. Set 0 to disable.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - TP Cost Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Here, you can change the settings for TP costs: the text colour that's
    # used, the suffix, or whether or not to use an icon. If you do not wish
    # to use an icon, set the icon to 0.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    TP_COST_COLOUR = 2          # Colour used from "Window" skin. Default: 29
    TP_COST_SIZE   = 20         # Font size used for TP costs. Default: 24
    TP_COST_SUFFIX = "%sTP"     # Suffix used for TP costs. No suffix default.
    TP_COST_ICON   = 0          # Icon used for TP costs. Set 0 to disable.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Gold Cost Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # New to this script are Gold costs. Gold costs require the party to have
    # enough gold before being able to use the skill. The text colour that's
    # used, the suffix, or whether or not to use an icon. If you do not wish
    # to use an icon, set the icon to 0.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    GOLD_COST_COLOUR = 6          # Colour used from "Window" skin.
    GOLD_COST_SIZE   = 20         # Font size used for Gold costs.
    GOLD_COST_SUFFIX = "%sGold"   # Suffix used for Gold costs.
    GOLD_COST_ICON   = 0          # Icon used for Gold costs. Set 0 to disable.
    
  end # SKILL_COST
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module BASEITEM
    
    HP_COST_RATE = /<(?:HP_COST_RATE|hp cost rate):[ ](\d+)([%％])>/i
    TP_COST_RATE = /<(?:TP_COST_RATE|tp cost rate):[ ](\d+)([%％])>/i
    GOLD_COST_RATE = /<(?:GOLD_COST_RATE|gold cost rate):[ ](\d+)([%％])>/i
    
  end # BASEITEM
  module SKILL
    
    HP_COST_SET = /<(?:HP_COST|hp cost):[ ](\d+)>/i
    HP_COST_PER = /<(?:HP_COST|hp cost):[ ](\d+)([%％])>/i
    MP_COST_SET = /<(?:MP_COST|mp cost):[ ](\d+)>/i
    MP_COST_PER = /<(?:MP_COST|mp cost):[ ](\d+)([%％])>/i
    TP_COST_SET = /<(?:TP_COST|tp cost):[ ](\d+)>/i
    TP_COST_PER = /<(?:TP_COST|tp cost):[ ](\d+)([%％])>/i
    GOLD_COST_SET = /<(?:GOLD_COST|gold cost):[ ](\d+)>/i
    GOLD_COST_PER = /<(?:GOLD_COST|gold cost):[ ](\d+)([%％])>/i
    
    CUSTOM_COST_TEXT = /<(?:CUSTOM_COST|custom cost):[ ](.*)>/i
    CUSTOM_COST_COLOUR =
      /<(?:CUSTOM_COST_COLOUR|custom cost colour|custom cost color):[ ](\d+)>/i
    CUSTOM_COST_SIZE = /<(?:CUSTOM_COST_SIZE|custom cost size):[ ](\d+)>/i
    CUSTOM_COST_ICON = /<(?:CUSTOM_COST_ICON|custom cost icon):[ ](\d+)>/i
    CUSTOM_COST_REQUIREMENT_ON = 
      /<(?:CUSTOM_COST_REQUIREMENT|custom cost requirement)>/i
    CUSTOM_COST_REQUIREMENT_OFF = 
      /<\/(?:CUSTOM_COST_REQUIREMENT|custom cost requirement)>/i
    CUSTOM_COST_PERFORM_ON = 
      /<(?:CUSTOM_COST_PERFORM|custom cost perform)>/i
    CUSTOM_COST_PERFORM_OFF = 
      /<\/(?:CUSTOM_COST_PERFORM|custom cost perform)>/i
    
    HP_COST_MIN = /<(?:HP_COST_MIN|hp cost min):[ ](\d+)>/i
    HP_COST_MAX = /<(?:HP_COST_MIN|hp cost max):[ ](\d+)>/i
    MP_COST_MIN = /<(?:MP_COST_MIN|mp cost min):[ ](\d+)>/i
    MP_COST_MAX = /<(?:MP_COST_MIN|mp cost max):[ ](\d+)>/i
    TP_COST_MIN = /<(?:TP_COST_MIN|tp cost min):[ ](\d+)>/i
    TP_COST_MAX = /<(?:TP_COST_MIN|tp cost max):[ ](\d+)>/i
    GOLD_COST_MIN = /<(?:GOLD_COST_MIN|gold cost min):[ ](\d+)>/i
    GOLD_COST_MAX = /<(?:GOLD_COST_MIN|gold cost max):[ ](\d+)>/i
    
  end # SKILL
  end # REGEXP
end # YEA

#==============================================================================
# ■ Icon
#==============================================================================

module Icon
  
  #--------------------------------------------------------------------------
  # self.mp_cost
  #--------------------------------------------------------------------------
  def self.mp_cost; return YEA::SKILL_COST::MP_COST_ICON; end
  
  #--------------------------------------------------------------------------
  # self.tp_cost
  #--------------------------------------------------------------------------
  def self.tp_cost; return YEA::SKILL_COST::TP_COST_ICON; end
  
  #--------------------------------------------------------------------------
  # self.hp_cost
  #--------------------------------------------------------------------------
  def self.hp_cost; return YEA::SKILL_COST::HP_COST_ICON; end
  
  #--------------------------------------------------------------------------
  # self.gold_cost
  #--------------------------------------------------------------------------
  def self.gold_cost; return YEA::SKILL_COST::GOLD_COST_ICON; end
    
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
  class <<self; alias load_database_scm load_database; end
  def self.load_database
    load_database_scm
    load_notetags_scm
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_scm
  #--------------------------------------------------------------------------
  def self.load_notetags_scm
    groups = [$data_actors, $data_classes, $data_skills, $data_weapons,
      $data_armors, $data_enemies, $data_states]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_scm
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
  attr_accessor :tp_cost_rate
  attr_accessor :hp_cost_rate
  attr_accessor :gold_cost_rate
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_scm
  #--------------------------------------------------------------------------
  def load_notetags_scm
    @tp_cost_rate = 1.0
    @hp_cost_rate = 1.0
    @gold_cost_rate = 1.0
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::BASEITEM::TP_COST_RATE
        @tp_cost_rate = $1.to_i * 0.01
      when YEA::REGEXP::BASEITEM::HP_COST_RATE
        @hp_cost_rate = $1.to_i * 0.01
      when YEA::REGEXP::BASEITEM::GOLD_COST_RATE
        @gold_cost_rate = $1.to_i * 0.01
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
  attr_accessor :hp_cost
  attr_accessor :hp_cost_percent
  attr_accessor :mp_cost_percent
  attr_accessor :tp_cost_percent
  attr_accessor :gold_cost
  attr_accessor :gold_cost_percent
  
  attr_accessor :hp_cost_min
  attr_accessor :hp_cost_max
  attr_accessor :mp_cost_min
  attr_accessor :mp_cost_max
  attr_accessor :tp_cost_min
  attr_accessor :tp_cost_max
  attr_accessor :gold_cost_min
  attr_accessor :gold_cost_max
  
  attr_accessor :use_custom_cost
  attr_accessor :custom_cost_text
  attr_accessor :custom_cost_colour
  attr_accessor :custom_cost_size
  attr_accessor :custom_cost_icon
  attr_accessor :custom_cost_requirement
  attr_accessor :custom_cost_perform
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_scm
  #--------------------------------------------------------------------------
  def load_notetags_scm
    @hp_cost = 0
    @gold_cost = 0
    @hp_cost_percent = 0.0
    @mp_cost_percent = 0.0
    @tp_cost_percent = 0.0
    @gold_cost_percent = 0.0
    
    @custom_cost_text = "0"
    @custom_cost_colour = 0
    @custom_cost_size = 20
    @custom_cost_icon = 0
    @custom_cost_requirement = ""
    @custom_cost_perform = ""
    
    @use_custom_cost = false
    @custom_cost_req_on = false
    @custom_cost_per_on = false
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::SKILL::MP_COST_SET
        @mp_cost = $1.to_i
      when YEA::REGEXP::SKILL::MP_COST_PER
        @mp_cost_percent = $1.to_i * 0.01
      when YEA::REGEXP::SKILL::TP_COST_SET
        @tp_cost = $1.to_i
      when YEA::REGEXP::SKILL::TP_COST_PER
        @tp_cost_percent = $1.to_i * 0.01
      when YEA::REGEXP::SKILL::HP_COST_SET
        @hp_cost = $1.to_i
      when YEA::REGEXP::SKILL::HP_COST_PER
        @hp_cost_percent = $1.to_i * 0.01
      when YEA::REGEXP::SKILL::GOLD_COST_SET
        @gold_cost = $1.to_i
      when YEA::REGEXP::SKILL::GOLD_COST_PER
        @gold_cost_percent = $1.to_i * 0.01
      #---
      when YEA::REGEXP::SKILL::HP_COST_MIN
        @hp_cost_min = $1.to_i
      when YEA::REGEXP::SKILL::HP_COST_MAX
        @hp_cost_max = $1.to_i
      when YEA::REGEXP::SKILL::MP_COST_MIN
        @mp_cost_min = $1.to_i
      when YEA::REGEXP::SKILL::MP_COST_MAX
        @mp_cost_max = $1.to_i
      when YEA::REGEXP::SKILL::TP_COST_MIN
        @tp_cost_min = $1.to_i
      when YEA::REGEXP::SKILL::TP_COST_MAX
        @tp_cost_max = $1.to_i
      when YEA::REGEXP::SKILL::GOLD_COST_MIN
        @gold_cost_min = $1.to_i
      when YEA::REGEXP::SKILL::GOLD_COST_MAX
        @gold_cost_max = $1.to_i
      #---
      when YEA::REGEXP::SKILL::CUSTOM_COST_TEXT
        @custom_cost_text = $1.to_s
      when YEA::REGEXP::SKILL::CUSTOM_COST_COLOUR
        @custom_cost_colour = $1.to_i
      when YEA::REGEXP::SKILL::CUSTOM_COST_SIZE
        @custom_cost_size = $1.to_i
      when YEA::REGEXP::SKILL::CUSTOM_COST_ICON
        @custom_cost_icon = $1.to_i
      when YEA::REGEXP::SKILL::CUSTOM_COST_REQUIREMENT_ON
        @custom_cost_req_on = true
        @use_custom_cost = true
      when YEA::REGEXP::SKILL::CUSTOM_COST_REQUIREMENT_OFF
        @custom_cost_req_on = false
        @use_custom_cost = true
      when YEA::REGEXP::SKILL::CUSTOM_COST_PERFORM_ON
        @custom_cost_per_on = true
        @use_custom_cost = true
      when YEA::REGEXP::SKILL::CUSTOM_COST_PERFORM_OFF
        @custom_cost_per_on = false
        @use_custom_cost = true
      else
        @custom_cost_requirement += line.to_s if @custom_cost_req_on
        @custom_cost_perform += line.to_s if @custom_cost_per_on
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::Skill

#==============================================================================
# ■ Game_BattlerBase
#==============================================================================

class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias method: skill_cost_payable?
  #--------------------------------------------------------------------------
  alias game_battlerbase_skill_cost_payable_scm skill_cost_payable?
  def skill_cost_payable?(skill)
    return false if hp <= skill_hp_cost(skill)
    return false unless gold_cost_met?(skill)
    return false unless custom_cost_met?(skill)
    return game_battlerbase_skill_cost_payable_scm(skill)
  end
  
  #--------------------------------------------------------------------------
  # new method: gold_cost_met?
  #--------------------------------------------------------------------------
  def gold_cost_met?(skill)
    return true unless actor?
    return $game_party.gold >= skill_gold_cost(skill)
  end
  
  #--------------------------------------------------------------------------
  # new method: custom_cost_met?
  #--------------------------------------------------------------------------
  def custom_cost_met?(skill)
    return true unless skill.use_custom_cost
    return eval(skill.custom_cost_requirement)
  end
  
  #--------------------------------------------------------------------------
  # alias method: pay_skill_cost
  #--------------------------------------------------------------------------
  alias game_battlerbase_pay_skill_cost_scm pay_skill_cost
  def pay_skill_cost(skill)
    game_battlerbase_pay_skill_cost_scm(skill)
    self.hp -= skill_hp_cost(skill)
    $game_party.lose_gold(skill_gold_cost(skill)) if actor?
    pay_custom_cost(skill)
  end
  
  #--------------------------------------------------------------------------
  # new method: pay_custom_cost
  #--------------------------------------------------------------------------
  def pay_custom_cost(skill)
    return unless skill.use_custom_cost
    eval(skill.custom_cost_perform)
  end
  
  #--------------------------------------------------------------------------
  # alias method: skill_mp_cost
  #--------------------------------------------------------------------------
  alias game_battlerbase_skill_mp_cost_scm skill_mp_cost
  def skill_mp_cost(skill)
    n = game_battlerbase_skill_mp_cost_scm(skill)
    n += skill.mp_cost_percent * mmp * mcr
    n = [n.to_i, skill.mp_cost_max].min unless skill.mp_cost_max.nil?
    n = [n.to_i, skill.mp_cost_min].max unless skill.mp_cost_min.nil?
    return n.to_i
  end
  
  #--------------------------------------------------------------------------
  # alias method: skill_tp_cost
  #--------------------------------------------------------------------------
  alias game_battlerbase_skill_tp_cost_scm skill_tp_cost
  def skill_tp_cost(skill)
    n = game_battlerbase_skill_tp_cost_scm(skill) * tcr_y
    n += skill.tp_cost_percent * max_tp * tcr_y
    n = [n.to_i, skill.tp_cost_max].min unless skill.tp_cost_max.nil?
    n = [n.to_i, skill.tp_cost_min].max unless skill.tp_cost_min.nil?
    return n.to_i
  end
  
  #--------------------------------------------------------------------------
  # new method: tcr_y
  #--------------------------------------------------------------------------
  def tcr_y
    n = 1.0
    if actor?
      n *= self.actor.tp_cost_rate
      n *= self.class.tp_cost_rate
      for equip in equips
        next if equip.nil?
        n *= equip.tp_cost_rate
      end
    else
      n *= self.enemy.tp_cost_rate
      if $imported["YEA-Doppelganger"] && !self.class.nil?
        n *= self.class.tp_cost_rate
      end
    end
    for state in states
      next if state.nil?
      n *= state.tp_cost_rate
    end
    return n
  end
  
  #--------------------------------------------------------------------------
  # new method: skill_hp_cost
  #--------------------------------------------------------------------------
  def skill_hp_cost(skill)
    n = skill.hp_cost * hcr
    n += skill.hp_cost_percent * mhp * hcr
    n = [n.to_i, skill.hp_cost_max].min unless skill.hp_cost_max.nil?
    n = [n.to_i, skill.hp_cost_min].max unless skill.hp_cost_min.nil?
    return n.to_i
  end
  
  #--------------------------------------------------------------------------
  # new method: hcr
  #--------------------------------------------------------------------------
  def hcr
    n = 1.0
    if actor?
      n *= self.actor.hp_cost_rate
      n *= self.class.hp_cost_rate
      for equip in equips
        next if equip.nil?
        n *= equip.hp_cost_rate
      end
    else
      n *= self.enemy.hp_cost_rate
      if $imported["YEA-Doppelganger"] && !self.class.nil?
        n *= self.class.hp_cost_rate
      end
    end
    for state in states
      next if state.nil?
      n *= state.hp_cost_rate
    end
    return n
  end
  
  #--------------------------------------------------------------------------
  # new method: skill_gold_cost
  #--------------------------------------------------------------------------
  def skill_gold_cost(skill)
    n = skill.gold_cost * gcr
    n += skill.gold_cost_percent * $game_party.gold * gcr
    n = [n.to_i, skill.gold_cost_max].min unless skill.gold_cost_max.nil?
    n = [n.to_i, skill.gold_cost_min].max unless skill.gold_cost_min.nil?
    return n.to_i
  end
  
  #--------------------------------------------------------------------------
  # new method: gcr
  #--------------------------------------------------------------------------
  def gcr
    n = 1.0
    n *= self.actor.gold_cost_rate
    n *= self.class.gold_cost_rate
    for equip in equips
      next if equip.nil?
      n *= equip.gold_cost_rate
    end
    for state in states
      next if state.nil?
      n *= state.gold_cost_rate
    end
    return n
  end
  
end # Game_BattlerBase
  
#==============================================================================
# ■ Window_Base
#==============================================================================

class Window_Base < Window
  
  #--------------------------------------------------------------------------
  # overwrite methods: cost_colours
  #--------------------------------------------------------------------------
  def mp_cost_color; text_color(YEA::SKILL_COST::MP_COST_COLOUR); end;
  def tp_cost_color; text_color(YEA::SKILL_COST::TP_COST_COLOUR); end;
  def hp_cost_color; text_color(YEA::SKILL_COST::HP_COST_COLOUR); end;
  def gold_cost_color; text_color(YEA::SKILL_COST::GOLD_COST_COLOUR); end;
  
end # Window_Base

#==============================================================================
# ■ Window_SkillList
#==============================================================================

class Window_SkillList < Window_Selectable
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_skill_cost
  #--------------------------------------------------------------------------
  def draw_skill_cost(rect, skill)
    draw_tp_skill_cost(rect, skill) unless $imported["YEA-BattleEngine"]
    draw_mp_skill_cost(rect, skill)
    draw_tp_skill_cost(rect, skill) if $imported["YEA-BattleEngine"]
    draw_hp_skill_cost(rect, skill)
    draw_gold_skill_cost(rect, skill)
    draw_custom_skill_cost(rect, skill)
  end
  
  #--------------------------------------------------------------------------
  # new method: draw_mp_skill_cost
  #--------------------------------------------------------------------------
  def draw_mp_skill_cost(rect, skill)
    return unless @actor.skill_mp_cost(skill) > 0
    change_color(mp_cost_color, enable?(skill))
    #---
    icon = Icon.mp_cost
    if icon > 0
      draw_icon(icon, rect.x + rect.width-24, rect.y, enable?(skill))
      rect.width -= 24
    end
    #---
    contents.font.size = YEA::SKILL_COST::MP_COST_SIZE
    cost = @actor.skill_mp_cost(skill)
    text = sprintf(YEA::SKILL_COST::MP_COST_SUFFIX, cost.group)
    draw_text(rect, text, 2)
    cx = text_size(text).width + 4
    rect.width -= cx
    reset_font_settings
  end
  
  #--------------------------------------------------------------------------
  # new method: draw_tp_skill_cost
  #--------------------------------------------------------------------------
  def draw_tp_skill_cost(rect, skill)
    return unless @actor.skill_tp_cost(skill) > 0
    change_color(tp_cost_color, enable?(skill))
    #---
    icon = Icon.tp_cost
    if icon > 0
      draw_icon(icon, rect.x + rect.width-24, rect.y, enable?(skill))
      rect.width -= 24
    end
    #---
    contents.font.size = YEA::SKILL_COST::TP_COST_SIZE
    cost = @actor.skill_tp_cost(skill)
    text = sprintf(YEA::SKILL_COST::TP_COST_SUFFIX, cost.group)
    draw_text(rect, text, 2)
    cx = text_size(text).width + 4
    rect.width -= cx
    reset_font_settings
  end
  
  #--------------------------------------------------------------------------
  # new method: draw_hp_skill_cost
  #--------------------------------------------------------------------------
  def draw_hp_skill_cost(rect, skill)
    return unless @actor.skill_hp_cost(skill) > 0
    change_color(hp_cost_color, enable?(skill))
    #---
    icon = Icon.hp_cost
    if icon > 0
      draw_icon(icon, rect.x + rect.width-24, rect.y, enable?(skill))
      rect.width -= 24
    end
    #---
    contents.font.size = YEA::SKILL_COST::HP_COST_SIZE
    cost = @actor.skill_hp_cost(skill)
    text = sprintf(YEA::SKILL_COST::HP_COST_SUFFIX, cost.group)
    draw_text(rect, text, 2)
    cx = text_size(text).width + 4
    rect.width -= cx
    reset_font_settings
  end
  
  #--------------------------------------------------------------------------
  # new method: draw_gold_skill_cost
  #--------------------------------------------------------------------------
  def draw_gold_skill_cost(rect, skill)
    return unless @actor.skill_gold_cost(skill) > 0
    change_color(gold_cost_color, enable?(skill))
    #---
    icon = Icon.gold_cost
    if icon > 0
      draw_icon(icon, rect.x + rect.width-24, rect.y, enable?(skill))
      rect.width -= 24
    end
    #---
    contents.font.size = YEA::SKILL_COST::GOLD_COST_SIZE
    cost = @actor.skill_gold_cost(skill)
    text = sprintf(YEA::SKILL_COST::GOLD_COST_SUFFIX, cost.group)
    draw_text(rect, text, 2)
    cx = text_size(text).width + 4
    rect.width -= cx
    reset_font_settings
  end
  
  #--------------------------------------------------------------------------
  # new method: draw_custom_skill_cost
  #--------------------------------------------------------------------------
  def draw_custom_skill_cost(rect, skill)
    return unless skill.use_custom_cost
    change_color(text_color(skill.custom_cost_colour), enable?(skill))
    icon = skill.custom_cost_icon
    if icon > 0
      draw_icon(icon, rect.x + rect.width-24, rect.y, enable?(skill))
      rect.width -= 24
    end
    contents.font.size = skill.custom_cost_size
    text = skill.custom_cost_text
    draw_text(rect, text, 2)
    cx = text_size(text).width + 4
    rect.width -= cx
    reset_font_settings
  end
  
end # Window_SkillList

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================