#==============================================================================
# 
# ▼ Yanfly Engine Ace - Party System v1.08
# -- Last Updated: 2012.01.23
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-PartySystem"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.23 - Bug fixed: Party members are now rearranged when newly added.
# 2012.01.14 - New Feature: Maximum Battle Members Variable added.
# 2012.01.07 - Bug fixed: Error with removing members.
# 2012.01.05 - Bug fixed: Escape skill/item effects no longer counts as death.
# 2011.12.26 - Compatibility Update: New Game+
# 2011.12.17 - Updated Spriteset_Battle to have updated sprite counts.
# 2011.12.13 - Updated to provide better visual display when more than 5 pieces
#              of equipment are equipped on an actor at a time.
# 2011.12.05 - Added functionality to display faces in the Party Select Window.
#            - Fixed bug that doesn't refresh the caterpillar when new members
#              join the party.
# 2011.12.04 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# RPG Maker VX Ace comes with a very nice party system. However, changing the
# maximum number of members isn't possible without the aid of a script. This
# script enables you the ability to change the maximum number of party members,
# change EXP rates, and/or open up a separate party menu (if desired). In
# addition to that, you can lock the position of actors within a party and
# require other actors to be in the active party before continuing.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Script Calls - These commands are used with script calls.
# -----------------------------------------------------------------------------
# *IMPORTANT* These script calls require the new party menu to be enabled to
# use them. Otherwise, nothing will happen.
# 
# lock_actor(x)
# unlock_actor(x)
# This will lock actor x in its current position in the party if the actor is
# in the current party. The actor is unable to switch position and must remain
# in that position until the lock is removed. Use the unlock script call to
# remove the locked status. This script requires the actor to have joined and
# in the current party before the script call will work.
# 
# require_actor(x)
# unrequire_actor(x)
# This will cause the party to require actor x in order to continue. If the
# actor isn't in the current party but is in the reserve party, the party menu
# will open up and prompt the player to add the required actor into the party
# before being able to continue. This script call will not function unless the
# specific actor has joined the party, whether it is in the current or reserve.
# 
# call_party_menu
# This will open up the party menu. This script call requires for the party
# menu to be enabled to use.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module PARTY
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - General Party Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # In this section, you can adjust the general party settings for your game
    # such as the maximum amount of members and whatnot, the EXP rate for
    # party members in the reserve, etc.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    MAX_BATTLE_MEMBERS   = 5      # Maximum party members. Default: 4
    SPLIT_EXP            = false  # Splits EXP with more members in the party.
    RESERVE_EXP_RATE     = 0.50   # Reserve EXP Rate. Default: 1.00
    
    # If you wish to be able to change the maximum number of battle members
    # during the middle of your game, set this constant to a variable ID. If
    # that variable ID is a number greater than 0, that variable will determine
    # the current maximum number of battle members. Be cautious about using
    # this during battle.
    MAX_MEMBERS_VARIABLE = 0
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Party Menu Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This section contains various menu settings for those who wish to use a
    # menu separate for the party system. Here, adjust the menu command order,
    # icons used, and other settings.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    ENABLE_MENU = true   # Enables party menu. Default: false
    COMMANDS =[          # The order at which the menu items are shown.
    # [:command,  "Display"],
      [ :change,  "Change",],
      [ :remove,  "Remove",],
      [ :revert,  "Revert",],
      [ :finish,  "Finish",],
    ] # Do not remove this.
    COMMAND_ALIGN    = 1     # 0:Left Align, 1:Center Align, 2:Right Align
    
    # These settings here are used for the upper right window: the Party Select
    # window where the player selects a member to swap out or remove.
    PARTY_FONT_SIZE  = 20    # Font size used for party member names.
    LOCK_FIRST_ACTOR = false # Lock the first actor by default?
    LOCKED_ICON      = 125   # Icon used for locked members.
    REQUIRED_ICON    = 126   # Icon used for required members.
    EMPTY_TEXT = "-Empty-"   # Text used when a member isn't present.
    DISPLAY_FACE     = false # Display faces instead of sprites?
    
    # These settings here are used for the lower left window: the Party List
    # window where the player selects a member to replace.
    REMOVE_ICON      = 185          # Icon used for removing members.
    REMOVE_TEXT      = "-Remove-"   # Text used for remove member command.
    ACTOR_Y_BUFFER   = 12           # Amount the actor graphic be adjusted by.
    
    # These settings here are used for the lower right window: the Party Status
    # window where info about a selected actor is shown.
    NO_DATA         = "- No Data -" # Text used for when no actor is shown.
    IN_PARTY_COLOUR = 6             # Text colour used for in party members.
    STAT_FONT_SIZE  = 20            # Font size used for stats.
    EQUIP_TEXT      = "Equipment"   # Text used to display equipment.
    
  end # PARTY
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

