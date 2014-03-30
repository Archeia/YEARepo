#==============================================================================
# 
# ▼ Yanfly Engine Ace - Steal Items v1.03
# -- Last Updated: 2012.01.09
# -- Level: Normal, Hard
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-StealItems"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.09 - Bug Fixed: Snatch item crash.
# 2012.01.01 - Fixed definition overlap.
# 2011.12.30 - Added message to indicate an enemy has nothing left to steal.
# 2011.12.21 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Stealing items has been something that's became a staple in many RPG's. It's
# a great way for players to acquire new items and a fun way, too. This script
# adds in the functionality to steal items through either blind stealing,
# stealing specific types, or stealing even specific items. Furthermore, this
# script gives the LUK stat more functionality by having it add to the success
# rate of stealing an item.
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
# <steal rate: +x%>
# <steal rate: -x%>
# Sets the bonus steal rate to increase or decrease by x%.
# 
# <steal type rate: +x%>
# <steal type rate: -x%>
# Sets the bonus steal rate for that specific type of item by +x% or -x%.
# Replace "type" with "item", "weapon", "armour", or "gold".
# 
# -----------------------------------------------------------------------------
# Class Notetags - These notetags go in the class notebox in the database.
# -----------------------------------------------------------------------------
# <steal rate: +x%>
# <steal rate: -x%>
# Sets the bonus steal rate to increase or decrease by x%.
# 
# <steal type rate: +x%>
# <steal type rate: -x%>
# Sets the bonus steal rate for that specific type of item by +x% or -x%.
# Replace "type" with "item", "weapon", "armour", or "gold".
# 
# -----------------------------------------------------------------------------
# Skill Notetags - These notetags go in the skills notebox in the database.
# -----------------------------------------------------------------------------
# <steal>
# <steal: +x%>
# <steal: -x%>
# This gives the skill a blind steal property, allowing it to steal a random
# item the enemy has, if the enemy has any items to steal. If the 2nd/3rd tag
# is used, the success rate will increase by +x% (or decrease).
# 
# <steal type>
# <steal type: +x%>
# <steal type: -x%>
# This gives the skill the ability to only be able to steal items of that type.
# Anything that is outside of that type list cannot be stolen. If the 2nd/3rd
# tag is used, the success rate will increase by +x% (or decrease). Replace
# "type" with "item", "weapon", "armour", or "gold". Insert multiple of these
# tags to increase the types that can be stolen.
# 
# <snatch>
# <snatch: +x%>
# <snatch: -x%>
# This gives the skill a snatch property, which allows the player to select a
# specific stealable item on the enemy. If the 2nd/3rd tag is used, the
# success rate will increase by +x% (or decrease). Snatch only works for single
# target enemy skills.
# 
# <snatch type>
# <snatch type: +x%>
# <snatch type: -x%>
# This gives the skill a snatch property, which allows the player to select a
# specific selectable item on the enemy. However, this tag limits the types of
# items that can be stolen. If the 2nd/3rd tag is used, the success rate will
# increase by +x% (or decrease). Replace "type" with "item", "weapon",
# "armour", or "gold". Insert multiple of these tags to increase the types
# that can be stolen. Snatch only works for single target enemy skills.
# 
# -----------------------------------------------------------------------------
# Item Notetags - These notetags go in the items notebox in the database.
# -----------------------------------------------------------------------------
# <steal>
# <steal: +x%>
# <steal: -x%>
# This gives the item a blind steal property, allowing it to steal a random
# item the enemy has, if the enemy has any items to steal. If the 2nd/3rd tag
# is used, the success rate will increase by +x% (or decrease).
# 
# <steal type>
# <steal type: +x%>
# <steal type: -x%>
# This gives the item the ability to only be able to steal items of that type.
# Anything that is outside of that type list cannot be stolen. If the 2nd/3rd
# tag is used, the success rate will increase by +x% (or decrease). Replace
# "type" with "item", "weapon", "armour", or "gold". Insert multiple of these
# tags to increase the types that can be stolen.
# 
# <snatch>
# <snatch: +x%>
# <snatch: -x%>
# This gives the item a snatch property, which allows the player to select a
# specific stealable item on the enemy. If the 2nd/3rd tag is used, the
# success rate will increase by +x% (or decrease). Snatch only works for single
# target enemy skills.
# 
# <snatch type>
# <snatch type: +x%>
# <snatch type: -x%>
# This gives the item a snatch property, which allows the player to select a
# specific selectable item on the enemy. However, this tag limits the types of
# items that can be stolen. If the 2nd/3rd tag is used, the success rate will
# increase by +x% (or decrease). Replace "type" with "item", "weapon",
# "armour", or "gold". Insert multiple of these tags to increase the types
# that can be stolen. Snatch only works for single target enemy skills.
# 
# -----------------------------------------------------------------------------
# Weapon Notetags - These notetags go in the weapons notebox in the database.
# -----------------------------------------------------------------------------
# <steal rate: +x%>
# <steal rate: -x%>
# Sets the bonus steal rate to increase or decrease by x%.
# 
# <steal type rate: +x%>
# <steal type rate: -x%>
# Sets the bonus steal rate for that specific type of item by +x% or -x%.
# Replace "type" with "item", "weapon", "armour", or "gold".
# 
# -----------------------------------------------------------------------------
# Armour Notetags - These notetags go in the armours notebox in the database.
# -----------------------------------------------------------------------------
# <steal rate: +x%>
# <steal rate: -x%>
# Sets the bonus steal rate to increase or decrease by x%.
# 
# <steal type rate: +x%>
# <steal type rate: -x%>
# Sets the bonus steal rate for that specific type of item by +x% or -x%.
# Replace "type" with "item", "weapon", "armour", or "gold".
# 
# -----------------------------------------------------------------------------
# Enemy Notetags - These notetags go in the enemy notebox in the database.
# -----------------------------------------------------------------------------
# <steal Ix: y%>
# <steal Wx: y%>
# <steal Ax: y%>
# <steal Gx: y%>
# Gives enemy a stealable item, weapon, or armour (marked by I, W, or A) x at
# a rate of y percent. If G is used, that is how much gold can be stolen from
# the enemy. Insert multiples of this tag to increase the number of stolen
# items an enemy can possibly have.
# 
# <steal rate: -x%>
# <steal rate: +x%>
# This is the defending modifier used for enemy. All success rate calculations
# will apply the defending enemy's steal rate against success.
# 
# -----------------------------------------------------------------------------
# State Notetags - These notetags go in the states notebox in the database.
# -----------------------------------------------------------------------------
# <steal rate: +x%>
# <steal rate: -x%>
# Sets the bonus steal rate to increase or decrease by x%.
# 
# <steal type rate: +x%>
# <steal type rate: -x%>
# Sets the bonus steal rate for that specific type of item by +x% or -x%.
# Replace "type" with "item", "weapon", "armour", or "gold".
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module STEAL
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - General Steal Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Adjust the general settings for stealing here. These settings involve
    # the text that appear, the sound effects played, the steal bonus rate,
    # and whether or not stealing a weapon or piece of armour will reduce the
    # enemy's stats, and various visual settings. Adjust them as you see fit.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    STEAL_FAIL_TEXT    = "%s couldn't steal an item."         # Failed steal.
    STEAL_SUCCESS_TEXT = "%s steals \ec[17]%s\ec[0] from %s!" # Successful.
    STEAL_EMPTY_TEXT   = "%s has nothing left to steal."      # Emptied out.
    SNATCH_RATE_TEXT   = "%1.2f%%"      # Percentage display for steal rate.
    SNATCH_RATE_SIZE   = 20             # Font size used for rate text.
    
    # These settings adjust the sound effect played when a successful steal
    # takes place and acquires one of the following item types:
    STEAL_ITEM_SFX   = RPG::SE.new("Item3", 80, 150)    # Item stolen.
    STEAL_WEAPON_SFX = RPG::SE.new("Equip1", 80, 150)   # Weapon stolen.
    STEAL_ARMOUR_SFX = RPG::SE.new("Equip2", 80, 150)   # Armour stolen.
    STEAL_GOLD_SFX   = RPG::SE.new("Coin", 80, 100)     # Gold stolen.
    
    # These settings here adjust the maximum and minimum success rates.
    MAXIMUM_RATE = 0.9999
    MINIMUM_RATE = 0.0001
    
    # Adjust the steal bonus rate (sbr) formula here. This is the bonus rate
    # that is added onto steal rates.
    STEAL_BONUS_RATE = "(user.luk/(512.0+user.luk))*0.3333"
    
    # If a weapon or piece of armour is stolen from an enemy, choose to lower
    # the enemy's stats relative to the stats of the piece of equipment?
    STEAL_LOWER_STATS = true
    
    # This sets the gold icon used for stealing items and shown in the snatch
    # window when an item selected for stealing.
    GOLD_ICON = 262
    
    # This is the description used for gold when gold is selected for snatching.
    GOLD_DESCRIPTION    = "Steal some Gold, the currency used everywhere."
    NOTHING_DESCRIPTION = "There is nothing to steal."
    
  end # STEAL
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module BASEITEM
    
    STEAL_RATE = /<(?:STEAL_RATE|steal rate):[ ]([\+\-]\d+)([%％])>/i
    STEAL_ITEM_RATE = 
      /<(?:STEAL|steal)[ ](.*)[ ](?:RATE|rate):[ ]([\+\-]\d+)([%％])>/i
    
  end # BASEITEM
  module USABLEITEM
    
    STEAL_BLIND = /<(.*)>/i
    STEAL_BLIND_RATE = /<(.*):[ ]([\+\-]\d+)([%％])>/i
    STEAL_ITEM  = /<(.*)[ ](.*)>/i
    STEAL_ITEM_RATE = /<(.*)[ ](.*):[ ]([\+\-]\d+)([%％])>/i
    
  end # USABLEITEM
  module ENEMY
    
    STEAL_ITEM = /<(?:STEAL|steal)[ ]([IWAG])(\d+):[ ](\d+)([%％])>/i
    STEAL_RATE = /<(?:STEAL_RATE|steal rate):[ ]([\+\-]\d+)([%％])>/i
    
  end # ENEMY
  end # REGEXP
