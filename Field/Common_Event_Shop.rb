#==============================================================================
# 
# ▼ Yanfly Engine Ace - Common Event Shop v1.00
# -- Last Updated: 2012.01.13
# -- Level: Normal, Hard
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-CommonEventShop"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.13 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Sometimes, being able to buy items just isn't enough. With the common event
# shop, you can set anything to be sold as long as you can event it. Expanded
# upon the original Yanfly Engine ReDux version, the Ace version gives more
# options such as using custom switches to enable/disable common events from
# being bought or even appearing. And if that wasn't enough, advanced users can
# use eval strings for more conditional common events.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Common Event Notetags - These notetags go in a common event's comments.
# -----------------------------------------------------------------------------
# <cost: x>
# Sets the gold cost of the common event to x gold. If this notetag is not used
# the default gold cost will be whatever DEFAULT_COST is in the script module.
# 
# <exit shop>
# When this event is bought, the player will automatically exit the shop before
# the common event will take place. If this tag is not used, the common event's
# contents will take place inside of the common event shop.
# 
# <icon: x>
# Changes the icon used for the common event to x icon index. If this notetag
# is not used, the icon used for the common event will be whatever DEFAULT_ICON
# is in the script module.
# 
# <image: string>
# Changes the image used for the common event to filename "string" found in
# the Graphics\Pictures\ folder. Requires Ace Shop Options to use. If this tag
# is not used, the image displayed will be the common event's expanded icon.
# 
# <help description>
#  string
# </help description>
# Sets the text used for the help window in the shop scene. Multiple lines in
# the notebox will be strung together. Use | for a line break. Text codes may
# be used inside of the help description.
# 
# <shop data>
#  string
# </shop data>
# Can be used if you have Yanfly Engine Ace - Ace Shop Options installed. Sets
# the string as the text shown inside the data window the shop. Use | for a
# line break. Text codes may be used inside of the shop data text.
# 
# <shop variables: x>
# <shop variables: x, x>
# This sets the variable x displayed in the status window in the lower right
# corner of the screen. Insert multiples of this notetag to display more
# variables inside of the status window.
# 
# <shop enable switch: x>
# <shop enable switch: x, x>
# This notetag will cause the common event item to require switch x to be ON
# before the common event can be bought. Insert multiples of these notetags to
# require more switches to be ON before the common event item can be gouth.
# 
# <shop enable eval>
#  string
#  string
# </shop enable eval>
# Advanced users can enable and disable common events from being bought through
# this notetag. Replace string with lines of code to check for whether or not
# the common event can be sold. If multiple lines are used, they are considered
# to be a part of the same line.
# 
# <shop show switch: x>
# <shop show switch: x, x>
# This notetag will cause the common event item to be hidden unless switch x is
# ON. Insert multiple of these notetags to require more switches to be ON
# before the common event item will be shown in the shop.
# 
# <shop show eval>
#  string
#  string
# </shop show eval>
# Advanced users can show and hide common events from being listed in the buy
# list through this notetag. Replace string with lines of code to check for
# whether or not the common event will be shown. If multiple lines are used,
# they are considered to be a part of the same line.
# 
# -----------------------------------------------------------------------------
# Script Calls - These commands are used with script calls.
# -----------------------------------------------------------------------------
# common_event_shop(x)
# This will call common event shop x. x will the shop ID used from the SHOPS
# hash in the script's module. Any items placed within the array assigned to
# the shop ID will be sold as common events.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
# This script is compatible with Yanfly Engine Ace - Ace Shop Options v1.00+.
# The position of this script does not matter relative to the other script.
# 
#==============================================================================