#==============================================================================
# ■ Icon
#==============================================================================

module Icon
  
  #--------------------------------------------------------------------------
  # self.locked_party
  #--------------------------------------------------------------------------
  def self.locked_party; return YEA::PARTY::LOCKED_ICON; end
  
  #--------------------------------------------------------------------------
  # self.required_party
  #--------------------------------------------------------------------------
  def self.required_party; return YEA::PARTY::REQUIRED_ICON; end
  
  #--------------------------------------------------------------------------
  # self.remove_party
  #--------------------------------------------------------------------------
  def self.remove_party; return YEA::PARTY::REMOVE_ICON; end
    
end # Icon

#==============================================================================
# ■ Variable
#==============================================================================

module Variable
  
  #--------------------------------------------------------------------------
  # self.max_battle_members
  #--------------------------------------------------------------------------
  def self.max_battle_members
    default = YEA::PARTY::MAX_BATTLE_MEMBERS
    return default if YEA::PARTY::MAX_MEMBERS_VARIABLE <= 0
    return default if $game_variables[YEA::PARTY::MAX_MEMBERS_VARIABLE] <= 0
    return $game_variables[YEA::PARTY::MAX_MEMBERS_VARIABLE]
  end
  
end # Variable

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
# ■ Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :locked
  attr_accessor :required
  
  #--------------------------------------------------------------------------
  # alias method: setup
  #--------------------------------------------------------------------------
  alias game_actor_setup_ps setup
  def setup(actor_id)
    game_actor_setup_ps(actor_id)
    @locked = false
    @required = false
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: final_exp_rate
  #--------------------------------------------------------------------------
  def final_exp_rate
    n = exr * (battle_member? ? 1 : reserve_members_exp_rate)
    if $game_party.in_battle
      n /= [$game_party.battle_members.size, 1].max if YEA::PARTY::SPLIT_EXP
    end
    return n
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: reserve_members_exp_rate
  #--------------------------------------------------------------------------
  def reserve_members_exp_rate
    $data_system.opt_extra_exp ? YEA::PARTY::RESERVE_EXP_RATE : 0
  end
  
end # Game_Actor

#==============================================================================
# ■ Game_Party
#==============================================================================

class Game_Party < Game_Unit
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :battle_members_array
  
  #--------------------------------------------------------------------------
  # alias method: initialize
  #--------------------------------------------------------------------------
  alias game_party_initialize_ps initialize
  def initialize
    game_party_initialize_ps
    @battle_members_array = nil
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: max_battle_members
  #--------------------------------------------------------------------------
  def max_battle_members; return Variable.max_battle_members; end
  
  #--------------------------------------------------------------------------
  # alias method: setup_starting_members
  #--------------------------------------------------------------------------
  alias setup_starting_members_ps setup_starting_members
  def setup_starting_members
    setup_starting_members_ps
    initialize_battle_members
    return unless YEA::PARTY::LOCK_FIRST_ACTOR
    return if members[0].nil?
    members[0].locked = true
  end
  
  #--------------------------------------------------------------------------
  # alias method: setup_battle_test_members
  #--------------------------------------------------------------------------
  alias setup_battle_test_members_ps setup_battle_test_members
  def setup_battle_test_members
    setup_battle_test_members_ps
    return unless YEA::PARTY::LOCK_FIRST_ACTOR
    return if members[0].nil?
    members[0].locked = true
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: battle_members
  #--------------------------------------------------------------------------
  def battle_members
    initialize_battle_members if initialize_battle_members?
    array = []
    for actor_id in @battle_members_array
      break if array.size > max_battle_members
      next if actor_id.nil?
      next if $game_actors[actor_id].nil?
      next unless $game_actors[actor_id].exist?
      array.push($game_actors[actor_id])
    end
    return array
  end
  
  #--------------------------------------------------------------------------
  # new method: initialize_battle_members?
  #--------------------------------------------------------------------------
  def initialize_battle_members?
    return true if @battle_members_array.nil?
    return @battle_members_array.size != max_battle_members
  end
  
  #--------------------------------------------------------------------------
  # new method: initialize_battle_members
  #--------------------------------------------------------------------------
  def initialize_battle_members
    @battle_members_array = []
    for i in 0...max_battle_members
      @battle_members_array.push(@actors[i]) unless @actors[i].nil?
      @battle_members_array.push(0) if @actors[i].nil?
    end
    $game_player.refresh
  end
  
  #--------------------------------------------------------------------------
  # alias method: add_actor
  #--------------------------------------------------------------------------
  alias game_party_add_actor_ps add_actor
  def add_actor(actor_id)
    game_party_add_actor_ps(actor_id)
    return if @battle_members_array.include?(actor_id)
    return unless @battle_members_array.include?(0)
    index = @battle_members_array.index(0)
    @battle_members_array[index] = actor_id
    $game_player.refresh
    $game_map.need_refresh = true
    rearrange_actors
  end
  
  #--------------------------------------------------------------------------
  # alias method: remove_actor
  #--------------------------------------------------------------------------
  alias game_party_remove_actor_ps remove_actor
  def remove_actor(actor_id)
    game_party_remove_actor_ps(actor_id)
    return unless @battle_members_array.include?(actor_id)
    index = @battle_members_array.index(actor_id)
    @battle_members_array[index] = 0
    $game_player.refresh
    $game_map.need_refresh = true
    rearrange_actors
  end
  
  #--------------------------------------------------------------------------
  # new method: rearrange_actors
  #--------------------------------------------------------------------------
  def rearrange_actors
    initialize_battle_members if @battle_members_array.nil?
    array = []
    for actor_id in @battle_members_array
      next if [0, nil].include?(actor_id)
      next if $game_actors[actor_id].nil?
      array.push(actor_id)
    end
    for actor_id in @actors
      next if array.include?(actor_id)
      next if $game_actors[actor_id].nil?
      array.push(actor_id)
    end
    @actors = array
  end
  
