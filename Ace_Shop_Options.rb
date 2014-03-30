#==============================================================================
# 
# ▼ Yanfly Engine Ace - Ace Shop Options v1.01
# -- Last Updated: 2012.01.05
# -- Level: Normal, Hard
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-ShopOptions"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.05 - Compatibility Update: Equip Dynamic Stats
# 2012.01.03 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# The RPG Maker VX Ace shop scene is relatively basic. It provides adequate
# information, but not really enough to let the player know what they're
# actually buying or even selling. This script enables shops to show more than
# just the basic information displayed in RPG Maker VX Ace and even allow for
# custom commands to be inserted.
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
# <image: string>
# Uses a picture from Graphics\Pictures\ of your RPG Maker VX Ace Project's
# directory with the filename of "string" (without the extension) as the image
# picture shown in the Ace Shop Options.
# 
# -----------------------------------------------------------------------------
# Weapon Notetags - These notetags go in the weapon notebox in the database.
# -----------------------------------------------------------------------------
# <image: string>
# Uses a picture from Graphics\Pictures\ of your RPG Maker VX Ace Project's
# directory with the filename of "string" (without the extension) as the image
# picture shown in the Ace Shop Options.
# 
# -----------------------------------------------------------------------------
# Armour Notetags - These notetags go in the armour notebox in the database.
# -----------------------------------------------------------------------------
# <image: string>
# Uses a picture from Graphics\Pictures\ of your RPG Maker VX Ace Project's
# directory with the filename of "string" (without the extension) as the image
# picture shown in the Ace Shop Options.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module SHOP
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Shop Command Window Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Here, you can adjust the order at which the commands appear (or even
    # remove commands as you see fit). Here's a list of which does what:
    # 
    # -------------------------------------------------------------------------
    # :command         Description
    # -------------------------------------------------------------------------
    # :buy             Buys items from the shop. Default.
    # :sell            Sells items top the shop. Default.
    # :cancel          Leaves the shop. Default.
    # 
    # :equip           Allows the player to change equipment inside the shop.
    # 
    # :totorishop      Requires Kread-EX's Synthesis Shop.
    # 
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    COMMANDS =[
      :buy,          # Buys items from the shop. Default.
      :sell,         # Sells items top the shop. Default.
      :equip,        # Allows the player to change equipment inside the shop.
      :totorishop,   # Requires Kread-EX's Synthesis Shop.
      :cancel,       # Leaves the shop. Default.
    # :custom1,      # Custom Command 1.
    # :custom2,      # Custom Command 2.
    ] # Do not remove this.
    
    #--------------------------------------------------------------------------
    # - Shop Custom Commands -
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # For those who use scripts to that may produce unique effects for their
    # shops, use this hash to manage the custom commands for the Shop Command
    # Window. You can disable certain commands or prevent them from appearing
    # by using switches. If you don't wish to bind them to a switch, set the
    # proper switch to 0 for it to have no impact.
    #--------------------------------------------------------------------------
    CUSTOM_SHOP_COMMANDS ={
    # :command => ["Display Name", EnableSwitch, ShowSwitch, Handler Method],
      :equip   => [       "Equip",            0,          0, :command_equip],
      :totorishop => [ "Synthesis",           0,      0, :command_synthshop],
      :custom1 => [ "Custom Name",            0,          0, :command_name1],
      :custom2 => [ "Custom Text",           13,          0, :command_name2],
    } # Do not remove this.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Shop Data Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # The shop data window displays information about the item in detail.
    # Adjust the settings below to change the way the data window appears.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    STATUS_FONT_SIZE = 20       # Font size used for data window.
    MAX_ICONS_DRAWN  = 10       # Maximum number of icons drawn for states.
    
    # The following adjusts the vocabulary used for the data window. Each
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
    
  end # SHOP
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module BASEITEM
    
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
    return YEA::SHOP::VOCAB_STATUS[type]
  end
  
end # Vocab

#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_aso load_database; end
  def self.load_database
    load_database_aso
    load_notetags_aso
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_aso
  #--------------------------------------------------------------------------
  def self.load_notetags_aso
    groups = [$data_items, $data_weapons, $data_armors]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_aso
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
  attr_accessor :image
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_aso
  #--------------------------------------------------------------------------
  def load_notetags_aso
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
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
  attr_accessor :scene_shop_index
  attr_accessor :scene_shop_oy
  
end # Game_Temp

#==============================================================================
# ■ Window_ShopCommand
#==============================================================================

class Window_ShopCommand < Window_HorzCommand
  
  #--------------------------------------------------------------------------
  # alias method: make_command_list
  #--------------------------------------------------------------------------
  alias window_shopcommand_make_command_list_aso make_command_list
  def make_command_list
    unless SceneManager.scene_is?(Scene_Shop)
      window_shopcommand_make_command_list_aso
      return
    end
    for command in YEA::SHOP::COMMANDS
      case command
      #--- Default Commands ---
      when :buy
        add_command(Vocab::ShopBuy, :buy)
      when :sell
        add_command(Vocab::ShopSell, :sell, !@purchase_only)
      when :cancel
        add_command(Vocab::ShopCancel, :cancel)
      #--- Imported Commands ---
      when :totorishop
        next unless $imported["KRX-SynthesisShop"]
        process_custom_command(command)
      #--- Custom Commands ---
      else
        process_custom_command(command)
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: process_custom_command
  #--------------------------------------------------------------------------
  def process_custom_command(command)
    return unless YEA::SHOP::CUSTOM_SHOP_COMMANDS.include?(command)
    show = YEA::SHOP::CUSTOM_SHOP_COMMANDS[command][2]
    continue = show <= 0 ? true : $game_switches[show]
    return unless continue
    text = YEA::SHOP::CUSTOM_SHOP_COMMANDS[command][0]
    switch = YEA::SHOP::CUSTOM_SHOP_COMMANDS[command][1]
    enabled = switch <= 0 ? true : $game_switches[switch]
    add_command(text, command, enabled)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: process_ok
  #--------------------------------------------------------------------------
  def process_ok
    $game_temp.scene_shop_index = index
    $game_temp.scene_shop_oy = self.oy
    super
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: window_width
  #--------------------------------------------------------------------------
  def window_width; return 160; end
  
  #--------------------------------------------------------------------------
  # overwrite method: contents_width
  #--------------------------------------------------------------------------
  def contents_width; return width - standard_padding * 2; end
  
  #--------------------------------------------------------------------------
  # overwrite method: contents_height
  #--------------------------------------------------------------------------
  def contents_height
    ch = height - standard_padding * 2
    return [ch - ch % item_height, row_max * item_height].max
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: visible_line_number
  #--------------------------------------------------------------------------
  def visible_line_number; return 4; end
  
  #--------------------------------------------------------------------------
  # overwrite method: col_max
  #--------------------------------------------------------------------------
  def col_max; return 1; end
    
  #--------------------------------------------------------------------------
  # overwrite method: item_rect
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new
    rect.width = item_width
    rect.height = item_height
    rect.x = index % col_max * (item_width + spacing)
    rect.y = index / col_max * item_height
    rect
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: ensure_cursor_visible
  #--------------------------------------------------------------------------
  def ensure_cursor_visible
    self.top_row = row if row < top_row
    self.bottom_row = row if row > bottom_row
  end
    
  #--------------------------------------------------------------------------
  # overwrite method: cursor_down
  #--------------------------------------------------------------------------
  def cursor_down(wrap = false)
    if index < item_max - col_max || (wrap && col_max == 1)
      select((index + col_max) % item_max)
    end
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: cursor_up
  #--------------------------------------------------------------------------
  def cursor_up(wrap = false)
    if index >= col_max || (wrap && col_max == 1)
      select((index - col_max + item_max) % item_max)
    end
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: process_pageup
  #--------------------------------------------------------------------------
  def process_pageup
    Sound.play_cursor
    Input.update
    deactivate
    call_handler(:pageup)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: process_pagedown
  #--------------------------------------------------------------------------
  def process_pagedown
    Sound.play_cursor
    Input.update
    deactivate
    call_handler(:pagedown)
  end
  
end # Window_ShopCommand

#==============================================================================
# ■ Window_ShopCategory
#==============================================================================

class Window_ShopCategory < Window_Command
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_reader   :item_window
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0)
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
  # update
  #--------------------------------------------------------------------------
  def update
    super
    @item_window.category = current_symbol if @item_window
  end
  
  #--------------------------------------------------------------------------
  # make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab::item,     :item)
    add_command(Vocab::weapon,   :weapon)
    add_command(Vocab::armor,    :armor)
    add_command(Vocab::key_item, :key_item)
  end
  
  #--------------------------------------------------------------------------
  # item_window=
  #--------------------------------------------------------------------------
  def item_window=(item_window)
    @item_window = item_window
    update
  end
  