module YEA
  module COMMON_EVENT_SHOP
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - General Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These settings below adjust the default costs for common events (if no
    # custom costs are used), the default icons used, and what kinds of common
    # events are sold for each of the shop ID's.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    DEFAULT_COST = 1000        # Default gold cost for common events.
    DEFAULT_ICON = 236         # Default icon used for common events.
    
    # This hash adjusts the common events sold in each of the shop ID's. Insert
    # the common events you want sold inside of the arrays with the shop ID as
    # the hash key. You can use number ranges to add common events quicker.
    SHOPS ={
    # ID  => [Common Event ID's],
       1  => [1, 2..8, 9, 10],
       2  => [11..20],
       3  => [21..30],
    } # Do not remove this.
    
  end # COMMON_EVENT_SHOP
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module COMMON_EVENT_SHOP
    module_function
    #--------------------------------------------------------------------------
    # convert_integer_array
    #--------------------------------------------------------------------------
    def convert_integer_array(array)
      result = []
      array.each { |i|
        case i
        when Range; result |= i.to_a
        when Integer; result |= [i]
        end }
      return result
    end
    #--------------------------------------------------------------------------
    # convert_full_hash
    #--------------------------------------------------------------------------
    def convert_full_hash(hash)
      result = {}
      hash.each { |key| result[key[0]] = convert_integer_array(key[1]) }
      return result
    end
    #--------------------------------------------------------------------------
    # converted_contants
    #--------------------------------------------------------------------------
    SHOPS = convert_full_hash(SHOPS)
  end # COMMON_EVENT_SHOP
  module REGEXP
  module COMMONEVENT
    
    COST                 = /<(?:COST|shop cost):[ ](\d+)>/i
    IMAGE                = /<(?:IMAGE|image):[ ](.*)>/i
    ICON_INDEX           = /<(?:ICON|icon index):[ ](\d+)>/i
    EVENT_TYPE_EXIT      = /<(?:EXIT_SHOP|exit shop)>/i
    SHOP_VARIABLES       = 
      /<(?:SHOP_VARIABLES|shop variables):[ ]*(\d+(?:\s*,\s*\d+)*)>/i
    HELP_DESCRIPTION_ON  = /<(?:HELP_DESCRIPTION|help description)>/i
    HELP_DESCRIPTION_OFF = /<\/(?:HELP_DESCRIPTION|help description)>/i
    SHOP_DATA_ON         = /<(?:SHOP_DATA|shop data)>/i
    SHOP_DATA_OFF        = /<\/(?:SHOP_DATA|shop data)>/i
    SHOP_ENABLE_SWITCH   =
      /<(?:SHOP_ENABLE_SWITCH|shop enable switch):[ ]*(\d+(?:\s*,\s*\d+)*)>/i
    SHOP_SHOW_SWITCH     =
      /<(?:SHOP_SHOW_SWITCH|shop show switch):[ ]*(\d+(?:\s*,\s*\d+)*)>/i
    SHOP_ENABLE_EVAL_ON  = /<(?:SHOP_ENABLE_EVAL|shop enable eval)>/i
    SHOP_ENABLE_EVAL_OFF = /<\/(?:SHOP_ENABLE_EVAL|shop enable eval)>/i
    SHOP_SHOW_EVAL_ON    = /<(?:SHOP_SHOW_EVAL|shop show eval)>/i
    SHOP_SHOW_EVAL_OFF   = /<\/(?:SHOP_SHOW_EVAL|shop show eval)>/i
    
  end # COMMONEVENT
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
  class <<self; alias load_database_ces load_database; end
  def self.load_database
    load_database_ces
    load_notetags_ces
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_ces
  #--------------------------------------------------------------------------
  def self.load_notetags_ces
    groups = [$data_common_events]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_ces
      end
    end
  end
  
end # DataManager

#==============================================================================
# ■ RPG::Actor
#==============================================================================

class RPG::CommonEvent
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :cost
  attr_accessor :description
  attr_accessor :event_type
  attr_accessor :icon_index
  attr_accessor :image
  attr_accessor :shop_variables
  attr_accessor :shop_data
  attr_accessor :shop_enable_switch
  attr_accessor :shop_enable_eval
  attr_accessor :shop_show_switch
  attr_accessor :shop_show_eval
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_ces
  #--------------------------------------------------------------------------
  def load_notetags_ces
    @cost = YEA::COMMON_EVENT_SHOP::DEFAULT_COST
    @description = ""
    @event_type = :instore
    @icon_index = YEA::COMMON_EVENT_SHOP::DEFAULT_ICON
    @image = nil
    @shop_variables = []
    @shop_data = ""
    @shop_enable_switch = []
    @shop_enable_eval = nil
    @shop_show_switch = []
    @shop_show_eval = nil
    @help_description_on = false
    @shop_data_on = false
    @shop_enable_eval_on = false
    @shop_show_eval_on = false
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::COMMONEVENT::COST
        @cost = $1.to_i
      when YEA::REGEXP::COMMONEVENT::ICON_INDEX
        @icon_index = $1.to_i
      when YEA::REGEXP::COMMONEVENT::IMAGE
        @image = $1.to_s
      #---
      when YEA::REGEXP::COMMONEVENT::EVENT_TYPE_EXIT
        @event_type = :exit
      #---
      when YEA::REGEXP::COMMONEVENT::SHOP_VARIABLES
        $1.scan(/\d+/).each { |num| 
        @shop_variables.push(num.to_i) if num.to_i > 0 }
      when YEA::REGEXP::COMMONEVENT::SHOP_ENABLE_SWITCH
        $1.scan(/\d+/).each { |num| 
        @shop_enable_switch.push(num.to_i) if num.to_i > 0 }
      when YEA::REGEXP::COMMONEVENT::SHOP_SHOW_SWITCH
        $1.scan(/\d+/).each { |num| 
        @shop_show_switch.push(num.to_i) if num.to_i > 0 }
      #---
      when YEA::REGEXP::COMMONEVENT::HELP_DESCRIPTION_ON
        @help_description_on = true
      when YEA::REGEXP::COMMONEVENT::HELP_DESCRIPTION_OFF
        @help_description_on = false
      when YEA::REGEXP::COMMONEVENT::SHOP_DATA_ON
        @shop_data_on = true
      when YEA::REGEXP::COMMONEVENT::SHOP_DATA_OFF
        @shop_data_on = false
      when YEA::REGEXP::COMMONEVENT::SHOP_ENABLE_EVAL_ON
        @shop_enable_eval = ""
        @shop_enable_eval_on = true
      when YEA::REGEXP::COMMONEVENT::SHOP_ENABLE_EVAL_OFF
        @shop_enable_eval_on = false
      when YEA::REGEXP::COMMONEVENT::SHOP_SHOW_EVAL_ON
        @shop_show_eval = ""
        @shop_show_eval_on = true
      when YEA::REGEXP::COMMONEVENT::SHOP_SHOW_EVAL_OFF
        @shop_show_eval_on = false
      else
        @description += line.to_s if @help_description_on
        @shop_data += line.to_s if @shop_data_on
        @shop_enable_eval += line.to_s if @shop_enable_eval_on
        @shop_show_eval += line.to_s if @shop_show_eval_on
      #---
      end
    } # self.note.split
    #---
    @description.gsub!(/[|]/i) { "\n" }
    @shop_data.gsub!(/[|]/i) { "\n" }
  end
  
  #--------------------------------------------------------------------------
  # new method: note
  #--------------------------------------------------------------------------
  def note
    @note = ""
    @list.each { |event|
      next if event.nil?
      next unless [108, 408].include?(event.code)
      @note += event.parameters[0] + "\r\n"
    } # Do not remove
    return @note
  end
  
