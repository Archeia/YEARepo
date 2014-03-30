#==============================================================================
# 
# ▼ Yanfly Engine Ace - Ace Item Menu v1.02
# -- Last Updated: 2012.01.05
# -- Level: Normal, Hard
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-ItemMenu"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.05 - Compatibility Update with Equip Dynamic Stats.
# 2012.01.03 - Started Script and Finished.
#            - Compatibility Update with Ace Menu Engine.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# The Ace Item Menu offers more item categorization control and a better layout
# that simulatenously provides information regarding the items to the player,
# while keeping a good amount of the item list visible on screen at once. The
# script can also be customized to rearrange commands and categories.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Item Notetags - These notetags go in the item notebox in the database.
# -----------------------------------------------------------------------------
# <category: string>
# Places this object into the item category for "string". Whenever the selected
# category is highlighted in the Ace Item Menu command window, this object will
# be included and shown in the item window.
# 
# <image: string>
# Uses a picture from Graphics\Pictures\ of your RPG Maker VX Ace Project's
# directory with the filename of "string" (without the extension) as the image
# picture shown in the Ace Item Menu.
# 
# -----------------------------------------------------------------------------
# Weapon Notetags - These notetags go in the weapon notebox in the database.
# -----------------------------------------------------------------------------
# <category: string>
# Places this object into the item category for "string". Whenever the selected
# category is highlighted in the Ace Item Menu command window, this object will
# be included and shown in the item window.
# 
# <image: string>
# Uses a picture from Graphics\Pictures\ of your RPG Maker VX Ace Project's
# directory with the filename of "string" (without the extension) as the image
# picture shown in the Ace Item Menu.
# 
# -----------------------------------------------------------------------------
# Armour Notetags - These notetags go in the armour notebox in the database.
# -----------------------------------------------------------------------------
# <category: string>
# Places this object into the item category for "string". Whenever the selected
# category is highlighted in the Ace Item Menu command window, this object will
# be included and shown in the item window.
# 
# <image: string>
# Uses a picture from Graphics\Pictures\ of your RPG Maker VX Ace Project's
# directory with the filename of "string" (without the extension) as the image
# picture shown in the Ace Item Menu.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module ITEM
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Item Command Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This array adjusts what options appear in the initial item command window
    # before the items are split into separate categories. Add commands, remove
    # commands, or rearrange them. Here's a list of which does what:
    # 
    # -------------------------------------------------------------------------
    # :command         Description
    # -------------------------------------------------------------------------
    # :item            Opens up the various item categories. Default.
    # :weapon          Opens up the various weapon categories. Default.
    # :armor           Opens up the various armour categories. Default.
    # :key_item        Shows a list of the various key items. Default.
    # 
    # :gogototori      Requires Kread-EX's Go Go Totori Synthesis.
    # 
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    COMMANDS =[
      :item,         # Opens up the various item categories. Default.
      :weapon,       # Opens up the various weapon categories. Default.
      :armor,        # Opens up the various armour categories. Default.
      :key_item,     # Shows a list of the various key items. Default.
      :gogototori,   # Requires Kread-EX's Go Go Totori Synthesis.
    # :custom1,      # Custom command 1.
    # :custom2,      # Custom command 2.
    ] # Do not remove this.
    
    #--------------------------------------------------------------------------
    # - Item Custom Commands -
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # For those who use scripts to that may produce unique effects for the item
    # scene, use this hash to manage the custom commands for the Item Command
    # Window. You can disable certain commands or prevent them from appearing
    # by using switches. If you don't wish to bind them to a switch, set the
    # proper switch to 0 for it to have no impact.
    #--------------------------------------------------------------------------
    CUSTOM_ITEM_COMMANDS ={
    # :command => ["Display Name", EnableSwitch, ShowSwitch, Handler Method],
      :gogototori => ["Synthesis",            0,         0, :command_totori],
      :custom1 => [ "Custom Name",            0,          0, :command_name1],
      :custom2 => [ "Custom Text",           13,          0, :command_name2],
    } # Do not remove this.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Item Type Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These arrays adjusts and shows the various item types shown for Items,
    # Weapons, and Armours. Note that when using :category symbols, the
    # specific category shown will be equal to the text used for the Display
    # and the included item must contain a category equal to the Display name.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This array contains the order for the Item categories.
    ITEM_TYPES =[
    # [  :symbol,   "Display"],
      [   :field,     "Field"], # Shows Menu-usable items.
      [  :battle,    "Battle"], # Shows Battle-usable items.
      [:category,   "Special"], # Categorized by <category: string>
      [:category,"Ingredient"], # Categorized by <category: string>
      [:key_item,  "Key Item"], # Shows all key items.
      [     :all,       "All"], # Shows all usable items.
    ] # Do not remove this.
    
    # This array contains the order for the Weapon categories.
    WEAPON_TYPES =[
    # [  :symbol,   "Display"],
      [   :types,  "WPNTYPES"], # Lists all of the individual weapon types.
      [:category,  "Training"], # Categorized by <category: string>
      [:category, "Legendary"], # Categorized by <category: string>
      [     :all,       "All"], # Shows all weapons.
    ] # Do not remove this.
    
    # This array contains the order for the Armour categories.
    ARMOUR_TYPES =[
    # [  :symbol,   "Display"],
      [   :slots,  "ARMSLOTS"], # Lists all of the individual armour slots.
      [   :types,  "ARMTYPES"], # Lists all of the individual armours types.
      [:category,  "Training"], # Categorized by <category: string>
      [:category, "Legendary"], # Categorized by <category: string>
      [     :all,       "All"], # Shows all armours.
    ] # Do not remove this.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Item Status Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # The item status window displays information about the item in detail.
    # Adjust the settings below to change the way the status window appears.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    STATUS_FONT_SIZE = 20       # Font size used for status window.
    MAX_ICONS_DRAWN  = 10       # Maximum number of icons drawn for states.
    
    # The following adjusts the vocabulary used for the status window. Each
    # of the vocabulary settings are self explanatory.
    VOCAB_STATUS ={
      :empty      => "---",          # Text used when nothing is shown.
      :hp_recover => "HP Heal",      # Text used for HP Recovery.
      :mp_recover => "MP Heal",      # Text used for MP Recovery.
      :tp_recover => "TP Heal",      # Text used for TP Recovery.
      :tp_gain    => "TP Gain",      # Text used for TP Gain.
      :applies    => "Applies",      # Text used for applied states and buffs.
      :removes    => "Removes",      # Text used for removed states and buffs.
    } # Do not remove this.
    
  end # ITEM
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module BASEITEM
    
    CATEGORY = /<(?:CATEGORIES|category):[ ](.*)>/i
    IMAGE    = /<(?:IMAGE|image):[ ](.*)>/i
    
  end # BASEITEM
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
# ■ Vocab
#==============================================================================

