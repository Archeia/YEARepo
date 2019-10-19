#==============================================================================
# 
# ▼ Yanfly Engine Ace - Enemy Levels v1.02
# -- Last Updated: 2012.01.26
# -- Level: Normal, Hard
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-EnemyLevels"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.26 - Bug Fixed: Duplication of stat growth rates per enemy.
# 2012.01.24 - Added <hide level> notetag for enemies.
#            - Option to change Party Level function in Action Conditions to
#              enemy level requirements.
# 2011.12.30 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# RPG's with enemies that level up with the party enforces the player to stay
# on their toes the whole time. This is both a good and bad thing as it can
# cause the player to stay alert, but can also cause the player to meet some
# roadblocks. This script will not only provide enemies the ability to level up
# but also allow the script's user to go around these roadblocks using various
# tags to limit or slow down the rate of growth across all enemies.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Skill Notetags - These notetags go in the skill notebox in the database.
# -----------------------------------------------------------------------------
# <enemy level: +x>
# <enemy level: -x>
# This causes the enemy to raise or drop x levels depending on the tag used.
# The new level will readjust the enemy's stats (including HP and MP).
# 
# <enemy level reset>
# This resets the enemy's level back to the typical range it should be plus or
# minus any level fluctuations it was given. This occurs before enemy level +
# and enemy level - tags.
# 
# -----------------------------------------------------------------------------
# Enemy Notetags - These notetags go in the enemies notebox in the database.
# -----------------------------------------------------------------------------
# <hide level>
# This notetag will hide the level of the enemy. If YEA - Enemy Target Info is
# installed, the level will be revealed upon a parameter scan.
# 
# <min level: x> 
# <max level: x>
# This will adjust the minimum and maximum levels for the enemy. By default,
# the minimum level is 1 and the maximum level is whatever is set in the module
# as MAX_LEVEL.
# 
# <set level: x>
# This will set the enemy's level to exactly x. It a sense, this is just the
# usage of both the min and max level tags together as the same value.
# 
# <level type: x>
# Choosing a value from 0 to 4, you can adjust the different leveling rulesets
# for the enemy. See the list below.
# Type 0 - Lowest level of all actors that have joined.
# Type 1 - Lowest level in the battle party.
# Type 2 - Average level of the battle party.
# Type 3 - Highest level of the battle party.
# Type 4 - Highest level of all actors that have joined.
# 
# <level random: x>
# This will give the level a random flunctuation in either direction. Set this
# value to 0 if you don't wish to use it. Adjust RANDOM_FLUCTUATION inside the
# module to change the default fluctuation value.
# 
# <stat: +x per level>
# <stat: -x per level>
# <stat: +x% per level>
# <stat: -x% per level>
# This will raise or lower the stat by x or x% per level (depending on the tag
# used). This will override the default growth settings found inside the module
# hash called DEFAULT_GROWTH. You may replace stat with:
# MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, LUK, GOLD, EXP
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module ENEMY_LEVEL
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - General Level Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These settings adjust the general level setup for your enemies from the
    # way levels appear in the game to the default maximum level for enemies,
    # to the way their levels are calculated by default, and the random level
    # fluctuation they have. If you want enemies to have different settings,
    # use notetags to change the respective setting.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This is how the level text will appear whenever enemy levels are shown.
    LEVEL_TEXT = "LV%s %s"
    
    # This is the maximum level your enemies can achieve. They cannot go higher
    # no exceptions. Adjust this accordingly to fit your game.
    MAX_LEVEL = 99
    
    # Default level calculations for your enemies will be adjusted as such.
    # Type 0 - Lowest level of all actors that have joined.
    # Type 1 - Lowest level in the battle party.
    # Type 2 - Average level of the battle party.
    # Type 3 - Highest level of the battle party.
    # Type 4 - Highest level of all actors that have joined.
    DEFAULT_LEVEL_TYPE = 4
    
    # If you want your enemies to have random +/- levels of some degree, change
    # this number to something other than 0. This is the default value.
    RANDOM_FLUCTUATION = 2
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Parameter Growth Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Here, you adjust how much stats grow for enemies by default, including
    # the formula used to calculate those stats. If you wish for enemies to
    # have different growth settings, use notetags to change them.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These settings adjust the default growth rates (not the base stat formula)
    # for each stat. These are the values that will exist for each enemy unless
    # defined otherwise by the tags inside their noteboxes.
    DEFAULT_GROWTH ={
    # ParamID => [:param, per%, +set],
            0 => [:maxhp, 0.15,   50],
            1 => [:maxmp, 0.10,   10],
            2 => [  :atk, 0.05,    5],
            3 => [  :def, 0.05,    5],
            4 => [  :mat, 0.05,    5],
            5 => [  :mdf, 0.05,    5],
            6 => [  :agi, 0.05,    5],
            7 => [  :luk, 0.05,    5],
            8 => [ :gold, 0.15,   10],
            9 => [  :exp, 0.05,   10],
    } # Do not remove this.
    
    # The following hash will adjust each of the formulas for each base stat.
    # Adjust them as you see fit but only if you know what you're doing.
    #   base  - The base stat from the enemy database.
    #   per   - Growth rate which has not been yet converted to a percent.
    #   set   - Set growth rate. Modified
    # Default:   "base * (1.00 + (level-1) * per) + (set * (level-1))"
    STAT_FORMULA = "base * (1.00 + (level-1) * per) + (set * (level-1))"
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Party Level to Enemy Level Action Conditions -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Setting the below to true will cause the Party Level requirement under
    # Action Conditions in the Action Patterns list to become an Enemy Level
    # requirement. The enemy must be at least the level or else it cannot use
    # the listed action.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    PARTY_LEVEL_TO_ENEMY_LEVEL = true
    
  end # ENEMY_LEVEL
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module USABLEITEM
    
    LEVEL_CHANGE = /<(?:ENEMY LEVEL|enemy level):[ ]([\+\-]\d+)>/i
    LEVEL_RESET  = /<(?:ENEMY LEVEL RESET|enemy level reset)>/i
    
  end # USABLEITEM
  module ENEMY
    
    LEVEL_TYPE = /<(?:LEVEL_TYPE|level type):[ ](\d+)>/i
    LEVEL_MIN = /<(?:MIN_LEVEL|min level|minimum level):[ ](\d+)>/i
    LEVEL_MAX = /<(?:MAX_LEVEL|max level|maximum level):[ ](\d+)>/i
    LEVEL_SET = /<(?:SET_LEVEL|set level|permanent level):[ ](\d+)>/i
    
    LEVEL_RAND = /<(?:LEVEL_RANDOM|level random):[ ](\d+)>/i
    GROWTH_PER = /<(.*):[ ]([\+\-]\d+)([%％])[ ](?:PER_LEVEL|per level)>/i
    GROWTH_SET = /<(.*):[ ]([\+\-]\d+)[ ](?:PER_LEVEL|per level)>/i
    
    HIDE_LEVEL = /<(?:HIDE_LEVEL|hide level)>/i
      
  end # ENEMY
  end # REGEXP