end # Game_Party

#==============================================================================
# ■ Game_Interpreter
#==============================================================================

class Game_Interpreter
  
  #--------------------------------------------------------------------------
  # new method: lock_actor
  #--------------------------------------------------------------------------
  def lock_actor(actor_id)
    return unless YEA::PARTY::ENABLE_MENU
    actor = $game_actors[actor_id]
    return unless $game_party.battle_members.include?(actor.id)
    actor.locked = true
  end
  
  #--------------------------------------------------------------------------
  # new method: unlock_actor
  #--------------------------------------------------------------------------
  def unlock_actor(actor_id)
    return unless YEA::PARTY::ENABLE_MENU
    actor = $game_actors[actor_id]
    return unless $game_party.battle_members.include?(actor.id)
    actor.locked = false
  end
  
  #--------------------------------------------------------------------------
  # new method: require_actor
  #--------------------------------------------------------------------------
  def require_actor(actor_id)
    return unless YEA::PARTY::ENABLE_MENU
    return if $game_system.formation_disabled
    actor = $game_actors[actor_id]
    return unless $game_party.all_members.include?(actor)
    actor.required = true
    call_party_menu unless $game_party.battle_members.include?(actor)
  end
  
  #--------------------------------------------------------------------------
  # new method: unrequire_actor
  #--------------------------------------------------------------------------
  def unrequire_actor(actor_id)
    return unless YEA::PARTY::ENABLE_MENU
    return if $game_system.formation_disabled
    actor = $game_actors[actor_id]
    return unless $game_party.all_members.include?(actor)
    actor.required = false
    call_party_menu unless $game_party.battle_members.include?(actor)
  end
  
  #--------------------------------------------------------------------------
  # new method: call_party_menu
  #--------------------------------------------------------------------------
  def call_party_menu
    return unless YEA::PARTY::ENABLE_MENU
    return if $game_system.formation_disabled
    SceneManager.call(Scene_Party)
  end
  
end # Game_Interpreter

#==============================================================================
# ■ Spriteset_Battle
#==============================================================================

class Spriteset_Battle
  
  #--------------------------------------------------------------------------
  # overwrite method: create_actors
  #--------------------------------------------------------------------------
  def create_actors
    total = $game_party.max_battle_members
    @actor_sprites = Array.new(total) { Sprite_Battler.new(@viewport1) }
  end
  
end # Spriteset_Battle

#==============================================================================
# ■ Window_PartyMenuCommand
#==============================================================================