module Vocab
  
  #--------------------------------------------------------------------------
  # new method: self.item_status
  #--------------------------------------------------------------------------
  def self.item_status(type)
    return YEA::ITEM::VOCAB_STATUS[type]
  end
  
end # Vocab

#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_aim load_database; end
  def self.load_database
    load_database_aim
    load_notetags_aim
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_aim
  #--------------------------------------------------------------------------
  def self.load_notetags_aim
    groups = [$data_items, $data_weapons, $data_armors]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_aim
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
  attr_accessor :category
  attr_accessor :image
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_aim
  #--------------------------------------------------------------------------
  def load_notetags_aim
    @category = []
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::BASEITEM::CATEGORY
        @category.push($1.upcase.to_s)
      when YEA::REGEXP::BASEITEM::IMAGE
        @image = $1.to_s
      end
    } # self.note.split
    #---
  end
  
end # RPG::BaseItem

#==============================================================================
# ■ Game_Temp
#==============================================================================

class Game_Temp
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :scene_item_index
  attr_accessor :scene_item_oy
  
end # Game_Temp

#==============================================================================
# ■ Window_ItemList
#==============================================================================

class Window_ItemList < Window_Selectable
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    return if item.nil?
    rect = item_rect(index)
    rect.width -= 4
    draw_item_name(item, rect.x, rect.y, enable?(item), rect.width - 24)
    draw_item_number(rect, item)
  end
  