end # YEA

#==============================================================================
# ■ Icon
#==============================================================================

module Icon
  
  #--------------------------------------------------------------------------
  # self.steal_gold
  #--------------------------------------------------------------------------
  def self.steal_gold; return YEA::STEAL::GOLD_ICON; end
    
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
  class <<self; alias load_database_steal load_database; end
  def self.load_database
    load_database_steal
    load_notetags_steal
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_steal
  #--------------------------------------------------------------------------
  def self.load_notetags_steal
    groups = [$data_enemies, $data_skills, $data_items, $data_actors,
      $data_classes, $data_weapons, $data_armors, $data_states]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_steal
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
  attr_accessor :steal_rate
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_steal
  #--------------------------------------------------------------------------
  def load_notetags_steal
    @steal_rate = [0.0, 0.0, 0.0, 0.0, 0.0]
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::BASEITEM::STEAL_RATE
        @steal_rate[0] = $1.to_i * 0.01
      when YEA::REGEXP::BASEITEM::STEAL_ITEM_RATE
        case $1.upcase
        when "ITEM", "ITEMS"
          @steal_rate[1] = $2.to_i * 0.01
        when "WEAPON", "WEAPONS"
          @steal_rate[2] = $2.to_i * 0.01
        when "ARMOUR", "ARMOURS", "ARMOR", "ARMORS"
          @steal_rate[3] = $2.to_i * 0.01
        when "GOLD"
          @steal_rate[4] = $2.to_i * 0.01
        else; next
        end
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
  attr_accessor :steal_type
  attr_accessor :steal_rate
  attr_accessor :steal_kind
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_steal
  #--------------------------------------------------------------------------
  def load_notetags_steal
    @steal_type = nil
    @steal_rate = [0.0, 0.0, 0.0, 0.0, 0.0]
    @steal_kind = []
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::USABLEITEM::STEAL_ITEM_RATE
        case $1.upcase
        when "STEAL"
          @steal_type = :steal
        when "SNATCH"
          @steal_type = :snatch
        else; next
        end
        case $2.upcase
        when "ITEM", "ITEMS"
          @steal_kind.push(1)
          @steal_rate[1] += $3.to_i * 0.01
        when "WEAPON", "WEAPONS"
          @steal_kind.push(2)
          @steal_rate[2] += $3.to_i * 0.01
        when "ARMOUR", "ARMOURS", "ARMOR", "ARMORS"
          @steal_kind.push(3)
          @steal_rate[3] += $3.to_i * 0.01
        when "GOLD"
          @steal_kind.push(4)
          @steal_rate[4] += $3.to_i * 0.01
        end
      when YEA::REGEXP::USABLEITEM::STEAL_ITEM
        case $1.upcase
        when "STEAL"
          @steal_type = :steal
        when "SNATCH"
          @steal_type = :snatch
        else; next
        end
        case $2.upcase
        when "ITEM", "ITEMS"
          @steal_kind.push(1)
        when "WEAPON", "WEAPONS"
          @steal_kind.push(2)
        when "ARMOUR", "ARMOURS", "ARMOR", "ARMORS"
          @steal_kind.push(3)
        when "GOLD"
          @steal_kind.push(4)
        end
      when YEA::REGEXP::USABLEITEM::STEAL_BLIND_RATE
        case $1.upcase
        when "STEAL"
          @steal_type = :steal
        when "SNATCH"
          @steal_type = :snatch
        else; next
        end
        @steal_rate[0] += $2.to_i * 0.01
        @steal_kind = [1, 2, 3, 4]
      when YEA::REGEXP::USABLEITEM::STEAL_BLIND
        case $1.upcase
        when "STEAL"
          @steal_type = :steal
        when "SNATCH"
          @steal_type = :snatch
        else; next
        end
        @steal_kind = [1, 2, 3, 4]
      end
    } # self.note.split
    #---
  end
  