class Window_PartyMenuCommand < Window_Command
  
  #--------------------------------------------------------------------------
  # window_width
  #--------------------------------------------------------------------------
  def window_width; return 160; end
  
  #--------------------------------------------------------------------------
  # visible_line_number
  #--------------------------------------------------------------------------
  def visible_line_number; 4; end
  
  #--------------------------------------------------------------------------
  # alignment
  #--------------------------------------------------------------------------
  def alignment
    return Menu.command_window_align if $imported["YEA-AceMenuEngine"]
    return YEA::PARTY::COMMAND_ALIGN
  end
  
  #--------------------------------------------------------------------------
  # scene
  #--------------------------------------------------------------------------
  def scene; return SceneManager.scene; end
  
  #--------------------------------------------------------------------------
  # make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    for command in YEA::PARTY::COMMANDS
      case command[0]
      when :change, :remove, :revert
        add_command(command[1], command[0])
      when :finish
        add_command(command[1], command[0], enable_cancel?)
      else; next
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # process_cancel
  #--------------------------------------------------------------------------
  def process_cancel
    unless enable_cancel?
      Sound.play_buzzer
      return
    end
    super
  end
  
  #--------------------------------------------------------------------------
  # in_party?
  #--------------------------------------------------------------------------
  def in_party?(actor)
    return $game_party.battle_members.include?(actor)
  end
  
  #--------------------------------------------------------------------------
  # enable_cancel?
  #--------------------------------------------------------------------------
  def enable_cancel?
    return false if $game_party.battle_members.size <= 0
    for actor in $game_party.all_members
      next if in_party?(actor)
      return false if actor.required
      return false if actor.locked
    end
    return true
  end
  
end # Window_PartyMenuCommand

#==============================================================================
# ■ Window_PartySelect
#==============================================================================

