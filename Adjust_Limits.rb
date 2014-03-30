#==============================================================================
# 
# ▼ Yanfly Engine Ace - Adjust Limits v1.00
# -- Last Updated: 2011.12.03
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-AdjustLimits"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.03 - Finished Script.
# 2011.12.02 - Started Script.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# There exists some limitations in RPG Maker VX Ace that not everybody's fond
# of. With this script, you can easily adjust the limits of each limitation.
# Here's the list of various limits that can be changed:
# 
# - Gold Max  - Have more than 99,999,999 gold.
# - Item Max  - Have more than 99 items. Customizable per item, too.
# - Level Max - Exceed 99 levels. Parameters are automatically calculated based
#               on the level 99 and level 98 stats in the class parameters.
# - Stat Max  - Stats can exceed 999. Does not adjust for current formulas.
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
# <initial level: x>
# Sets the initial level for the specific actor. Can go above level 99 as long
# as the max level is higher than 99. Default initial level limit is 99.
# 
# <max level: x>
# Sets the max level for the specific actor. Can go above level 99 as long as
# the higher limit is defined in the module. Default max level is level 99.
# 
# -----------------------------------------------------------------------------
# Class Notetags - These notetags go in the class notebox in the database.
# -----------------------------------------------------------------------------
# <learn at level: x>
# This actually goes inside of the skill learning "notes" box. Replace x with
# the level you wish for the class to learn the skill at. This enables classes
# to learn new skills past level 99.
# 
# -----------------------------------------------------------------------------
# Item Notetags - These notetags go in the items notebox in the database.
# -----------------------------------------------------------------------------
# <max limit: x>
# Changes the maximum number of items that can be held from whatever the
# normal amount that can be held. Default amount is 99.
# 
# <price: x>
# Changes the price of the item to x. Allows you to go over the price of
# 999,999 gold if your maximum gold exceeds that amount. Default maximum gold
# is 99,999,999 gold.
# 
# -----------------------------------------------------------------------------
# Weapon Notetags - These notetags go in the weapons notebox in the database.
# -----------------------------------------------------------------------------
# <max limit: x>
# Changes the maximum number of items that can be held from whatever the
# normal amount that can be held. Default amount is 99.
# 
# <price: x>
# Changes the price of the item to x. Allows you to go over the price of
# 999,999 gold if your maximum gold exceeds that amount. Default maximum gold
# is 99,999,999 gold.
# 
# <stat: +x>
# <stat: -x>
# Changes the stat bonus of the piece of equipment to yield +x or -x. Allows
# bonus to go over +500 and under -500. Replace stat with one of the following:
# MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, LUK
# 
# -----------------------------------------------------------------------------
# Armour Notetags - These notetags go in the armours notebox in the database.
# -----------------------------------------------------------------------------
# <max limit: x>
# Changes the maximum number of items that can be held from whatever the
# normal amount that can be held. Default amount is 99.
# 
# <price: x>
# Changes the price of the item to x. Allows you to go over the price of
# 999,999 gold if your maximum gold exceeds that amount. Default maximum gold
# is 99,999,999 gold.
# 
# <stat: +x>
# <stat: -x>
# Changes the stat bonus of the piece of equipment to yield +x or -x. Allows
# bonus to go over +500 and under -500. Replace stat with one of the following:
# MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, LUK
# 
# -----------------------------------------------------------------------------
# Enemy Notetags - These notetags go in the enemy notebox in the database.
# -----------------------------------------------------------------------------
# <stat: x>
# Changes the stat of the enemy to x value. Allows going over the database max
# values. Replace stat with one of the following:
# MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, LUK, EXP, GOLD
# 
# -----------------------------------------------------------------------------
# Script Calls - These commands are used with script calls.
# -----------------------------------------------------------------------------
# gain_gold(x)
# lose_gold(x)
# Causes the player to gain/lose x gold. Allows you to go over 9,999,999 gold.
# Default maximum gold is 99,999,999.
# 
# gain_item(x, y)
# lose_item(x, y)
# gain_weapon(x, y)
# lose_weapon(x, y)
# gain_armour(x, y)
# lose_armour(x, y)
# Causes the player to gain/lose x item in y amount. Allows you to go over 99
# quantity. Default quantity is 99.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module LIMIT
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Gold Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Adjust gold settings here. You can change the maximum amount of gold to
    # whatever you want. In addition to that, you can also adjust whether or
    # not you wish for your gold display to show an icon instead, (and change
    # the font size if needed). If there's too much gold that's to be displayed
    # then you can change the text shown in place of that.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    GOLD_MAX  = 999999999999999  # Maximum gold.
    GOLD_ICON = 361              # Icon used for gold. Use 0 for text currency.
    GOLD_FONT = 16               # Font size used to display gold.
    TOO_MUCH_GOLD = "A lotta gold!"   # Text used when gold cannot fit.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Item Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Adjust item settings here. You can change the maximum number of items
    # held from 99 to whatever you want. In addition to that, change the prefix
    # used for items when shown in the item display menu (and the font size if
    # needed). Items can have individual maximums through usage of the
    # <max limit: x> notetag.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    ITEM_MAX  = 999     # The default maximum number of items held each.
    ITEM_FONT = 16      # Font size used to display item quantity.
    SHOP_FONT = 16      # Font size used for shop item costs.
    ITEM_PREFIX = "×%s" # Prefix used for item quantity in item lists.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Parameter Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Adjust the limits for each of the various stats (for MaxHP, MaxMP, ATK,
    # DEF, MAT, and more). Adjust them as you see fit.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    LEVEL_MAX = 99      # Sets max level to x for those with 99 level limit.
    MAXHP_MAX = 9999999 # Sets MaxHP to something higher than 9999.
    MAXMP_MAX = 9999999 # Sets MaxMP to something higher than 9999.
    PARAM_MAX = 99999   # Sets stat max for something higher than 999.
    EQUIP_FONT = 16     # Changes the default equip window font size.
    
  end # LIMIT
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module ACTOR
    
    MAX_LEVEL = /<(?:MAX_LEVEL|max level):[ ](\d+)>/i
    INI_LEVEL = /<(?:INITIAL_LEVEL|initial level):[ ](\d+)>/i
    
  end # ACTOR
  module CLASS
    
    LEARN_AT_LV = /<(?:LEARN_AT_LEVEL|learn at level):[ ](\d+)>/i
    
  end # CLASS
  module BASEITEM
    
    PRICE     = /<(?:GOLD|price|COST):[ ](\d+)>/i
    MAX_LIMIT = /<(?:MAX_LIMIT|max limit):[ ](\d+)>/i
    STAT_SET  = /<(.*):[ ]*([\+\-]\d+)>/i
    
  end # BASEITEM
  module ENEMY
    
    STAT_SET  = /<(.*):[ ]*(\d+)>/i
    
  end # ENEMY
  end # REGEXP