end # RPG::Actor

#==============================================================================
# ■ Game_Interpreter
#==============================================================================

class Game_Interpreter
  
  #--------------------------------------------------------------------------
  # common_event_shop
  #--------------------------------------------------------------------------
  def common_event_shop(shop_id)
    return unless SceneManager.scene_is?(Scene_Map)
    return unless YEA::COMMON_EVENT_SHOP::SHOPS.include?(shop_id)
    SceneManager.call(Scene_CommonEventShop)
    goods = YEA::COMMON_EVENT_SHOP::SHOPS[shop_id]
    SceneManager.scene.prepare(goods)
  end
  
end # Game_Interpreter

#==============================================================================
# ■ Spriteset_CommonEventShop
#==============================================================================

class Spriteset_CommonEventShop < Spriteset_Map
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize
    create_viewports
    create_pictures
    update
  end
  
  #--------------------------------------------------------------------------
  # create_viewports
  #--------------------------------------------------------------------------
  def create_viewports
    @viewport = Viewport.new
    @viewport.z = 2000
  end
  
  #--------------------------------------------------------------------------
  # dispose
  #--------------------------------------------------------------------------
  def dispose
    dispose_pictures
    dispose_viewports
  end
  
  #--------------------------------------------------------------------------
  # dispose_viewports
  #--------------------------------------------------------------------------
  def dispose_viewports
    @viewport.dispose
  end
  
  #--------------------------------------------------------------------------
  # update
  #--------------------------------------------------------------------------
  def update
    update_pictures
    update_viewports
  end
  
  #--------------------------------------------------------------------------
  # update_viewports
  #--------------------------------------------------------------------------
  def update_viewports
    @viewport.update
  end
  
  #--------------------------------------------------------------------------
  # update_pictures
  #--------------------------------------------------------------------------
  def update_pictures
    $game_map.screen.pictures.each do |pic|
      @picture_sprites[pic.number] ||= Sprite_Picture.new(@viewport, pic)
      @picture_sprites[pic.number].update
    end
  end
  