class Window_PartySelect < Window_Selectable
  
  #--------------------------------------------------------------------------
  # initialize
  #-------------------------------------------------------------------------
  def initialize(command_window)
    @command_window = command_window
    super(160, 0, window_width, fitting_height(visible_line_number))
    select(0)
    deactivate
    refresh
  end
  
  #--------------------------------------------------------------------------
  # col_max
  #--------------------------------------------------------------------------
  def col_max; return $game_party.max_battle_members; end
  
  #--------------------------------------------------------------------------
  # item_max
  #--------------------------------------------------------------------------
  def item_max; return $game_party.max_battle_members; end
  
  #--------------------------------------------------------------------------
  # window_width
  #--------------------------------------------------------------------------
  def window_width; return Graphics.width - 160; end
  
  #--------------------------------------------------------------------------
  # visible_line_number
  #--------------------------------------------------------------------------
  def visible_line_number; 4; end
  
  #--------------------------------------------------------------------------
  # item_rect
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new
    rect.width = contents.width / item_max
    rect.height = contents.height
    rect.x = index * rect.width
    rect.y = 0
    return rect
  end
  
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
  
  #--------------------------------------------------------------------------
  # make_item_list
  #--------------------------------------------------------------------------
  def make_item_list
    @data = $game_party.battle_members_array.clone
  end
  
  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    actor = $game_actors[@data[index]]
    rect = item_rect(index)
    if actor.nil?
      draw_empty(rect.clone)
      return
    end
    dx = rect.width / 2
    dy = rect.height - 16
    draw_actor_face(actor, rect.x, rect.y) if display_face?
    draw_actor_graphic(actor, rect.x + dx, rect.y + dy) unless display_face?
    draw_actor_name(actor, rect)
    draw_locked_icon(actor, rect)
    draw_required_icon(actor, rect)
  end
  
  #--------------------------------------------------------------------------
  # display_face?
  #--------------------------------------------------------------------------
  def display_face?
    return YEA::PARTY::DISPLAY_FACE
  end
  
  #--------------------------------------------------------------------------
  # draw_empty
  #--------------------------------------------------------------------------
  def draw_empty(rect)
    colour = Color.new(0, 0, 0, translucent_alpha/2)
    rect.x += 2
    rect.y += 2
    rect.width -= 4
    rect.height -= 4
    contents.fill_rect(rect, colour)
    reset_font_settings
    change_color(system_color)
    text = YEA::PARTY::EMPTY_TEXT
    draw_text(rect, text, 1)
    reset_font_settings
  end
  
  #--------------------------------------------------------------------------
  # draw_actor_name
  #--------------------------------------------------------------------------
  def draw_actor_name(actor, rect)
    contents.font.size = YEA::PARTY::PARTY_FONT_SIZE
    change_color(normal_color, actor.exist?)
    draw_text(rect.x+4, rect.y, rect.width-8, line_height, actor.name, 1)
  end
  
  #--------------------------------------------------------------------------
  # draw_face
  #--------------------------------------------------------------------------
  def draw_face(face_name, face_index, dx, dy, enabled = true)
    bitmap = Cache.face(face_name)
    dw = [96, item_rect(0).width-4].min
    rect = Rect.new(face_index % 4 * 96, face_index / 4 * 96, dw, 92)
    contents.blt(dx+2, dy+2, bitmap, rect, enabled ? 255 : translucent_alpha)
    bitmap.dispose
  end
  
  #--------------------------------------------------------------------------
  # draw_locked_icon
  #--------------------------------------------------------------------------
  def draw_locked_icon(actor, rect)
    return unless actor_locked?(actor)
    draw_icon(Icon.locked_party, rect.x+rect.width-26, rect.height - 26)
  end
  
  #--------------------------------------------------------------------------
  # draw_required_icon
  #--------------------------------------------------------------------------
  def draw_required_icon(actor, rect)
    return if actor_locked?(actor)
    return unless actor_required?(actor)
    draw_icon(Icon.required_party, rect.x+rect.width-26, rect.height - 26)
  end
  
  #--------------------------------------------------------------------------
  # actor_locked?
  #--------------------------------------------------------------------------
  def actor_locked?(actor); return actor.locked; end
  
  #--------------------------------------------------------------------------
  # actor_required?
  #--------------------------------------------------------------------------
  def actor_required?(actor)
    return false if actor.locked
    return actor.required
  end
  
  #--------------------------------------------------------------------------
  # current_item_enabled?
  #--------------------------------------------------------------------------
  def current_item_enabled?; enable?(@data[index]); end
  
  #--------------------------------------------------------------------------
  # enable?
  #--------------------------------------------------------------------------
  def enable?(item)
    case @command_window.current_symbol
    when :change
      return true if item.nil?
      return true if item == 0
    when :remove
      return false if item.nil?
      return false if item == 0
    end
    actor = $game_actors[item]
    return false if actor.locked
    return false if actor.required
    return true
  end
  
  #--------------------------------------------------------------------------
  # process_handling
  #--------------------------------------------------------------------------
  def process_handling
    return unless open? && active
    return process_ok       if ok_enabled?        && Input.trigger?(:C)
    return process_cancel   if cancel_enabled?    && Input.trigger?(:B)
    return process_pagedown if handle?(:pagedown) && Input.repeat?(:R)
    return process_pageup   if handle?(:pageup)   && Input.repeat?(:L)
  end
  
  #--------------------------------------------------------------------------
  # cur_actor
  #--------------------------------------------------------------------------
  def cur_actor
    actor_id = @data[index]
    return $game_actors[actor_id]
  end
  
  #--------------------------------------------------------------------------
  # prev_actor
  #--------------------------------------------------------------------------
  def prev_actor
    id = index == 0 ? @data.size - 1 : index - 1
    actor_id = @data[id]
    return $game_actors[actor_id]
  end
  
  #--------------------------------------------------------------------------
  # next_actor
  #--------------------------------------------------------------------------
  def next_actor
    id = index == @data.size - 1 ? 0 : index + 1
    actor_id = @data[id]
    return $game_actors[actor_id]
  end
  
  #--------------------------------------------------------------------------
  # process_pageup
  #--------------------------------------------------------------------------
  def process_pageup
    allow = true
    allow = false if !prev_actor.nil? && prev_actor.locked
    allow = false if !cur_actor.nil? && cur_actor.locked
    Sound.play_buzzer unless allow
    if allow
      super
      activate
      select(index == 0 ? @data.size - 1 : index - 1)
    end
  end
  
  #--------------------------------------------------------------------------
  # process_pagedown
  #--------------------------------------------------------------------------
  def process_pagedown
    allow = true
    allow = false if !next_actor.nil? && next_actor.locked
    allow = false if !cur_actor.nil? && cur_actor.locked
    Sound.play_buzzer unless allow
    if allow
      super
      activate
      select(index == @data.size - 1 ? 0 : index + 1)
    end
  end
  
  #--------------------------------------------------------------------------
  # item
  #--------------------------------------------------------------------------
  def item; return @data[index]; end
  
end # Window_PartySelect

#==============================================================================
# ■ Window_PartyList
#==============================================================================