end # YEA

#==============================================================================
# ■ Icon
#==============================================================================

module Icon
  
  #--------------------------------------------------------------------------
  # self.gold
  #--------------------------------------------------------------------------
  def self.gold; return YEA::LIMIT::GOLD_ICON; end
    
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
  class <<self; alias load_database_al load_database; end
  def self.load_database
    load_database_al
    load_notetags_al
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_al
  #--------------------------------------------------------------------------
  def self.load_notetags_al
    groups = [$data_actors, $data_items, $data_weapons, $data_armors,
      $data_enemies, $data_classes]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_al
      end
    end
  end
  
end # DataManager

#==============================================================================
# ■ RPG::Actor
#==============================================================================

class RPG::Actor < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_al
  #--------------------------------------------------------------------------
  def load_notetags_al
    @max_level = YEA::LIMIT::LEVEL_MAX if @max_level == 99
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::ACTOR::MAX_LEVEL
        @max_level = [[$1.to_i, 1].max, YEA::LIMIT::LEVEL_MAX].min
        @ini_level = [@ini_level, @max_level].min
      when YEA::REGEXP::ACTOR::INI_LEVEL
        @ini_level = [[$1.to_i, 1].max, @max_level].min
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::Actor

#==============================================================================
# ■ RPG::Class
#==============================================================================