end# Window_ShopCategory

#==============================================================================
# ■ Window_ShopBuy
#==============================================================================

class Window_ShopBuy < Window_Selectable
  
  #--------------------------------------------------------------------------
  # overwrite method: item
  #--------------------------------------------------------------------------
  def item
    return index < 0 ? nil : @data[index]
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: window_width
  #--------------------------------------------------------------------------
  def window_width
    return Graphics.width - (Graphics.width * 2 / 5)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    return if item.nil?
    rect = item_rect(index)
    draw_item_name(item, rect.x, rect.y, enable?(item), rect.width-24)
    rect.width -= 4
    contents.font.size = YEA::LIMIT::SHOP_FONT if $imported["YEA-AdjustLimits"]
    draw_text(rect, price(item).group, 2)
    reset_font_settings
  end
  
end # Window_ShopBuy

#==============================================================================
# ■ Window_ShopSell
#==============================================================================

class Window_ShopSell < Window_ItemList
  
  #--------------------------------------------------------------------------
  # overwrite method: initialize
  #--------------------------------------------------------------------------
  def initialize(dx, dy, dw, dh)
    dw = Graphics.width - (Graphics.width * 2 / 5)
    super(dx, dy, dw, dh)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: col_max
  #--------------------------------------------------------------------------
  def col_max; return 1; end
  
  #--------------------------------------------------------------------------
  # new method: status_window=
  #--------------------------------------------------------------------------
  def status_window= (window)
    @status_window = window
    call_update_help
  end
  
  #--------------------------------------------------------------------------
  # new method: update_help
  #--------------------------------------------------------------------------
  def update_help
    super
    @status_window.item = item if @status_window
  end
  