class Window_PartyList < Window_Selectable
  
  #--------------------------------------------------------------------------
  # initialize
  #-------------------------------------------------------------------------
  def initialize(party_window)
    super(0, fitting_height(4), window_width, window_height)
    @party_window = party_window
    select(1)
    deactivate
    refresh
  end
  
  #--------------------------------------------------------------------------
  # window_width
  #--------------------------------------------------------------------------
  def window_width; return 200; end
  
  #--------------------------------------------------------------------------
  # window_height
  #--------------------------------------------------------------------------
  def window_height; return Graphics.height - fitting_height(4); end
  
  #--------------------------------------------------------------------------
  # item_max
  #--------------------------------------------------------------------------
  def item_max; return @data ? @data.size : 1; end
  
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
  
  #--------------------------------------------------------------------------
  # make_item_list
  #--------------------------------------------------------------------------
  def make_item_list
    @data = [0]
    for member in $game_party.all_members
      next if member.nil?
      @data.push(member.id)
    end
    @data.push(0)
  end
  
  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    clear_item(index)
    rect = item_rect(index)
    if @data[index] == 0
      draw_remove(rect)
      return
    end
    actor = $game_actors[@data[index]]
    draw_actor(actor, rect)
    draw_actor_locked(actor, rect)
    draw_actor_required(actor, rect)
  end
  
  #--------------------------------------------------------------------------
  # draw_remove
  #--------------------------------------------------------------------------
  def draw_remove(rect)
    reset_font_settings
    draw_icon(Icon.remove_party, rect.x+4, rect.y)
    text = YEA::PARTY::REMOVE_TEXT
    draw_text(rect.x+32, rect.y, rect.width-32, line_height, text)
  end
  
  #--------------------------------------------------------------------------
  # draw_actor
  #--------------------------------------------------------------------------
  def draw_actor(actor, rect)
    buffer = YEA::PARTY::ACTOR_Y_BUFFER
    draw_actor_graphic(actor, rect.x + 16, rect.y + rect.height + buffer)
    text = actor.name
    change_color(list_colour(actor), enabled?(actor))
    draw_text(rect.x+32, rect.y, rect.width-32, line_height, text)
  end
  
  #--------------------------------------------------------------------------
  # list_colour
  #--------------------------------------------------------------------------
  def list_colour(actor)
    return text_color(YEA::PARTY::IN_PARTY_COLOUR) if in_party?(actor)
    return normal_color
  end
  
  #--------------------------------------------------------------------------
  # draw_actor_locked
  #--------------------------------------------------------------------------
  def draw_actor_locked(actor, rect)
    return unless actor.locked
    draw_icon(Icon.locked_party, rect.width-24, rect.y)
  end
  
  #--------------------------------------------------------------------------
  # draw_actor_required
  #--------------------------------------------------------------------------
  def draw_actor_required(actor, rect)
    return if actor.locked
    return unless actor.required
    draw_icon(Icon.required_party, rect.width-24, rect.y)
  end
  
  #--------------------------------------------------------------------------
  # enabled?
  #--------------------------------------------------------------------------
  def enabled?(actor)
    return false if actor.locked
    return false if actor.required && in_party?(actor)
    return actor.exist?
  end
  
  #--------------------------------------------------------------------------
  # in_party?
  #--------------------------------------------------------------------------
  def in_party?(actor); return $game_party.battle_members.include?(actor); end
  
  #--------------------------------------------------------------------------
  # current_item_enabled?
  #--------------------------------------------------------------------------
  def current_item_enabled?
    actor = $game_actors[item]
    replace = $game_actors[@party_window.item]
    unless actor.nil?
      return false if actor.locked && in_party?(actor)
      return false if actor.required && in_party?(actor)
    end
    return true if replace.nil?
    return false if replace.locked
    return false if replace.required
    return true if actor.nil?
    return actor.exist?
  end
  
  #--------------------------------------------------------------------------
  # item
  #--------------------------------------------------------------------------
  def item; return @data[index]; end
  
end # Window_PartyList

#==============================================================================
# ** Window_PartyStatus
#==============================================================================