end # Spriteset_CommonEventShop

#==============================================================================
# ■ Window_Message
#==============================================================================

class Window_Message < Window_Base
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :back_sprite
  
end # Window_Message

#==============================================================================
# ■ Window_CommonEventShopCommand
#==============================================================================

class Window_CommonEventShopCommand < Window_ShopCommand
  
  #--------------------------------------------------------------------------
  # col_max
  #--------------------------------------------------------------------------
  def col_max
    return super if $imported["YEA-ShopOptions"]
    return 2
  end
  
  #--------------------------------------------------------------------------
  # make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab::ShopBuy,    :buy)
    add_command(Vocab::ShopCancel, :cancel)
  end
  
end # Window_CommonEventShopCommand

#==============================================================================
# ■ Window_CommonEventShopStatus
#==============================================================================

class Window_CommonEventShopStatus < Window_ShopStatus
  
  #--------------------------------------------------------------------------
  # update_page
  #--------------------------------------------------------------------------
  def update_page
  end
  
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    reset_font_settings
    draw_shop_variables
  end
  
  #--------------------------------------------------------------------------
  # draw_shop_variables
  #--------------------------------------------------------------------------
  def draw_shop_variables
    return if @item.nil?
    dy = 0
    for variable_id in @item.shop_variables
      next if $game_variables[variable_id].nil?
      draw_variable_info(variable_id, dy)
      dy += line_height
      return if dy + line_height > contents.height
    end
  end
  
  #--------------------------------------------------------------------------
  # draw_variable_info
  #--------------------------------------------------------------------------
  def draw_variable_info(variable_id, dy)
    change_color(system_color)
    name = $data_system.variables[variable_id]
    draw_text(4, dy, contents.width - 8, line_height, name)
    change_color(normal_color)
    value = $game_variables[variable_id]
    value = value.group if value.is_a?(Integer)
    draw_text(4, dy, contents.width - 8, line_height, value, 2)
  end
  
end # Window_CommonEventShopStatus

#==============================================================================
# ■ Window_CommonEventShopBuy
#==============================================================================