end # Window_ShopSell

#==============================================================================
# ■ Window_ShopStatus
#==============================================================================

class Window_ShopStatus < Window_Base
  
  #--------------------------------------------------------------------------
  # alias method: initialize
  #--------------------------------------------------------------------------
  alias window_shopstatus_initialize_aso initialize
  def initialize(dx, dy, dw, dh)
    dh = Graphics.height - SceneManager.scene.command_window.y
    dh -= SceneManager.scene.command_window.height + fitting_height(1)
    dy += fitting_height(1)
    window_shopstatus_initialize_aso(dx, dy, dw, dh)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: page_size
  #--------------------------------------------------------------------------
  def page_size
    n = contents.height - line_height
    n /= line_height
    return n
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: update_page
  #--------------------------------------------------------------------------
  def update_page
    return unless visible
    return if @item.nil?
    return if @item.is_a?(RPG::Item)
    return unless Input.trigger?(:A)
    return unless page_max > 1
    Sound.play_cursor
    @page_index = (@page_index + 1) % page_max
    refresh
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_equip_info
  #--------------------------------------------------------------------------
  def draw_equip_info(dx, dy)
    dy -= line_height
    status_members.each_with_index do |actor, i|
      draw_actor_equip_info(dx, dy + line_height * i, actor)
    end
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_actor_equip_info
  #--------------------------------------------------------------------------
  def draw_actor_equip_info(dx, dy, actor)
    enabled = actor.equippable?(@item)
    change_color(normal_color, enabled)
    draw_text(dx, dy, contents.width, line_height, actor.name)
    item1 = current_equipped_item(actor, @item.etype_id)
    draw_actor_param_change(dx, dy, actor, item1) if enabled
  end
  