end # class RPG::UsableItem

#==============================================================================
# ■ RPG::Enemy
#==============================================================================

class RPG::Enemy < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :stealable_items
  attr_accessor :steal_rate
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_steal
  #--------------------------------------------------------------------------
  def load_notetags_steal
    @stealable_items = []
    @steal_rate = 0.0
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::ENEMY::STEAL_ITEM
        case $1.upcase
        when "I"; type = 1
        when "W"; type = 2
        when "A"; type = 3
        when "G"; type = 4
        else; next
        end
        data_id = $2.to_i
        rate = $3.to_i * 0.01
        @stealable_items.push(RPG::Enemy::StealItem.new(type, data_id, rate))
      when YEA::REGEXP::ENEMY::STEAL_RATE
        @steal_rate = $1.to_i * 0.01
      end
    } # self.note.split
    #---
  end
  
end # RPG::Enemy

#==============================================================================
# ■ RPG::Enemy::StealItem
#==============================================================================

class RPG::Enemy::StealItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :kind
  attr_accessor :data_id
  attr_accessor :rate
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(kind = 0, data_id = 1, rate = 0.0)
    @kind = kind
    @data_id = data_id
    @rate = rate
  end
  
end # RPG::Enemy::StealItem

#==============================================================================
# ■ Game_Temp
#==============================================================================