end # YEA

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
  class <<self; alias load_database_elv load_database; end
  def self.load_database
    load_database_elv
    load_notetags_elv
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_elv
  #--------------------------------------------------------------------------
  def self.load_notetags_elv
    groups = [$data_enemies, $data_skills, $data_items]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_elv
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
  attr_accessor :level_change
  attr_accessor :level_reset
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_elv
  #--------------------------------------------------------------------------
  def load_notetags_elv
    @level_change = 0
    @level_reset = false
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::USABLEITEM::LEVEL_CHANGE
        @level_change = $1.to_i
      when YEA::REGEXP::USABLEITEM::LEVEL_RESET
        @level_reset = true
      end
    } # self.note.split
    #---
  end
  
end # RPG::UsableItem

#==============================================================================
# ■ RPG::Enemy
#==============================================================================

class RPG::Enemy < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :hide_level
  attr_accessor :level_type
  attr_accessor :level_min
  attr_accessor :level_max
  attr_accessor :level_rand
  attr_accessor :level_growth
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_elv
  #--------------------------------------------------------------------------
  def load_notetags_elv
    @hide_level = false
    @level_type = YEA::ENEMY_LEVEL::DEFAULT_LEVEL_TYPE
    @level_min = 1
    @level_max = YEA::ENEMY_LEVEL::MAX_LEVEL
    @level_rand = YEA::ENEMY_LEVEL::RANDOM_FLUCTUATION
    @level_growth = Marshal.load(Marshal.dump(YEA::ENEMY_LEVEL::DEFAULT_GROWTH))
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::ENEMY::HIDE_LEVEL
        @hide_level = true
      when YEA::REGEXP::ENEMY::LEVEL_TYPE
        @level_type = $1.to_i
      when YEA::REGEXP::ENEMY::LEVEL_MIN
        @level_min = [$1.to_i, 1].max
      when YEA::REGEXP::ENEMY::LEVEL_MAX
        @level_max = [$1.to_i, YEA::ENEMY_LEVEL::MAX_LEVEL].min
      when YEA::REGEXP::ENEMY::LEVEL_SET
        @level_min = [[$1.to_i, 1].max, YEA::ENEMY_LEVEL::MAX_LEVEL].min
        @level_max = [[$1.to_i, 1].max, YEA::ENEMY_LEVEL::MAX_LEVEL].min
      when YEA::REGEXP::ENEMY::LEVEL_RAND
        @level_rand = $1.to_i
      #---
      when YEA::REGEXP::ENEMY::GROWTH_PER
        case $1.upcase
        when "MAXHP", "MHP", "HP"
          type = 0
        when "MAXMP", "MMP", "MP", "MAXSP", "MSP", "SP"
          type = 1
        when "ATK", "ATTACK"
          type = 2
        when "DEF", "DEFENSE"
          type = 3
        when "MAT", "MAGIC ATTACK", "INT", "INTELLIGENCE", "SPI", "SPIRIT"
          type = 4
        when "MDF", "MAGIC DEFENSE", "RES", "RESISTANCE"
          type = 5
        when "AGI", "AGILITY"
          type = 6
        when "LUK", "LUCK"
          type = 7
        when "GOLD", "MONEY"
          type = 8
        when "EXP", "EXPERIENCE", "XP"
          type = 9
        else; next
        end
        @level_growth[type][1] = $2.to_i * 0.01
      when YEA::REGEXP::ENEMY::GROWTH_SET
        case $1.upcase
        when "MAXHP", "MHP", "HP"
          type = 0
        when "MAXMP", "MMP", "MP", "MAXSP", "MSP", "SP"
          type = 1
        when "ATK", "ATTACK"
          type = 2
        when "DEF", "DEFENSE"
          type = 3
        when "MAT", "MAGIC ATTACK", "INT", "INTELLIGENCE", "SPI", "SPIRIT"
          type = 4
        when "MDF", "MAGIC DEFENSE", "RES", "RESISTANCE"
          type = 5
        when "AGI", "AGILITY"
          type = 6
        when "LUK", "LUCK"
          type = 7
        when "GOLD", "MONEY"
          type = 8
        when "EXP", "EXPERIENCE", "XP"
          type = 9
        else; next
        end
        @level_growth[type][2] = $2.to_i
      end
    } # self.note.split
    #---
  end
  