end # Window_ShopStatus

#==============================================================================
# ■ Window_ShopNumber
#==============================================================================

class Window_ShopNumber < Window_Selectable
  
  #--------------------------------------------------------------------------
  # alias method: initialize
  #--------------------------------------------------------------------------
  alias window_shopnumber_initialize_aso initialize
  def initialize(dx, dy, dh)
    dh = Graphics.height - SceneManager.scene.command_window.y
    dh -= SceneManager.scene.command_window.height
    window_shopnumber_initialize_aso(dx, dy, dh)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: window_width
  #--------------------------------------------------------------------------
  def window_width
    return Graphics.width - (Graphics.width * 2 / 5)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: figures
  #--------------------------------------------------------------------------
  def figures
    maximum = @max.nil? ? 2 : @max.group.size
    return maximum
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    reset_font_settings
    draw_item_name(@item, 0, item_y, true, contents.width - 24)
    draw_number
    draw_total_price
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: item_y
  #--------------------------------------------------------------------------
  def item_y
    return contents_height / 2 - line_height * 5 / 2
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: price_y
  #--------------------------------------------------------------------------
  def price_y
    return item_y + line_height * 2
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_total_price
  #--------------------------------------------------------------------------
  def draw_total_price
    dw = contents_width - 8
    dy = price_y
    draw_currency_value($game_party.gold, @currency_unit, 4, dy, dw)
    dy += line_height
    draw_horz_line(dy)
    value = @price * @number
    value *= -1 if buy?
    draw_currency_value(value, @currency_unit, 4, dy, dw)
    dy += line_height
    value = $game_party.gold + value
    value = [[value, 0].max, $game_party.max_gold].min
    draw_currency_value(value, @currency_unit, 4, dy, dw)
  end
  
  #--------------------------------------------------------------------------
  # new method: buy?
  #--------------------------------------------------------------------------
  def buy?
    return SceneManager.scene.command_window.current_symbol == :buy
  end
  
  #--------------------------------------------------------------------------
  # new method: sell?
  #--------------------------------------------------------------------------
  def sell?
    return SceneManager.scene.command_window.current_symbol == :sell
  end
  
  #--------------------------------------------------------------------------
  # new method: draw_horz_line
  #--------------------------------------------------------------------------
  def draw_horz_line(dy)
    line_y = dy + line_height - 4
    contents.fill_rect(4, line_y, contents_width-8, 3, Font.default_out_color)
    contents.fill_rect(5, line_y+1, contents_width-10, 1, normal_color)
  end
  
  #--------------------------------------------------------------------------
  # alias method: update_number
  #--------------------------------------------------------------------------
  alias window_shopnumber_update_number_aso update_number
  def update_number
    window_shopnumber_update_number_aso
    change_number(-@max) if Input.repeat?(:L)
    change_number(@max)  if Input.repeat?(:R)
  end
  
end # Window_ShopNumber

#==============================================================================
# ■ Window_ShopData
#==============================================================================

class Window_ShopData < Window_Base
  
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
  # item_window=
  #--------------------------------------------------------------------------
  def item_window= (window)
    @item_window = window
    update_item(@item_window.item)
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
    contents.font.size = YEA::SHOP::STATUS_FONT_SIZE
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
      break if icons.size >= YEA::SHOP::MAX_ICONS_DRAWN
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
      break if icons.size >= YEA::SHOP::MAX_ICONS_DRAWN
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
  
end # Window_ShopData

#==============================================================================
# ■ Scene_Shop
#==============================================================================