class RPG::Class < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # new method: above_lv99_params
  #--------------------------------------------------------------------------
  def above_lv99_params(param_id, level)
    return @params[param_id, level] if level <= 99
    n = @params[param_id, 99]
    multiplier = [level - 99, 1].max
    change = (@params[param_id, 99] - @params[param_id, 98]) + 1
    n += change * multiplier
    return n
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_al
  #--------------------------------------------------------------------------
  def load_notetags_al
    for item in @learnings; item.load_notetags_al; end
  end
  
end # RPG::Class

#==============================================================================
# ■ RPG::Class::Learning
#==============================================================================

class RPG::Class::Learning
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_al
  #--------------------------------------------------------------------------
  def load_notetags_al
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::CLASS::LEARN_AT_LV
        @level = [[$1.to_i, 1].max, YEA::LIMIT::LEVEL_MAX].min
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::Class::Learning

#==============================================================================
# ■ RPG::BaseItem
#==============================================================================

class RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :max_limit
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_al
  #--------------------------------------------------------------------------
  def load_notetags_al
    @max_limit = YEA::LIMIT::ITEM_MAX
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::BASEITEM::PRICE
        @price = [$1.to_i, YEA::LIMIT::GOLD_MAX].min
      when YEA::REGEXP::BASEITEM::MAX_LIMIT
        @max_limit = [$1.to_i, 1].max
      when YEA::REGEXP::BASEITEM::STAT_SET
        case $1.upcase
        when "HP", "MAXHP", "MHP"
          @params[0] = $2.to_i
        when "MP", "MAXMP", "MMP", "SP", "MAXSP", "MSP"
          @params[1] = $2.to_i
        when "ATK"
          @params[2] = $2.to_i
        when "DEF"
          @params[3] = $2.to_i
        when "MAT", "INT", "SPI"
          @params[4] = $2.to_i
        when "MDF", "RES"
          @params[5] = $2.to_i
        when "AGI", "SPD"
          @params[6] = $2.to_i
        when "LUK", "LUCK"
          @params[7] = $2.to_i
        end
      #---
      end
    } # self.note.split
    #---
  end
  
  #--------------------------------------------------------------------------
  # new method: max_limit
  #--------------------------------------------------------------------------
  def max_limit; return @max_limit; end
  
end # RPG::BaseItem

#==============================================================================
# ■ RPG::Enemy
#==============================================================================

class RPG::Enemy < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_al
  #--------------------------------------------------------------------------
  def load_notetags_al
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::ENEMY::STAT_SET
        case $1.upcase
        when "HP", "MAXHP", "MHP"
          @params[0] = $2.to_i
        when "MP", "MAXMP", "MMP", "SP", "MAXSP", "MSP"
          @params[1] = $2.to_i
        when "ATK"
          @params[2] = $2.to_i
        when "DEF"
          @params[3] = $2.to_i
        when "MAT", "INT", "SPI"
          @params[4] = $2.to_i
        when "MDF", "RES"
          @params[5] = $2.to_i
        when "AGI", "SPD"
          @params[6] = $2.to_i
        when "LUK", "LUCK"
          @params[7] = $2.to_i
        when "EXP", "XP"
          @exp = $2.to_i
        when "GOLD", "GP"
          @gold = $2.to_i
        end
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::Enemy

#==============================================================================
# ■ Game_BattlerBase
#==============================================================================

class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # overwrite method: param_max
  #--------------------------------------------------------------------------
  def param_max(param_id)
    return YEA::LIMIT::MAXHP_MAX if param_id == 0
    return YEA::LIMIT::MAXMP_MAX if param_id == 1
    return YEA::LIMIT::PARAM_MAX
  end
  
end # Game_BattlerBase

#==============================================================================
# ■ Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  
  #--------------------------------------------------------------------------
  # overwrite method: param_max
  #--------------------------------------------------------------------------
  def param_max(param_id)
    return super
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: param_base
  #--------------------------------------------------------------------------
  def param_base(param_id)
    return self.class.params[param_id, @level] if @level <= 99
    return self.class.above_lv99_params(param_id, @level)
  end
  
  #--------------------------------------------------------------------------
  # new method: check_levels
  #--------------------------------------------------------------------------
  def check_levels
    last_level = @level
    @level = [[@level, max_level].min, 1].max
    return if @level == last_level
    change_exp(exp_for_level(@level), false)
  end
  