end # RPG::Enemy

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias method: item_user_effect
  #--------------------------------------------------------------------------
  alias game_battler_item_user_effect_elv item_user_effect
  def item_user_effect(user, item)
    game_battler_item_user_effect_elv(user, item)
    apply_level_changes(item) if self.is_a?(Game_Enemy)
  end
  
end # Game_Battler

#==============================================================================
# ■ Game_Enemy
#==============================================================================

class Game_Enemy < Game_Battler
  
  #--------------------------------------------------------------------------
  # alias method: initialize
  #--------------------------------------------------------------------------
  alias game_enemy_initialize_elv initialize
  def initialize(index, enemy_id)
    game_enemy_initialize_elv(index, enemy_id)
    create_init_level
  end
  
  #--------------------------------------------------------------------------
  # new method: level
  #--------------------------------------------------------------------------
  def level
    create_init_level if @level.nil?
    return @level
  end
  
  #--------------------------------------------------------------------------
  # new method: level=
  #--------------------------------------------------------------------------
  def level=(value)
    create_init_level if @level.nil?
    return if @level == value
    hp_rate = self.hp.to_f / self.mhp.to_f
    mp_rate = self.mp.to_f / [self.mmp, 1].max.to_f
    #@level = [[value, 1].max, YEA::ENEMY_LEVEL::MAX_LEVEL].min
    @level = [[value, @level].max, YEA::ENEMY_LEVEL::MAX_LEVEL].min
    self.hp = (self.mhp * hp_rate).to_i
    self.mp = (self.mmp * mp_rate).to_i
  end
  
  #--------------------------------------------------------------------------
  # new method: create_init_level
  #--------------------------------------------------------------------------
  def create_init_level
    set_level_type
    @hp = mhp
    @mp = mmp
  end
  
  #--------------------------------------------------------------------------
  # new method: set_level_type
  #--------------------------------------------------------------------------
  def set_level_type
    @level = $game_party.match_party_level(enemy.level_type)
    @level += rand(enemy.level_rand+1)
    @level -= rand(enemy.level_rand+1)
    @level = [[@level, enemy.level_max].min, enemy.level_min].max
  end
  
  #--------------------------------------------------------------------------
  # alias method: transform
  #--------------------------------------------------------------------------
  alias game_enemy_transform_elv transform
  def transform(enemy_id)
    game_enemy_transform_elv(enemy_id)
    create_init_level
  end
  
  #--------------------------------------------------------------------------
  # new method: apply_level_changes
  #--------------------------------------------------------------------------
  def apply_level_changes(item)
    create_init_level if item.level_reset
    self.level += item.level_change
  end
  
  #--------------------------------------------------------------------------
  # alias method: param_base
  #--------------------------------------------------------------------------
  alias game_enemy_param_base_elv param_base
  def param_base(param_id)
    base = game_enemy_param_base_elv(param_id)
    per = enemy.level_growth[param_id][1]
    set = enemy.level_growth[param_id][2]
    total = eval(YEA::ENEMY_LEVEL::STAT_FORMULA)
    return total.to_i
  end
  
  #--------------------------------------------------------------------------
  # alias method: exp
  #--------------------------------------------------------------------------
  alias game_enemy_exp_elv exp
  def exp
    base = game_enemy_exp_elv
    per = enemy.level_growth[9][1]
    set = enemy.level_growth[9][2]
    total = eval(YEA::ENEMY_LEVEL::STAT_FORMULA)
    return total.to_i
  end
  
  #--------------------------------------------------------------------------
  # alias method: gold
  #--------------------------------------------------------------------------
  alias game_enemy_gold_elv gold
  def gold
    base = game_enemy_gold_elv
    per = enemy.level_growth[8][1]
    set = enemy.level_growth[8][2]
    total = eval(YEA::ENEMY_LEVEL::STAT_FORMULA)
    return total.to_i
  end
  
  #--------------------------------------------------------------------------
  # alias method: name
  #--------------------------------------------------------------------------
  alias game_enemy_name_elv name
  def name
    text = game_enemy_name_elv
    if add_level_name?
      fmt = YEA::ENEMY_LEVEL::LEVEL_TEXT
      text = sprintf(fmt, @level.group, text)
    end
    return text
  end
  
  #--------------------------------------------------------------------------
  # new method: add_level_name?
  #--------------------------------------------------------------------------
  def add_level_name?
    if $imported["YEA-EnemyTargetInfo"] && show_info_param?
      return true
    end
    return false if enemy.hide_level
    return true
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: conditions_met_party_level?
  #--------------------------------------------------------------------------
  if YEA::ENEMY_LEVEL::PARTY_LEVEL_TO_ENEMY_LEVEL
  def conditions_met_party_level?(param1, param2)
    return @level >= param1
  end
  end
  