class Window_PartyStatus < Window_Base
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(party_window, list_window)
    super(200, fitting_height(4), window_width, window_height)
    @party_window = party_window
    @list_window = list_window
    @actor = active_actor
    refresh
  end
  
  #--------------------------------------------------------------------------
  # window_width
  #--------------------------------------------------------------------------
  def window_width; Graphics.width - 200; end
  
  #--------------------------------------------------------------------------
  # window_height
  #--------------------------------------------------------------------------
  def window_height; Graphics.height - fitting_height(4); end
  
  #--------------------------------------------------------------------------
  # update
  #--------------------------------------------------------------------------
  def update
    super
    refresh if @actor != active_actor
  end
  
  #--------------------------------------------------------------------------
  # active_actor
  #--------------------------------------------------------------------------
  def active_actor
    if @list_window.active
      actor = @list_window.item
    else
      actor = @party_window.item
    end
    return nil if [0, nil].include?(actor)
    return actor
  end
  
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    @actor = active_actor
    reset_font_settings
    if @actor.nil?
      draw_nil_actor
      return
    end
    actor = $game_actors[@actor]
    draw_actor_face(actor, 0, 0)
    draw_actor_name(actor, 108, 0)
    draw_actor_class(actor, 228, 0, contents.width-232)
    draw_actor_level(actor, 108, line_height)
    draw_actor_icons(actor, 228, line_height, contents.width-232)
    draw_actor_hp(actor, 108, line_height*2, contents.width-112)
    draw_actor_mp(actor, 108, line_height*3, contents.width-112)
    draw_actor_parameters(actor, 0, line_height*4 + line_height/2)
    draw_equipments(actor, contents.width/2, line_height*4 + line_height/2)
  end
  
  #--------------------------------------------------------------------------
  # draw_nil_actor
  #--------------------------------------------------------------------------
  def draw_nil_actor
    colour = Color.new(0, 0, 0, translucent_alpha/2)
    rect = Rect.new(0, 0, contents.width, contents.height)
    contents.fill_rect(rect, colour)
    change_color(system_color)
    text = YEA::PARTY::NO_DATA
    draw_text(rect, text, 1)
  end
  
  #--------------------------------------------------------------------------
  # draw_actor_parameters
  #--------------------------------------------------------------------------
  def draw_actor_parameters(actor, dx, dy)
    dw = contents.width/2 - 4
    rect = Rect.new(dx+1, dy+1, dw - 2, line_height - 2)
    contents.font.size = YEA::PARTY::STAT_FONT_SIZE
    colour = Color.new(0, 0, 0, translucent_alpha/2)
    array = [:atk, :def, :mat, :mdf, :agi, :luk]
    cx = 4
    for stat in array
      case stat
      when :atk
        param = Vocab::param(2)
        value = actor.atk.group
      when :def
        param = Vocab::param(3)
        value = actor.def.group
      when :mat
        param = Vocab::param(4)
        value = actor.mat.group
      when :mdf
        param = Vocab::param(5)
        value = actor.mdf.group
      when :agi
        param = Vocab::param(6)
        value = actor.agi.group
      when :luk
        param = Vocab::param(7)
        value = actor.luk.group
      else; next
      end
      contents.fill_rect(rect, colour)
      change_color(system_color)
      draw_text(rect.x + cx, rect.y, rect.width-cx*2, line_height, param, 0)
      change_color(normal_color)
      draw_text(rect.x + cx, rect.y, rect.width-cx*2, line_height, value, 2)
      rect.y += line_height
    end
    reset_font_settings
  end
  
  #--------------------------------------------------------------------------
  # draw_equipments
  #--------------------------------------------------------------------------
  def draw_equipments(actor, dx, dy)
    text = YEA::PARTY::EQUIP_TEXT
    change_color(system_color)
    draw_text(dx, dy, contents.width - dx, line_height, text, 1)
    dy += line_height
    if actor.equips.size <= 5
      actor.equips.each_with_index do |item, i|
        draw_item_name(item, dx, dy + line_height * i)
      end
    else
      orig_x = dx
      actor.equips.each_with_index do |item, i|
        next if item.nil?
        draw_icon(item.icon_index, dx, dy)
        dy += line_height if dx + 48 > contents.width
        dx = dx + 48 > contents.width ? orig_x : dx + 24
      end
    end
  end
  
end # Window_PartyStatus

#==============================================================================
# ■ Scene_Menu
#==============================================================================

class Scene_Menu < Scene_MenuBase
  
  #--------------------------------------------------------------------------
  # overwrite method: command_formation
  #--------------------------------------------------------------------------
  if YEA::PARTY::ENABLE_MENU
  def command_formation
    SceneManager.call(Scene_Party)
  end
  end # YEA::PARTY::ENABLE_MENU
  
end # Scene_Menu

#==============================================================================
# ■ Scene_Party
#==============================================================================