end # Game_Actor

#==============================================================================
# ■ Game_Party
#==============================================================================

class Game_Party < Game_Unit
  
  #--------------------------------------------------------------------------
  # overwrite method: max_gold
  #--------------------------------------------------------------------------
  def max_gold; return YEA::LIMIT::GOLD_MAX; end
  
  #--------------------------------------------------------------------------
  # overwrite method: max_item_number
  #--------------------------------------------------------------------------
  def max_item_number(item); return item.max_limit; end
  
end # Game_Party

#==============================================================================
# ■ Game_Interpreter
#==============================================================================

class Game_Interpreter
  
  #--------------------------------------------------------------------------
  # new method: gain_gold
  #--------------------------------------------------------------------------
  def gain_gold(value); $game_party.gain_gold(value); end
  
  #--------------------------------------------------------------------------
  # new method: lose_gold
  #--------------------------------------------------------------------------
  def lose_gold(value); $game_party.lose_gold(value); end
  
  #--------------------------------------------------------------------------
  # new method: gain_item
  #--------------------------------------------------------------------------
  def gain_item(id, amount)
    return if $data_items[id].nil?
    $game_party.gain_item($data_items[id], amount)
  end
  
  #--------------------------------------------------------------------------
  # new method: lose_item
  #--------------------------------------------------------------------------
  def lose_item(id, amount)
    return if $data_items[id].nil?
    $game_party.lose_item($data_items[id], amount)
  end
  
  #--------------------------------------------------------------------------
  # new method: gain_weapon
  #--------------------------------------------------------------------------
  def gain_weapon(id, amount)
    return if $data_weapons[id].nil?
    $game_party.gain_item($data_weapons[id], amount)
  end
  
  #--------------------------------------------------------------------------
  # new method: lose_weapon
  #--------------------------------------------------------------------------
  def lose_weapon(id, amount)
    return if $data_weapons[id].nil?
    $game_party.lose_item($data_weapons[id], amount)
  end
  
  #--------------------------------------------------------------------------
  # new method: gain_armour
  #--------------------------------------------------------------------------
  def gain_armour(id, amount)
    return if $data_armors[id].nil?
    $game_party.gain_item($data_armors[id], amount)
  end
  
  #--------------------------------------------------------------------------
  # new method: lose_armour
  #--------------------------------------------------------------------------
  def lose_armour(id, amount)
    return if $data_armors[id].nil?
    $game_party.lose_item($data_armors[id], amount)
  end
  
  #--------------------------------------------------------------------------
  # new method: gain_armor
  #--------------------------------------------------------------------------
  def gain_armor(id, amount)
    return if $data_armors[id].nil?
    $game_party.gain_item($data_armors[id], amount)
  end
  
  #--------------------------------------------------------------------------
  # new method: lose_armor
  #--------------------------------------------------------------------------
  def lose_armor(id, amount)
    return if $data_armors[id].nil?
    $game_party.lose_item($data_armors[id], amount)
  end
  
end # Game_Interpreter

#==============================================================================
# ■ Window_Base
#==============================================================================