class Game_Temp
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :steal_skill
  attr_accessor :snatch_target
  
  #--------------------------------------------------------------------------
  # alias method: initialize
  #--------------------------------------------------------------------------
  alias game_temp_initialize_steal initialize
  def initialize
    game_temp_initialize_steal
    @snatch_target = {}
  end
  
end # Game_Temp

#==============================================================================
# ■ Game_ActionResult
#==============================================================================

class Game_ActionResult
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :stolen_item
  
  #--------------------------------------------------------------------------
  # alias method: clear_hit_flags
  #--------------------------------------------------------------------------
  alias game_actionresult_clear_hit_flags_steal clear_hit_flags
  def clear_hit_flags
    game_actionresult_clear_hit_flags_steal
    @stolen_item = nil
  end
  
end # Game_ActionResult

#==============================================================================
# ■ Game_BattlerBase
#==============================================================================

class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias method: initialize
  #--------------------------------------------------------------------------
  alias game_battlerbase_initialize_steal initialize
  def initialize
    game_battlerbase_initialize_steal
    init_stealable_items unless self.is_a?(Game_Enemy)
  end
  
  #--------------------------------------------------------------------------
  # new method: init_stealable_items
  #--------------------------------------------------------------------------
  def init_stealable_items; @stealable_items = []; end
  
  #--------------------------------------------------------------------------
  # new method: stealable_items
  #--------------------------------------------------------------------------
  def stealable_items
    init_stealable_items if @stealable_items.nil?
    return @stealable_items
  end
  
  #--------------------------------------------------------------------------
  # new method: remove_stealable_item
  #--------------------------------------------------------------------------
  def remove_stealable_item(stealable_item)
    init_stealable_items if @stealable_items.nil?
    @stealable_items.delete(stealable_item)
  end
  