class Window_CommonEventShopBuy < Window_ShopBuy
  
  #--------------------------------------------------------------------------
  # make_item_list
  #--------------------------------------------------------------------------
  def make_item_list
    @data = []
    @price = {}
    @shop_goods.each do |event_id|
      next if $data_common_events[event_id].nil?
      item = $data_common_events[event_id]
      next unless include?(item)
      @data.push(item)
      @price[item] = item.cost
    end
  end
  
  #--------------------------------------------------------------------------
  # include?
  #--------------------------------------------------------------------------
  def include?(item)
    return false unless show_show_switch?(item)
    return false unless shop_show_eval?(item)
    return true
  end
  
  #--------------------------------------------------------------------------
  # show_show_switch?
  #--------------------------------------------------------------------------
  def show_show_switch?(item)
    return false if item.nil?
    for switch_id in item.shop_show_switch
      return false unless $game_switches[switch_id]
    end
    return true
  end
  
  #--------------------------------------------------------------------------
  # shop_show_eval?
  #--------------------------------------------------------------------------
  def shop_show_eval?(item)
    return false if item.nil?
    return true if item.shop_show_eval.nil?
    return eval(item.shop_show_eval)
  end
  
  #--------------------------------------------------------------------------
  # draw_item_name
  #--------------------------------------------------------------------------
  def draw_item_name(item, dx, dy, enabled = true, dw = 172)
    return if item.nil?
    draw_icon(item.icon_index, dx, dy, enabled)
    change_color(normal_color, enabled)
    draw_text(dx+24, dy, dw, line_height, item.name)
  end
  
  #--------------------------------------------------------------------------
  # enable?
  #--------------------------------------------------------------------------
  def enable?(item)
    return false unless shop_enable_switch?(item)
    return false unless shop_enable_eval?(item)
    return !item.nil? && (price(item) <= @money)
  end
  
  #--------------------------------------------------------------------------
  # shop_enable_switch?
  #--------------------------------------------------------------------------
  def shop_enable_switch?(item)
    return false if item.nil?
    for switch_id in item.shop_enable_switch
      return false unless $game_switches[switch_id]
    end
    return true
  end
  
  #--------------------------------------------------------------------------
  # shop_req_eval?
  #--------------------------------------------------------------------------
  def shop_enable_eval?(item)
    return false if item.nil?
    return true if item.shop_enable_eval.nil?
    return eval(item.shop_enable_eval)
  end
  
end # Window_CommonEventShopBuy

#==============================================================================
# ■ Window_CommonEventShopData
#==============================================================================

class Window_CommonEventShopData < Window_Base
  
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
    draw_empty
    return if @item.nil?
    draw_item_image
    draw_item_data
  end
  
  #--------------------------------------------------------------------------
  # draw_empty
  #--------------------------------------------------------------------------
  def draw_empty
    colour = Color.new(0, 0, 0, translucent_alpha/2)
    rect = Rect.new(1, 1, 94, 94)
    contents.fill_rect(rect, colour)
    dx = 96; dy = 0
    dw = contents.width - 96
    for i in 0...4
      draw_background_box(dx, dy, dw)
      dy += line_height
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
  # draw_item_data
  #--------------------------------------------------------------------------
  def draw_item_data
    draw_text_ex(98, 0, @item.shop_data)
  end
  
end # Window_CommonEventShopData

#==============================================================================
# ■ Scene_CommonEventShop
#==============================================================================