class Window_Base < Window
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_actor_level
  #--------------------------------------------------------------------------
  def draw_actor_level(actor, dx, dy)
    dw = text_size(Vocab::level_a + YEA::LIMIT::LEVEL_MAX.to_s).width
    change_color(system_color)
    draw_text(dx, dy, dw, line_height, Vocab::level_a)
    change_color(normal_color)
    cx = text_size(Vocab::level_a).width
    draw_text(dx + cx, dy, dw, line_height, actor.level.group, 2)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_actor_param
  #--------------------------------------------------------------------------
  def draw_actor_param(actor, dx, dy, param_id)
    change_color(system_color)
    draw_text(dx, dy, 120, line_height, Vocab::param(param_id))
    change_color(normal_color)
    draw_text(dx, dy, 156, line_height, actor.param(param_id).group, 2)
  end
  
  #--------------------------------------------------------------------------
  # draw_currency_value
  #--------------------------------------------------------------------------
  def draw_currency_value(value, unit, dx, dy, dw)
    contents.font.size = YEA::LIMIT::GOLD_FONT
    cx = gold_icon?(unit) ? 24 : text_size(unit).width
    change_color(normal_color)
    text = value.group
    text = YEA::LIMIT::TOO_MUCH_GOLD if contents.text_size(text).width > dw-cx
    draw_text(dx, dy, dw - cx - 2, line_height, text, 2)
    change_color(system_color)
    draw_icon(Icon.gold, dx+dw-24, dy) if gold_icon?(unit)
    draw_text(dx, dy, dw, line_height, unit, 2) unless gold_icon?(unit)
    reset_font_settings
  end
  
  #--------------------------------------------------------------------------
  # new method: gold_icon?
  #--------------------------------------------------------------------------
  def gold_icon?(unit)
    return false if unit != Vocab.currency_unit
    return YEA::LIMIT::GOLD_ICON > 0
  end
  
end # Window_Base

#==============================================================================
# ■ Window_ItemList
#==============================================================================

class Window_ItemList < Window_Selectable
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_item_number
  #--------------------------------------------------------------------------
  def draw_item_number(rect, item)
    contents.font.size = YEA::LIMIT::ITEM_FONT
    quantity = $game_party.item_number(item).group
    text = sprintf(YEA::LIMIT::ITEM_PREFIX, quantity)
    draw_text(rect, text, 2)
    reset_font_settings
  end
  
end # Window_ItemList

#==============================================================================
# ■ Window_EquipStatus
#==============================================================================

class Window_EquipStatus < Window_Base
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_item
  #--------------------------------------------------------------------------
  def draw_item(dx, dy, param_id)
    draw_param_name(dx + 4, dy, param_id)
    draw_current_param(dx + 64, dy, param_id) if @actor
    draw_right_arrow(dx + 110, dy)
    draw_new_param(dx + 132, dy, param_id) if @temp_actor
    reset_font_settings
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_param_name
  #--------------------------------------------------------------------------
  def draw_param_name(dx, dy, param_id)
    contents.font.size = YEA::LIMIT::EQUIP_FONT
    change_color(system_color)
    draw_text(dx, dy, contents.width, line_height, Vocab::param(param_id))
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_current_param
  #--------------------------------------------------------------------------
  def draw_current_param(dx, dy, param_id)
    change_color(normal_color)
    draw_text(0, dy, dx+48, line_height, @actor.param(param_id).group, 2)
    reset_font_settings
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_new_param
  #--------------------------------------------------------------------------
  def draw_new_param(dx, dy, param_id)
    contents.font.size = YEA::LIMIT::EQUIP_FONT
    new_value = @temp_actor.param(param_id)
    change_color(param_change_color(new_value - @actor.param(param_id)))
    draw_text(0, dy, contents.width-4, line_height, new_value.group, 2)
    reset_font_settings
  end
  
end # Window_EquipStatus

#==============================================================================
# ■ Window_ShopBuy
#==============================================================================

class Window_ShopBuy < Window_Selectable
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    rect = item_rect(index)
    draw_item_name(item, rect.x, rect.y, enable?(item))
    rect.width -= 4
    contents.font.size = YEA::LIMIT::SHOP_FONT
    draw_text(rect, price(item).group, 2)
    reset_font_settings
  end
  
end # Window_ShopBuy

#==============================================================================
# ■ Scene_Load
#==============================================================================

class Scene_Load < Scene_File
  
  #--------------------------------------------------------------------------
  # alias method: on_load_success
  #--------------------------------------------------------------------------
  alias on_load_success_al on_load_success
  def on_load_success
    on_load_success_al
    perform_level_check
  end
  
  #--------------------------------------------------------------------------
  # new method: perform_level_check
  #--------------------------------------------------------------------------
  def perform_level_check
    for i in 1..$data_actors.size
      next if $game_actors[i].nil?
      $game_actors[i].check_levels
    end
  end
  
end # Scene_Load

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================