end # Window_ItemList

#==============================================================================
# ■ Window_ItemCommand
#==============================================================================

class Window_ItemCommand < Window_Command
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_reader   :item_window
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y)
  end
  
  #--------------------------------------------------------------------------
  # window_width
  #--------------------------------------------------------------------------
  def window_width; return 160; end
  
  #--------------------------------------------------------------------------
  # visible_line_number
  #--------------------------------------------------------------------------
  def visible_line_number; return 4; end
  
  #--------------------------------------------------------------------------
  # process_ok
  #--------------------------------------------------------------------------
  def process_ok
    $game_temp.scene_item_index = index
    $game_temp.scene_item_oy = self.oy
    super
  end
  
  #--------------------------------------------------------------------------
  # make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    for command in YEA::ITEM::COMMANDS
      case command
      #--- Default Commands ---
      when :item
        add_command(Vocab::item, :item)
      when :weapon
        add_command(Vocab::weapon, :weapon)
      when :armor
        add_command(Vocab::armor, :armor)
      when :key_item
        add_command(Vocab::key_item, :key_item)
      #--- Imported ---
      when :gogototori
        next unless $imported["KRX-AlchemicSynthesis"]
        process_custom_command(command)
      #--- Custom Commands ---
      else
        process_custom_command(command)
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # process_custom_command
  #--------------------------------------------------------------------------
  def process_custom_command(command)
    return unless YEA::ITEM::CUSTOM_ITEM_COMMANDS.include?(command)
    show = YEA::ITEM::CUSTOM_ITEM_COMMANDS[command][2]
    continue = show <= 0 ? true : $game_switches[show]
    return unless continue
    text = YEA::ITEM::CUSTOM_ITEM_COMMANDS[command][0]
    switch = YEA::ITEM::CUSTOM_ITEM_COMMANDS[command][1]
    enabled = switch <= 0 ? true : $game_switches[switch]
    add_command(text, command, enabled)
  end
  
  #--------------------------------------------------------------------------
  # update
  #--------------------------------------------------------------------------
  def update
    super
    return unless self.active
    @item_window.category = current_symbol if @item_window
  end
  
  #--------------------------------------------------------------------------
  # item_window=
  #--------------------------------------------------------------------------
  def item_window=(item_window)
    @item_window = item_window
    update
  end
  
end # Window_ItemCommand

#==============================================================================
# ■ Window_ItemType
#==============================================================================

class Window_ItemType < Window_Command
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_reader   :item_window
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y)
    deactivate
    @type = nil
  end
  
  #--------------------------------------------------------------------------
  # window_width
  #--------------------------------------------------------------------------
  def window_width; return 160; end
  
  #--------------------------------------------------------------------------
  # visible_line_number
  #--------------------------------------------------------------------------
  def visible_line_number; return 4; end
  
  #--------------------------------------------------------------------------
  # reveal
  #--------------------------------------------------------------------------
  def reveal(type)
    @type = type
    refresh
    activate
    select(0)
  end
  
  #--------------------------------------------------------------------------
  # make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    return if @type.nil?
    #---
    case @type
    when :item
      commands = YEA::ITEM::ITEM_TYPES
    when :weapon
      commands = YEA::ITEM::WEAPON_TYPES
    else
      commands = YEA::ITEM::ARMOUR_TYPES
    end
    #---
    for command in commands
      case command[0]
      #---
      when :types
        case @type
        when :weapon
          for i in 1...$data_system.weapon_types.size
            name = $data_system.weapon_types[i]
            add_command(name, :w_type, true, i)
          end
        else
          for i in 1...$data_system.armor_types.size
            name = $data_system.armor_types[i]
            add_command(name, :a_type, true, i)
          end
        end
      #---
      when :slots
        if $imported["YEA-AceEquipEngine"]
          maximum = 1
          for key in YEA::EQUIP::TYPES
            maximum = [maximum, key[0]].max
          end
        else
          maximum = 4
        end
        for i in 1..maximum
          name = Vocab::etype(i)
          add_command(name, :e_type, true, i) if name != ""
        end
      #---
      else
        add_command(command[1], command[0], true, @type)
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # update
  #--------------------------------------------------------------------------
  def update
    super
    return unless self.active
    @item_window.category = current_symbol if @item_window
  end
  
  #--------------------------------------------------------------------------
  # item_window=
  #--------------------------------------------------------------------------
  def item_window=(item_window)
    @item_window = item_window
    update
  end
  