end # Game_BattlerBase

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias method: item_user_effect
  #--------------------------------------------------------------------------
  alias game_battler_item_user_effect_steal item_user_effect
  def item_user_effect(user, item)
    game_battler_item_user_effect_steal(user, item)
    execute_steal_effect(user, item)
  end
  
  #--------------------------------------------------------------------------
  # new method: execute_steal_effect
  #--------------------------------------------------------------------------
  def execute_steal_effect(user, item)
    return if self.actor?
    return if self.actor? == user.actor?
    return if item.steal_type.nil?
    return if stealable_items == []
    apply_steal_effect(user, item) if item.steal_type == :steal
    apply_snatch_effect(user, item) if item.steal_type == :snatch
    lower_stats_steal_effect
  end
  
  #--------------------------------------------------------------------------
  # new method: apply_blind_steal_effect
  #--------------------------------------------------------------------------
  def lower_stats_steal_effect
    return unless YEA::STEAL::STEAL_LOWER_STATS
    return if @result.stolen_item.nil?
    case @result.stolen_item.kind
    when 2
      item = $data_weapons[@result.stolen_item.data_id]
    when 3
      item = $data_armors[@result.stolen_item.data_id]
    else; return
    end
    for i in 0...8
      add_param(i, -item.params[i])
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: apply_steal_effect
  #--------------------------------------------------------------------------
  def apply_steal_effect(user, item)
    for stealable_item in stealable_items
      next unless item.steal_kind.include?(stealable_item.kind)
      next unless (rand < calc_steal_ratio(user, item, stealable_item))
      @result.stolen_item = stealable_item
      @result.success = true
      break
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: calc_steal_ratio
  #--------------------------------------------------------------------------
  def calc_steal_ratio(user, item, stealable_item)
    rate = stealable_item.rate
    rate += item.steal_rate[0]
    rate += item.steal_rate[stealable_item.kind]
    rate += eval(YEA::STEAL::STEAL_BONUS_RATE)
    rate += user.bonus_steal_rate(0)
    rate += user.bonus_steal_rate(stealable_item.kind)
    rate += enemy.steal_rate
    max_rate = YEA::STEAL::MAXIMUM_RATE
    min_rate = YEA::STEAL::MINIMUM_RATE
    return [[max_rate, rate].min, min_rate].max
  end
  
  #--------------------------------------------------------------------------
  # new method: apply_snatch_effect
  #--------------------------------------------------------------------------
  def apply_snatch_effect(user, item)
    snatch_item = $game_temp.snatch_target[user]
    return unless stealable_items.include?(snatch_item)
    if rand < calc_steal_ratio(user, item, snatch_item)
      @result.stolen_item = snatch_item
      @result.success = true
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: bonus_steal_rate
  #--------------------------------------------------------------------------
  def bonus_steal_rate(kind)
    n = 0.0
    if actor?
      n += self.actor.steal_rate[kind]
      n += self.class.steal_rate[kind]
      for equip in equips
        next if equip.nil?
        n += equip.steal_rate[kind]
      end
    end
    for state in states
      next if state.nil?
      n += state.steal_rate[kind]
    end
    return n
  end
  
end # Game_Battler

#==============================================================================
# ■ Game_Enemy
#==============================================================================

class Game_Enemy < Game_Battler
  
  #--------------------------------------------------------------------------
  # alias method: initialize
  #--------------------------------------------------------------------------
  alias game_enemy_initialize_steal initialize
  def initialize(index, enemy_id)
    game_enemy_initialize_steal(index, enemy_id)
    init_stealable_items
  end
  
  #--------------------------------------------------------------------------
  # new method: init_stealable_items
  #--------------------------------------------------------------------------
  def init_stealable_items
    @stealable_items = enemy.stealable_items.clone
  end
  
end # Game_Enemy

#==============================================================================
# ■ Window_StealList
#==============================================================================