class Scene_Party < Scene_MenuBase
  
  #--------------------------------------------------------------------------
  # start
  #--------------------------------------------------------------------------
  def start
    super
    @former_party = $game_party.battle_members_array.clone
    create_command_window
    create_party_window
    create_list_window
    create_status_window
  end
  
  #--------------------------------------------------------------------------
  # create_command_window
  #--------------------------------------------------------------------------
  def create_command_window
    @command_window = Window_PartyMenuCommand.new(0, 0)
    @command_window.set_handler(:change, method(:adjust_members))
    @command_window.set_handler(:remove, method(:adjust_members))
    @command_window.set_handler(:revert, method(:revert_party))
    @command_window.set_handler(:finish, method(:return_scene))
    @command_window.set_handler(:cancel, method(:return_scene))
  end
  
  #--------------------------------------------------------------------------
  # create_party_window
  #--------------------------------------------------------------------------
  def create_party_window
    @party_window = Window_PartySelect.new(@command_window)
    @party_window.set_handler(:ok,       method(:on_party_ok))
    @party_window.set_handler(:cancel,   method(:on_party_cancel))
    @party_window.set_handler(:pageup,   method(:on_party_pageup))
    @party_window.set_handler(:pagedown, method(:on_party_pagedown))
  end
  
  #--------------------------------------------------------------------------
  # create_list_window
  #--------------------------------------------------------------------------
  def create_list_window
    @list_window = Window_PartyList.new(@party_window)
    @list_window.set_handler(:ok,     method(:on_list_ok))
    @list_window.set_handler(:cancel, method(:on_list_cancel))
  end
  
  #--------------------------------------------------------------------------
  # create_status_window
  #--------------------------------------------------------------------------
  def create_status_window
    @status_window = Window_PartyStatus.new(@party_window, @list_window)
  end
  
  #--------------------------------------------------------------------------
  # adjust_members
  #--------------------------------------------------------------------------
  def adjust_members
    @party_window.activate
  end
  
  #--------------------------------------------------------------------------
  # window_refresh
  #--------------------------------------------------------------------------
  def window_refresh
    $game_party.rearrange_actors
    @command_window.refresh
    @party_window.refresh
    @list_window.refresh
    $game_player.refresh
    $game_map.need_refresh = true
  end
  
  #--------------------------------------------------------------------------
  # revert_party
  #--------------------------------------------------------------------------
  def revert_party
    @command_window.activate
    $game_party.battle_members_array = @former_party.clone
    window_refresh
  end
  
  #--------------------------------------------------------------------------
  # on_party_ok
  #--------------------------------------------------------------------------
  def on_party_ok
    case @command_window.current_symbol
    when :change
      @list_window.activate
    when :remove
      index = @party_window.index
      actor = $game_actors[$game_party.battle_members_array[index]]
      Sound.play_equip
      $game_party.battle_members_array[index] = 0
      window_refresh
      @party_window.activate
    end
  end
  
  #--------------------------------------------------------------------------
  # on_party_cancel
  #--------------------------------------------------------------------------
  def on_party_cancel
    @command_window.activate
  end
  
  #--------------------------------------------------------------------------
  # on_party_pageup
  #--------------------------------------------------------------------------
  def on_party_pageup
    Sound.play_equip
    actor_id1 = @party_window.item
    actor_id2 = @party_window.prev_actor.nil? ? 0 : @party_window.prev_actor.id
    max = @party_window.item_max-1
    index1 = @party_window.index
    index2 = @party_window.index == 0 ? max : index1-1
    $game_party.battle_members_array[index1] = actor_id2
    $game_party.battle_members_array[index2] = actor_id1
    window_refresh
  end
  
  #--------------------------------------------------------------------------
  # on_party_pagedown
  #--------------------------------------------------------------------------
  def on_party_pagedown
    Sound.play_equip
    actor_id1 = @party_window.item
    actor_id2 = @party_window.next_actor.nil? ? 0 : @party_window.next_actor.id
    max = @party_window.item_max-1
    index1 = @party_window.index
    index2 = @party_window.index == max ? 0 : index1+1
    $game_party.battle_members_array[index1] = actor_id2
    $game_party.battle_members_array[index2] = actor_id1
    window_refresh
  end
  
  #--------------------------------------------------------------------------
  # on_list_cancel
  #--------------------------------------------------------------------------
  def on_list_cancel
    @party_window.activate
  end
  
  #--------------------------------------------------------------------------
  # on_list_ok
  #--------------------------------------------------------------------------
  def on_list_ok
    Sound.play_equip
    replace = $game_actors[@party_window.item]
    actor = $game_actors[@list_window.item]
    index1 = @party_window.index
    actor_id1 = actor.nil? ? 0 : actor.id
    if actor.nil?
      $game_party.battle_members_array[index1] = 0
      window_refresh
      @party_window.activate
      return
    end
    actor_id2 = replace.nil? ? 0 : replace.id
    if $game_party.battle_members_array.include?(actor_id1)
      index2 = $game_party.battle_members_array.index(actor_id1)
      $game_party.battle_members_array[index2] = actor_id2
    end
    $game_party.battle_members_array[index1] = actor_id1
    window_refresh
    @party_window.activate
  end
  
end # Scene_Party

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================