end # Window_ItemType

#==============================================================================
# ■ Window_ItemList
#==============================================================================

class Window_ItemList < Window_Selectable
  
  #--------------------------------------------------------------------------
  # alias method: initialize
  #--------------------------------------------------------------------------
  alias window_itemlist_initialize_aim initialize
  def initialize(dx, dy, dw, dh)
    window_itemlist_initialize_aim(dx, dy, dw, dh)
    @ext = :none
    @name = ""
  end
  
  #--------------------------------------------------------------------------
  # alias method: category=
  #--------------------------------------------------------------------------
  alias window_itemlist_category_aim category=
  def category=(category)
    if @types_window.nil?
      window_itemlist_category_aim(category)
    else
      return unless update_types?(category)
      @category = category
      if @types_window.active
        @name = @types_window.current_data[:name]
        @ext = @types_window.current_ext
      end
      refresh
      self.oy = 0
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: update_types?
  #--------------------------------------------------------------------------
  def update_types?(category)
    return true if @category != category
    return false unless @types_window.active
    if category == :category
      return @name != @types_window.current_data[:name]
    end
    return @ext != @types_window.current_ext
  end
  
  #--------------------------------------------------------------------------
  # new method: types_window=
  #--------------------------------------------------------------------------
  def types_window=(window)
    @types_window = window
  end
  
  #--------------------------------------------------------------------------
  # alias method: include?
  #--------------------------------------------------------------------------
  alias window_itemlist_include_aim include?
  def include?(item)
    if @types_window.nil?
      return window_itemlist_include_aim(item)
    else
      return ace_item_menu_include?(item)
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: ace_item_menu_include?
  #--------------------------------------------------------------------------
  def ace_item_menu_include?(item)
    case @category
    #---
    when :field
      return false unless item.is_a?(RPG::Item)
      return item.menu_ok?
    when :battle
      return false unless item.is_a?(RPG::Item)
      return item.battle_ok?
    #---
    when :w_type
      return false unless item.is_a?(RPG::Weapon)
      return item.wtype_id == @types_window.current_ext
    when :a_type
      return false unless item.is_a?(RPG::Armor)
      return item.atype_id == @types_window.current_ext
    when :e_type
      return false unless item.is_a?(RPG::Armor)
      return item.etype_id == @types_window.current_ext
    #---
    when :all
      case @types_window.current_ext
      when :item
        return item.is_a?(RPG::Item)
      when :weapon
        return item.is_a?(RPG::Weapon)
      else
        return item.is_a?(RPG::Armor)
      end
    #---
    when :category
      case @types_window.current_ext
      when :item
        return false unless item.is_a?(RPG::Item)
      when :weapon
        return false unless item.is_a?(RPG::Weapon)
      else
        return false unless item.is_a?(RPG::Armor)
      end
      return item.category.include?(@types_window.current_data[:name].upcase)
    #---
    else
      return window_itemlist_include_aim(item)
    end
  end
  
end # Window_ItemList

#==============================================================================
# ■ Window_ItemStatus
#==============================================================================