class Scene_CommonEventShop < Scene_Shop
  
  #--------------------------------------------------------------------------
  # prepare
  #--------------------------------------------------------------------------
  def prepare(goods)
    @goods = goods
    @purchase_only = true
  end
  
  #--------------------------------------------------------------------------
  # start
  #--------------------------------------------------------------------------
  def start
    super
    setup_interpreter
  end
  
  #--------------------------------------------------------------------------
  # terminate
  #--------------------------------------------------------------------------
  def terminate
    @spriteset.dispose
    super
  end
  
  #--------------------------------------------------------------------------
  # create_command_window
  #--------------------------------------------------------------------------
  def create_command_window
    wx = @gold_window.x
    @command_window = Window_CommonEventShopCommand.new(wx, false)
    @command_window.viewport = @viewport
    @command_window.y = @help_window.height
    @command_window.set_handler(:buy,    method(:command_buy))
    @command_window.set_handler(:cancel, method(:return_scene))
  end
  
  #--------------------------------------------------------------------------
  # create_status_window
  #--------------------------------------------------------------------------
  def create_status_window
    wx = @number_window.width
    wy = @dummy_window.y
    ww = Graphics.width - wx
    wh = @dummy_window.height
    @status_window = Window_CommonEventShopStatus.new(wx, wy, ww, wh)
    @status_window.viewport = @viewport
    @status_window.hide
  end
  
  #--------------------------------------------------------------------------
  # create_buy_window
  #--------------------------------------------------------------------------
  def create_buy_window
    wy = @dummy_window.y
    wh = @dummy_window.height
    @buy_window = Window_CommonEventShopBuy.new(0, wy, wh, @goods)
    @buy_window.viewport = @viewport
    @buy_window.help_window = @help_window
    @buy_window.status_window = @status_window
    @buy_window.hide
    @buy_window.set_handler(:ok,     method(:on_buy_ok))
    @buy_window.set_handler(:cancel, method(:on_buy_cancel))
  end
  
  #--------------------------------------------------------------------------
  # create_data_window
  #--------------------------------------------------------------------------
  def create_data_window
    return unless $imported["YEA-ShopOptions"]
    wx = @command_window.width
    wy = @command_window.y
    @data_window = Window_CommonEventShopData.new(wx, wy, @buy_window)
    @data_window.viewport = @viewport
  end
  
  #--------------------------------------------------------------------------
  # setup_interpreter
  #--------------------------------------------------------------------------
  def setup_interpreter
    @interpreter = Game_Interpreter.new
    @message_window = Window_Message.new
    @message_window.back_opacity = 255
    @message_window.back_sprite.viewport = @viewport
    @spriteset = Spriteset_CommonEventShop.new
  end
  
  #--------------------------------------------------------------------------
  # update_interpreter
  #--------------------------------------------------------------------------
  def update_interpreter
    update_basic
    @interpreter.update
  end
  
  #--------------------------------------------------------------------------
  # update_basic
  #--------------------------------------------------------------------------
  def update_basic
    $game_map.screen.update_pictures
    @spriteset.update
    super
  end
  
  #--------------------------------------------------------------------------
  # on_buy_ok
  #--------------------------------------------------------------------------
  def on_buy_ok
    perform_buy
    instore_event
    exit_event
  end
  
  #--------------------------------------------------------------------------
  # perform_buy
  #--------------------------------------------------------------------------
  def perform_buy
    Sound.play_shop
    $game_party.lose_gold(@buy_window.price(@buy_window.item))
    @buy_window.money = money
    @gold_window.refresh
  end
  
  #--------------------------------------------------------------------------
  # instore_event
  #--------------------------------------------------------------------------
  def instore_event
    event = @buy_window.item
    return unless event.event_type == :instore
    $game_temp.reserve_common_event(event.id)
    @interpreter.setup_reserved_common_event
    update_interpreter while @interpreter.running?
    common_event_refresh_windows
  end
  
  #--------------------------------------------------------------------------
  # exit_event
  #--------------------------------------------------------------------------
  def exit_event
    event = @buy_window.item
    return unless event.event_type == :exit
    $game_temp.reserve_common_event(event.id)
    return_scene
  end
  
  #--------------------------------------------------------------------------
  # common_event_refresh_windows
  #--------------------------------------------------------------------------
  def common_event_refresh_windows
    @buy_window.activate
    @buy_window.money = money
    @buy_window.refresh
    @buy_window.select([@buy_window.index, @buy_window.item_max - 1].min)
    @status_window.refresh
    @gold_window.refresh
    @data_window.refresh unless @data_window.nil?
  end
  
end # Scene_CommonEventShop

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================