class Window_StealList < Window_Selectable
  
  #--------------------------------------------------------------------------
  # alias method: on_skill_ok
  #--------------------------------------------------------------------------
  def initialize(enemy_window)
    wh = fitting_height(4)
    super(0, Graphics.height - wh, Graphics.width, wh)
    self.z = 200
    deactivate
    hide
    @enemy_window = enemy_window
    @enemy = nil
  end
  
  #--------------------------------------------------------------------------
  # col_max
  #--------------------------------------------------------------------------
  def col_max; return 2; end
  
  #--------------------------------------------------------------------------
  # item_max
  #--------------------------------------------------------------------------
  def item_max; return @data ? @data.size : 1; end
    
  #--------------------------------------------------------------------------
  # item
  #--------------------------------------------------------------------------
  def item; @data[index]; end
  
  #--------------------------------------------------------------------------
  # current_item_enabled?
  #--------------------------------------------------------------------------
  def current_item_enabled?; return !item.nil?; end
  
  #--------------------------------------------------------------------------
  # alias method: on_skill_ok
  #--------------------------------------------------------------------------
  def refresh
    make_item_list
    create_contents
    draw_all_items
    show
    activate
    select(0)
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_skill_ok
  #--------------------------------------------------------------------------
  def make_item_list
    @enemy = @enemy_window.enemy
    @data = @enemy.stealable_items.select {|item| include?(item) }
  end
  
  #--------------------------------------------------------------------------
  # include?
  #--------------------------------------------------------------------------
  def include?(item); return steal_skill.steal_kind.include?(item.kind); end
  
  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    return if item.nil?
    rect = item_rect(index)
    rect.width -= 4
    reset_font_settings
    draw_stolenitem_name(item, rect)
    draw_item_rate(item, rect)
  end
  
  #--------------------------------------------------------------------------
  # draw_stolenitem_name
  #--------------------------------------------------------------------------
  def draw_stolenitem_name(stolen_item, rect)
    case stolen_item.kind
    when 1; item = $data_items[stolen_item.data_id]
    when 2; item = $data_weapons[stolen_item.data_id]
    when 3; item = $data_armors[stolen_item.data_id]
    when 4
      draw_gold(stolen_item, rect)
      return
    end
    draw_item_name(item, rect.x, rect.y, true, rect.width - 24)
  end
  
  #--------------------------------------------------------------------------
  # draw_gold
  #--------------------------------------------------------------------------
  def draw_gold(stolen_item, rect)
    draw_icon(Icon.steal_gold, rect.x, rect.y)
    amount = stolen_item.data_id.group
    amount += Vocab.currency_unit
    draw_text(rect.x+24, rect.y, rect.width - 24, line_height, amount)
  end
  
  #--------------------------------------------------------------------------
  # steal_skill
  #--------------------------------------------------------------------------
  def steal_skill; return $game_temp.steal_skill; end
  
  #--------------------------------------------------------------------------
  # draw_item_rate
  #--------------------------------------------------------------------------
  def draw_item_rate(stolen_item, rect)
    user = BattleManager.actor
    rate = @enemy.calc_steal_ratio(user, steal_skill, stolen_item)
    fmt = YEA::STEAL::SNATCH_RATE_TEXT
    text = sprintf(fmt, rate * 100.0)
    contents.font.size = YEA::STEAL::SNATCH_RATE_SIZE
    draw_text(rect, text, 2)
  end
  
  #--------------------------------------------------------------------------
  # update_help
  #--------------------------------------------------------------------------
  def update_help
    if @data.nil? || item.nil?
      @help_window.set_text(YEA::STEAL::NOTHING_DESCRIPTION)
      return
    end
    case item.kind
    when 1; @help_window.set_text($data_items[item.data_id].description)
    when 2; @help_window.set_text($data_weapons[item.data_id].description)
    when 3; @help_window.set_text($data_armors[item.data_id].description)
    when 4; @help_window.set_text(YEA::STEAL::GOLD_DESCRIPTION)
    end
  end
  
end # Window_StealList