class Window_ItemStatus < Window_Base
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(dx, dy, item_window)
    super(dx, dy, Graphics.width - dx, fitting_height(4))
    @item_window = item_window
    @item = nil
    refresh
  end
  
  #--------------------------------------------------------------------------
  # update
  #--------------------------------------------------------------------------
  def update
    super
    update_item(@item_window.item)
  end
  
  #--------------------------------------------------------------------------
  # update_item
  #--------------------------------------------------------------------------
  def update_item(item)
    return if @item == item
    @item = item
    refresh
  end
  
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    reset_font_settings
    return draw_empty if @item.nil?
    contents.font.size = YEA::ITEM::STATUS_FONT_SIZE
    draw_item_image
    draw_item_stats
    draw_item_effects
  end
  
  #--------------------------------------------------------------------------
  # draw_empty
  #--------------------------------------------------------------------------
  def draw_empty
    colour = Color.new(0, 0, 0, translucent_alpha/2)
    rect = Rect.new(1, 1, 94, 94)
    contents.fill_rect(rect, colour)
    dx = 96; dy = 0
    dw = (contents.width - 96) / 2
    for i in 0...8
      draw_background_box(dx, dy, dw)
      dx = dx >= 96 + dw ? 96 : 96 + dw
      dy += line_height if dx == 96
    end
  end
  
  #--------------------------------------------------------------------------
  # draw_background_box
  #--------------------------------------------------------------------------
  def draw_background_box(dx, dy, dw)
    colour = Color.new(0, 0, 0, translucent_alpha/2)
    rect = Rect.new(dx+1, dy+1, dw-2, line_height-2)
    contents.fill_rect(rect, colour)
  end
  
  #--------------------------------------------------------------------------
  # draw_item_image
  #--------------------------------------------------------------------------
  def draw_item_image
    colour = Color.new(0, 0, 0, translucent_alpha/2)
    rect = Rect.new(1, 1, 94, 94)
    contents.fill_rect(rect, colour)
    if @item.image.nil?
      icon_index = @item.icon_index
      bitmap = Cache.system("Iconset")
      rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
      target = Rect.new(0, 0, 96, 96)
      contents.stretch_blt(target, bitmap, rect)
    else
      bitmap = Cache.picture(@item.image)
      contents.blt(0, 0, bitmap, bitmap.rect, 255)
    end
  end
  
  #--------------------------------------------------------------------------
  # draw_item_stats
  #--------------------------------------------------------------------------
  def draw_item_stats
    return unless @item.is_a?(RPG::Weapon) || @item.is_a?(RPG::Armor)
    dx = 96; dy = 0
    dw = (contents.width - 96) / 2
    for i in 0...8
      draw_equip_param(i, dx, dy, dw)
      dx = dx >= 96 + dw ? 96 : 96 + dw
      dy += line_height if dx == 96
    end
  end
  
  #--------------------------------------------------------------------------
  # draw_equip_param
  #--------------------------------------------------------------------------
  def draw_equip_param(param_id, dx, dy, dw)
    draw_background_box(dx, dy, dw)
    change_color(system_color)
    draw_text(dx+4, dy, dw-8, line_height, Vocab::param(param_id))
    if $imported["YEA-EquipDynamicStats"]
      draw_percentage_param(param_id, dx, dy, dw)
    else
      draw_set_param(param_id, dx, dy, dw)
    end
  end
  
  #--------------------------------------------------------------------------
  # draw_percentage_param
  #--------------------------------------------------------------------------
  def draw_percentage_param(param_id, dx, dy, dw)
    if @item.per_params[param_id] != 0 && @item.params[param_id] != 0
      text = draw_set_param(param_id, dx, dy, dw)
      dw -= text_size(text).width
      draw_percent_param(param_id, dx, dy, dw)
    elsif @item.per_params[param_id] != 0 && @item.params[param_id] == 0
      draw_percent_param(param_id, dx, dy, dw)
    else
      draw_set_param(param_id, dx, dy, dw)
    end
  end
  
  #--------------------------------------------------------------------------
  # draw_set_param
  #--------------------------------------------------------------------------
  def draw_set_param(param_id, dx, dy, dw)
    value = @item.params[param_id]
    if $imported["YEA-EquipDynamicStats"] && @item.var_params[param_id] > 0
      value += $game_variables[@item.var_params[param_id]] rescue 0
    end
    change_color(param_change_color(value), value != 0)
    text = value.group
    text = "+" + text if value > 0
    draw_text(dx+4, dy, dw-8, line_height, text, 2)
    return text
  end
  
  #--------------------------------------------------------------------------
  # draw_percent_param
  #--------------------------------------------------------------------------
  def draw_percent_param(param_id, dx, dy, dw)
    value = @item.per_params[param_id]
    change_color(param_change_color(value))
    text = (@item.per_params[param_id] * 100).to_i.group + "%"
    text = "+" + text if @item.per_params[param_id] > 0
    draw_text(dx+4, dy, dw-8, line_height, text, 2)
    return text
  end
  
  #--------------------------------------------------------------------------
  # draw_item_effects
  #--------------------------------------------------------------------------
  def draw_item_effects
    return unless @item.is_a?(RPG::Item)
    dx = 96; dy = 0
    dw = (contents.width - 96) / 2
    draw_hp_recover(dx, dy + line_height * 0, dw)
    draw_mp_recover(dx, dy + line_height * 1, dw)
    draw_tp_recover(dx + dw, dy + line_height * 0, dw)
    draw_tp_gain(dx + dw, dy + line_height * 1, dw)
    dw = contents.width - 96
    draw_applies(dx, dy + line_height * 2, dw)
    draw_removes(dx, dy + line_height * 3, dw)
  end
  
  #--------------------------------------------------------------------------
  # draw_hp_recover
  #--------------------------------------------------------------------------
  def draw_hp_recover(dx, dy, dw)
    draw_background_box(dx, dy, dw)
    change_color(system_color)
    draw_text(dx+4, dy, dw-8, line_height, Vocab::item_status(:hp_recover))
    per = 0
    set = 0
    for effect in @item.effects
      next unless effect.code == 11
      per += (effect.value1 * 100).to_i
      set += effect.value2.to_i
    end
    if per != 0 && set != 0
      change_color(param_change_color(set))
      text = set > 0 ? sprintf("+%s", set.group) : set.group
      draw_text(dx+4, dy, dw-8, line_height, text, 2)
      dw -= text_size(text).width
      change_color(param_change_color(per))
      text = per > 0 ? sprintf("+%s%%", per.group) : sprintf("%s%%", per.group)
      draw_text(dx+4, dy, dw-8, line_height, text, 2)
      return
    elsif per != 0
      change_color(param_change_color(per))
      text = per > 0 ? sprintf("+%s%%", per.group) : sprintf("%s%%", per.group)
    elsif set != 0
      change_color(param_change_color(set))
      text = set > 0 ? sprintf("+%s", set.group) : set.group
    else
      change_color(normal_color, false)
      text = Vocab::item_status(:empty)
    end
    draw_text(dx+4, dy, dw-8, line_height, text, 2)
  end
  
  #--------------------------------------------------------------------------
  # draw_mp_recover
  #--------------------------------------------------------------------------
  def draw_mp_recover(dx, dy, dw)
    draw_background_box(dx, dy, dw)
    change_color(system_color)
    draw_text(dx+4, dy, dw-8, line_height, Vocab::item_status(:mp_recover))
    per = 0
    set = 0
    for effect in @item.effects
      next unless effect.code == 12
      per += (effect.value1 * 100).to_i
      set += effect.value2.to_i
    end
    if per != 0 && set != 0
      change_color(param_change_color(set))
      text = set > 0 ? sprintf("+%s", set.group) : set.group
      draw_text(dx+4, dy, dw-8, line_height, text, 2)
      dw -= text_size(text).width
      change_color(param_change_color(per))
      text = per > 0 ? sprintf("+%s%%", per.group) : sprintf("%s%%", per.group)
      draw_text(dx+4, dy, dw-8, line_height, text, 2)
      return
    elsif per != 0
      change_color(param_change_color(per))
      text = per > 0 ? sprintf("+%s%%", per.group) : sprintf("%s%%", per.group)
    elsif set != 0
      change_color(param_change_color(set))
      text = set > 0 ? sprintf("+%s", set.group) : set.group
    else
      change_color(normal_color, false)
      text = Vocab::item_status(:empty)
    end
    draw_text(dx+4, dy, dw-8, line_height, text, 2)
  end
  
  #--------------------------------------------------------------------------
  # draw_tp_recover
  #--------------------------------------------------------------------------
  def draw_tp_recover(dx, dy, dw)
    draw_background_box(dx, dy, dw)
    change_color(system_color)
    draw_text(dx+4, dy, dw-8, line_height, Vocab::item_status(:tp_recover))
    set = 0
    for effect in @item.effects
      next unless effect.code == 13
      set += effect.value1.to_i
    end
    if set != 0
      change_color(param_change_color(set))
      text = set > 0 ? sprintf("+%s", set.group) : set.group
    else
      change_color(normal_color, false)
      text = Vocab::item_status(:empty)
    end
    draw_text(dx+4, dy, dw-8, line_height, text, 2)
  end
  
  #--------------------------------------------------------------------------
  # draw_tp_gain
  #--------------------------------------------------------------------------
  def draw_tp_gain(dx, dy, dw)
    draw_background_box(dx, dy, dw)
    change_color(system_color)
    draw_text(dx+4, dy, dw-8, line_height, Vocab::item_status(:tp_gain))
    set = @item.tp_gain
    if set != 0
      change_color(param_change_color(set))
      text = set > 0 ? sprintf("+%s", set.group) : set.group
    else
      change_color(normal_color, false)
      text = Vocab::item_status(:empty)
    end
    draw_text(dx+4, dy, dw-8, line_height, text, 2)
  end
  
  #--------------------------------------------------------------------------
  # draw_applies
  #--------------------------------------------------------------------------
  def draw_applies(dx, dy, dw)
    draw_background_box(dx, dy, dw)
    change_color(system_color)
    draw_text(dx+4, dy, dw-8, line_height, Vocab::item_status(:applies))
    icons = []
    for effect in @item.effects
      case effect.code
      when 21
        next unless effect.value1 > 0
        next if $data_states[effect.value1].nil?
        icons.push($data_states[effect.data_id].icon_index)
      when 31
        icons.push($game_actors[1].buff_icon_index(1, effect.data_id))
      when 32
        icons.push($game_actors[1].buff_icon_index(-1, effect.data_id))
      end
      icons.delete(0)
      break if icons.size >= YEA::ITEM::MAX_ICONS_DRAWN
    end
    draw_icons(dx, dy, dw, icons)
  end
  
  #--------------------------------------------------------------------------
  # draw_removes
  #--------------------------------------------------------------------------
  def draw_removes(dx, dy, dw)
    draw_background_box(dx, dy, dw)
    change_color(system_color)
    draw_text(dx+4, dy, dw-8, line_height, Vocab::item_status(:removes))
    icons = []
    for effect in @item.effects
      case effect.code
      when 22
        next unless effect.value1 > 0
        next if $data_states[effect.value1].nil?
        icons.push($data_states[effect.data_id].icon_index)
      when 33
        icons.push($game_actors[1].buff_icon_index(1, effect.data_id))
      when 34
        icons.push($game_actors[1].buff_icon_index(-1, effect.data_id))
      end
      icons.delete(0)
      break if icons.size >= YEA::ITEM::MAX_ICONS_DRAWN
    end
    draw_icons(dx, dy, dw, icons)
  end
  
  #--------------------------------------------------------------------------
  # draw_icons
  #--------------------------------------------------------------------------
  def draw_icons(dx, dy, dw, icons)
    dx += dw - 4
    dx -= icons.size * 24
    for icon_id in icons
      draw_icon(icon_id, dx, dy)
      dx += 24
    end
    if icons.size == 0
      change_color(normal_color, false)
      text = Vocab::item_status(:empty)
      draw_text(4, dy, contents.width-8, line_height, text, 2)
    end
  end
  