class Scene_Shop < Scene_MenuBase
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :command_window
  
  #--------------------------------------------------------------------------
  # alias method: start
  #--------------------------------------------------------------------------
  alias scene_shop_start_aso start
  def start
    scene_shop_start_aso
    create_actor_window
    create_data_window
    clean_up_settings
    relocate_windows
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: return_scene
  #--------------------------------------------------------------------------
  def return_scene
    $game_temp.scene_shop_index = nil
    $game_temp.scene_shop_oy = nil
    super
  end
  
  #--------------------------------------------------------------------------
  # alias method: create_gold_window
  #--------------------------------------------------------------------------
  alias scene_shop_create_gold_window_aso create_gold_window
  def create_gold_window
    scene_shop_create_gold_window_aso
    @gold_window.width = Graphics.width * 2 / 5
    @gold_window.create_contents
    @gold_window.refresh
    @gold_window.x = Graphics.width - @gold_window.width
  end
  
  #--------------------------------------------------------------------------
  # alias method: create_command_window
  #--------------------------------------------------------------------------
  alias scene_shop_create_command_window_aso create_command_window
  def create_command_window
    scene_shop_create_command_window_aso
    return unless SceneManager.scene_is?(Scene_Shop)
    if !$game_temp.scene_shop_index.nil?
      @command_window.select($game_temp.scene_shop_index)
      @command_window.oy = $game_temp.scene_shop_oy
    end
    $game_temp.scene_shop_index = nil
    $game_temp.scene_shop_oy = nil
    @command_window.set_handler(:equip, method(:command_equip))
    process_custom_shop_commands
  end
  
  #--------------------------------------------------------------------------
  # new method: process_custom_shop_commands
  #--------------------------------------------------------------------------
  def process_custom_shop_commands
    for command in YEA::SHOP::COMMANDS
      next unless YEA::SHOP::CUSTOM_SHOP_COMMANDS.include?(command)
      called_method = YEA::SHOP::CUSTOM_SHOP_COMMANDS[command][3]
      @command_window.set_handler(command, method(called_method))
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: create_dummy_window
  #--------------------------------------------------------------------------
  alias scene_shop_create_dummy_window_aso create_dummy_window
  def create_dummy_window
    scene_shop_create_dummy_window_aso
    @gold_window.y = @dummy_window.y
    @dummy_window.opacity = 0
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: create_category_window
  #--------------------------------------------------------------------------
  def create_category_window
    @category_window = Window_ShopCategory.new
    @category_window.viewport = @viewport
    @category_window.help_window = @help_window
    @category_window.y = @command_window.y
    @category_window.deactivate
    @category_window.x = Graphics.width
    @category_window.set_handler(:ok,     method(:on_category_ok))
    @category_window.set_handler(:cancel, method(:on_category_cancel))
  end
  
  #--------------------------------------------------------------------------
  # new method: create_actor_window
  #--------------------------------------------------------------------------
  def create_actor_window
    @actor_window = Window_MenuActor.new
    @actor_window.set_handler(:ok,     method(:on_actor_ok))
    @actor_window.set_handler(:cancel, method(:on_actor_cancel))
  end
  
  #--------------------------------------------------------------------------
  # new method: create_data_window
  #--------------------------------------------------------------------------
  def create_data_window
    wx = @command_window.width
    wy = @command_window.y
    @data_window = Window_ShopData.new(wx, wy, @buy_window)
    @data_window.viewport = @viewport
  end
  
  #--------------------------------------------------------------------------
  # new method: clean_up_settings
  #--------------------------------------------------------------------------
  def clean_up_settings
    @dummy_window.create_contents
    @buy_window.show
    @buy_window.unselect
    @buy_window.money = money
    @last_buy_index = 0
    @status_window.show
    @sell_window.show
    @sell_window.x = Graphics.width
    @sell_window.status_window = @status_window
  end
  
  #--------------------------------------------------------------------------
  # new method: relocate_windows
  #--------------------------------------------------------------------------
  def relocate_windows
    return unless $imported["YEA-AceMenuEngine"]
    case Menu.help_window_location
    when 0 # Top
      @help_window.y = 0
      @command_window.y = @help_window.height
      @buy_window.y = @command_window.y + @command_window.height
    when 1 # Middle
      @command_window.y = 0
      @help_window.y = @command_window.height
      @buy_window.y = @help_window.y + @help_window.height
    else # Bottom
      @command_window.y = 0
      @buy_window.y = @command_window.height
      @help_window.y = @buy_window.y + @buy_window.height
    end
    @category_window.y = @command_window.y
    @data_window.y = @command_window.y
    @gold_window.y = @buy_window.y
    @sell_window.y = @buy_window.y
    @number_window.y = @buy_window.y
    @status_window.y = @gold_window.y + @gold_window.height
  end
  
  #--------------------------------------------------------------------------
  # new method: show_sub_window
  #--------------------------------------------------------------------------
  def show_sub_window(window)
    width_remain = Graphics.width - window.width
    window.x = width_remain
    @viewport.rect.x = @viewport.ox = 0
    @viewport.rect.width = width_remain
    window.show.activate
  end
  
  #--------------------------------------------------------------------------
  # new method: hide_sub_window
  #--------------------------------------------------------------------------
  def hide_sub_window(window)
    @viewport.rect.x = @viewport.ox = 0
    @viewport.rect.width = Graphics.width
    window.hide.deactivate
    @command_window.activate
  end
  
  #--------------------------------------------------------------------------
  # new method: on_actor_ok
  #--------------------------------------------------------------------------
  def on_actor_ok
    case @command_window.current_symbol
    when :equip
      Sound.play_ok
      $game_party.menu_actor = $game_party.members[@actor_window.index]
      SceneManager.call(Scene_Equip)
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: on_actor_cancel
  #--------------------------------------------------------------------------
  def on_actor_cancel
    hide_sub_window(@actor_window)
  end
  
  #--------------------------------------------------------------------------
  # alias method: activate_sell_window
  #--------------------------------------------------------------------------
  alias scene_shop_activate_sell_window_aso activate_sell_window
  def activate_sell_window
    scene_shop_activate_sell_window_aso
    @status_window.show
  end
  
  #--------------------------------------------------------------------------
  # alias method: command_buy
  #--------------------------------------------------------------------------
  alias scene_shop_command_buy_aso command_buy
  def command_buy
    scene_shop_command_buy_aso
    @buy_window.select(@last_buy_index)
    @data_window.item_window = @buy_window
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: command_sell
  #--------------------------------------------------------------------------
  def command_sell
    @dummy_window.hide
    @category_window.activate
    @category_window.x = 0
    @command_window.x = Graphics.width
    @sell_window.x = 0
    @buy_window.x = Graphics.width
    @sell_window.unselect
    @sell_window.refresh
    @data_window.item_window = @sell_window
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_buy_cancel
  #--------------------------------------------------------------------------
  alias scene_shop_on_buy_cancel_aso on_buy_cancel
  def on_buy_cancel
    @last_buy_index = @buy_window.index
    @buy_window.unselect
    scene_shop_on_buy_cancel_aso
    @buy_window.show
    @status_window.show
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_sell_ok
  #--------------------------------------------------------------------------
  alias scene_shop_on_sell_ok_aso on_sell_ok
  def on_sell_ok
    scene_shop_on_sell_ok_aso
    @category_window.show
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: on_category_cancel
  #--------------------------------------------------------------------------
  def on_category_cancel
    @command_window.activate
    @dummy_window.show
    @category_window.x = Graphics.width
    @command_window.x = 0
    @sell_window.x = Graphics.width
    @buy_window.money = money
    @buy_window.x = 0
  end
  
  #--------------------------------------------------------------------------
  # new method: current_command_window_symbol
  #--------------------------------------------------------------------------
  def current_command_window_symbol
    return @command_window.current_symbol
  end
  
  #--------------------------------------------------------------------------
  # new method: current_command_window_y
  #--------------------------------------------------------------------------
  def current_command_window
    return @command_window
  end
  
  #--------------------------------------------------------------------------
  # new method: command_equip
  #--------------------------------------------------------------------------
  def command_equip
    show_sub_window(@actor_window)
    @actor_window.select_last
  end
  
  #--------------------------------------------------------------------------
  # new method: command_synthshop
  #--------------------------------------------------------------------------
  def command_synthshop
    SceneManager.call(Scene_SynthesisShop)
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
  
end # Scene_Shop

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================