end # Game_Enemy

#==============================================================================
# ■ Game_Party
#==============================================================================

class Game_Party < Game_Unit
  
  #--------------------------------------------------------------------------
  # new method: match_party_level
  #--------------------------------------------------------------------------
  def match_party_level(level_type)
    case level_type
    when 0; return all_lowest_level
    when 1; return lowest_level
    when 2; return average_level
    when 3; return highest_level
    else;   return all_highest_level
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: all_lowest_level
  #--------------------------------------------------------------------------
  def all_lowest_level
    lv = all_members.collect {|actor| actor.level }.min
    return lv
  end
  
  #--------------------------------------------------------------------------
  # new method: lowest_level
  #--------------------------------------------------------------------------
  def lowest_level
    lv = members.collect {|actor| actor.level }.min
    return lv
  end
  
  #--------------------------------------------------------------------------
  # new method: average_level
  #--------------------------------------------------------------------------
  def average_level
    lv = 0
    for member in all_members; lv += member.level; end
    lv /= all_members.size
    return lv
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: highest_level
  #--------------------------------------------------------------------------
  def highest_level
    lv = members.collect {|actor| actor.level }.max
    return lv
  end
  
  #--------------------------------------------------------------------------
  # all method: all_highest_level
  #--------------------------------------------------------------------------
  def all_highest_level
    lv = all_members.collect {|actor| actor.level }.max
    return lv
  end
  
end # Game_Party

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================