#==============================================================================
# ■ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: on_skill_ok
  #--------------------------------------------------------------------------
  alias scene_battle_create_enemy_window_steal create_enemy_window
  def create_enemy_window
    scene_battle_create_enemy_window_steal
    create_steallist_window
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_skill_ok
  #--------------------------------------------------------------------------
  def create_steallist_window
    wy = @help_window.height
    @steallist_window = Window_StealList.new(@enemy_window)
    @steallist_window.help_window = @help_window
    @steallist_window.set_handler(:ok,     method(:on_steal_ok))
    @steallist_window.set_handler(:cancel, method(:on_steal_cancel))
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_enemy_ok
  #--------------------------------------------------------------------------
  alias scene_battle_on_enemy_ok_steal on_enemy_ok
  def on_enemy_ok
    if show_steal_window?
      activate_steal_window
    else
      scene_battle_on_enemy_ok_steal
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: activate_steal_window
  #--------------------------------------------------------------------------
  def activate_steal_window
    @steallist_window.refresh
    if $imported["YEA-BattleEngine"]
      @skill_window.hide
      @item_window.hide
      @status_aid_window.hide
      @help_window.show
    else
      @info_viewport.visible = false
      @enemy_window.hide
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: show_steal_window?
  #--------------------------------------------------------------------------
  def show_steal_window?
    if @item_window.visible
      $game_temp.steal_skill = @item_window.item
    elsif @skill_window.visible
      $game_temp.steal_skill = @skill_window.item
    else
      return false
    end
    return false if $game_temp.steal_skill.for_friend?
    return false unless $game_temp.steal_skill.need_selection?
    return $game_temp.steal_skill.steal_type == :snatch
  end
  
  #--------------------------------------------------------------------------
  # new method: on_steal_ok
  #--------------------------------------------------------------------------
  def on_steal_ok
    $game_temp.snatch_target[BattleManager.actor] = @steallist_window.item
    show_hidden_steal_windows
    scene_battle_on_enemy_ok_steal
  end
  
  #--------------------------------------------------------------------------
  # new method: on_steal_cancel
  #--------------------------------------------------------------------------
  def on_steal_cancel
    show_hidden_steal_windows
    @enemy_window.show
    @enemy_window.activate
  end
  
  #--------------------------------------------------------------------------
  # new method: show_hidden_steal_windows
  #--------------------------------------------------------------------------
  def show_hidden_steal_windows
    @steallist_window.hide
    if $imported["YEA-BattleEngine"]
      @status_aid_window.show
      @item_window.show if @actor_command_window.current_symbol == :item
      @skill_window.show if @actor_command_window.current_symbol == :skill
    else
      @info_viewport.visible = true
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: apply_item_effects
  #--------------------------------------------------------------------------
  alias scene_battle_apply_item_effects_steal apply_item_effects
  def apply_item_effects(target, item)
    scene_battle_apply_item_effects_steal(target, item)
    apply_steal_results(target, item)
  end
  
  #--------------------------------------------------------------------------
  # new method: apply_steal_results
  #--------------------------------------------------------------------------
  def apply_steal_results(target, item)
    return if target.actor?
    return if item.steal_type.nil?
    if target.stealable_items.empty?
      fmt = YEA::STEAL::STEAL_EMPTY_TEXT
      text = sprintf(fmt, target.name)
    elsif target.result.stolen_item.nil?
      fmt = YEA::STEAL::STEAL_FAIL_TEXT
      text = sprintf(fmt, @subject.name)
    else
      fmt = YEA::STEAL::STEAL_SUCCESS_TEXT
      actor = @subject.name
      item = stolen_item_text(target)
      enemy = target.name
      text = sprintf(fmt, actor, item, enemy)
    end
    @log_window.add_text(text)
    3.times do @log_window.wait end
    @log_window.back_one
  end
  
  #--------------------------------------------------------------------------
  # new method: stolen_item_text
  #--------------------------------------------------------------------------
  def stolen_item_text(target)
    stolen_item = target.result.stolen_item
    target.remove_stealable_item(stolen_item)
    case stolen_item.kind
    when 1 # Item
      YEA::STEAL::STEAL_ITEM_SFX.play
      item = $data_items[stolen_item.data_id]
    when 2 # Weapon
      YEA::STEAL::STEAL_WEAPON_SFX.play
      item = $data_weapons[stolen_item.data_id]
    when 3 # Armour
      YEA::STEAL::STEAL_ARMOUR_SFX.play
      item = $data_armors[stolen_item.data_id]
    when 4 # Gold
      YEA::STEAL::STEAL_GOLD_SFX.play
      $game_party.gain_gold(stolen_item.data_id)
      fmt = "\ei[%d]%s%s"
      value = stolen_item.data_id.group
      return sprintf(fmt, Icon.steal_gold, value, Vocab.currency_unit)
    end
    $game_party.gain_item(item, 1)
    text = sprintf("\ei[%d]%s", item.icon_index, item.name)
    return text
  end
  
end # Scene_Battle

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================