end # Window_ItemStatus

#==============================================================================
# ■ Scene_Item
#==============================================================================

class Scene_Item < Scene_ItemBase
  
  #--------------------------------------------------------------------------
  # alias method: start
  #--------------------------------------------------------------------------
  alias scene_item_start_aim start
  def start
    scene_item_start_aim
    create_types_window
    create_status_window
    relocate_windows
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: return_scene
  #--------------------------------------------------------------------------
  def return_scene
    $game_temp.scene_item_index = nil
    $game_temp.scene_item_oy = nil
    super
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: create_category_window
  #--------------------------------------------------------------------------
  def create_category_window
    wy = @help_window.height
    @category_window = Window_ItemCommand.new(0, wy)
    @category_window.viewport = @viewport
    @category_window.help_window = @help_window
    @category_window.y = @help_window.height
    if !$game_temp.scene_item_index.nil?
      @category_window.select($game_temp.scene_item_index)
      @category_window.oy = $game_temp.scene_item_oy
    end
    $game_temp.scene_item_index = nil
    $game_temp.scene_item_oy = nil
    @category_window.set_handler(:ok, method(:on_category_ok))
    @category_window.set_handler(:cancel, method(:return_scene))
    @category_window.set_handler(:item, method(:open_types))
    @category_window.set_handler(:weapon, method(:open_types))
    @category_window.set_handler(:armor, method(:open_types))
    process_custom_item_commands
  end
  
  #--------------------------------------------------------------------------
  # new method: process_custom_item_commands
  #--------------------------------------------------------------------------
  def process_custom_item_commands
    for command in YEA::ITEM::COMMANDS
      next unless YEA::ITEM::CUSTOM_ITEM_COMMANDS.include?(command)
      called_method = YEA::ITEM::CUSTOM_ITEM_COMMANDS[command][3]
      @category_window.set_handler(command, method(called_method))
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: create_types_window
  #--------------------------------------------------------------------------
  def create_types_window
    wy = @category_window.y
    @types_window = Window_ItemType.new(Graphics.width, wy)
    @types_window.viewport = @viewport
    @types_window.help_window = @help_window
    @types_window.y = @help_window.height
    @types_window.item_window = @item_window
    @item_window.types_window = @types_window
    @types_window.set_handler(:ok, method(:on_types_ok))
    @types_window.set_handler(:cancel, method(:on_types_cancel))
  end
  
  #--------------------------------------------------------------------------
  # new method: create_status_window
  #--------------------------------------------------------------------------
  def create_status_window
    wx = @category_window.width
    wy = @category_window.y
    @status_window = Window_ItemStatus.new(wx, wy, @item_window)
    @status_window.viewport = @viewport
  end
  
  #--------------------------------------------------------------------------
  # new method: relocate_windows
  #--------------------------------------------------------------------------
  def relocate_windows
    return unless $imported["YEA-AceMenuEngine"]
    case Menu.help_window_location
    when 0 # Top
      @help_window.y = 0
      @category_window.y = @help_window.height
      @item_window.y = @category_window.y + @category_window.height
    when 1 # Middle
      @category_window.y = 0
      @help_window.y = @category_window.height
      @item_window.y = @help_window.y + @help_window.height
    else # Bottom
      @category_window.y = 0
      @item_window.y = @category_window.height
      @help_window.y = @item_window.y + @item_window.height
    end
    @types_window.y = @category_window.y
    @status_window.y = @category_window.y
  end
  
  #--------------------------------------------------------------------------
  # new method: open_categories
  #--------------------------------------------------------------------------
  def open_types
    @category_window.x = Graphics.width
    @types_window.x = 0
    @types_window.reveal(@category_window.current_symbol)
  end
  
  #--------------------------------------------------------------------------
  # new method: on_types_ok
  #--------------------------------------------------------------------------
  def on_types_ok
    @item_window.activate
    @item_window.select_last
  end
  
  #--------------------------------------------------------------------------
  # new method: on_types_cancel
  #--------------------------------------------------------------------------
  def on_types_cancel
    @category_window.x = 0
    @category_window.activate
    @types_window.unselect
    @types_window.x = Graphics.width
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_item_cancel
  #--------------------------------------------------------------------------
  alias scene_item_on_item_cancel_aim on_item_cancel
  def on_item_cancel
    if @types_window.x <= 0
      @item_window.unselect
      @types_window.activate
    else
      scene_item_on_item_cancel_aim
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: command_totori
  #--------------------------------------------------------------------------
  def command_totori
    SceneManager.call(Scene_Alchemy)
  end
  
  #--------------------------------------------------------------------------
  # new method: command_name1
  #--------------------------------------------------------------------------
  def command_name1
    # Do nothing.
  end
  
  #--------------------------------------------------------------------------
  # new method: command_name2
  #--------------------------------------------------------------------------
  def command_name2
    # Do nothing.
  end
  
end # Scene_Item

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================