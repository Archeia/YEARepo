#==============================================================================
# 
# ▼ Yanfly Engine Ace - Enemy Target Info v1.02
# -- Last Updated: 2012.01.01
# -- Level: Normal
# -- Requires: YEA - Ace Battle Engine v1.10+.
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-EnemyTargetInfo"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.01 - Bug Fixed: <scan info: all> didn't work properly.
# 2011.12.30 - Bug Fixed: Crash when using Ace Battle Engine's F8 debug.
# 2011.12.29 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# The enemy target info window can be activated in battle to show enemy data
# at the bottom of the screen. Information can be revealed straight from the
# start or requires the player to actively reveal the information on their own
# through either defeating the enemies, using skills on them, or scanning them
# in various ways produced by the script.
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
# <scan info: all>
# This will scan the target enemy of all properties that are shown in the
# comparison windows. Unless the enemy has a permanent hide tag, all of the
# data becomes available.
# 
# <scan info: parameters>
# This will scan the target enemy's parameters and reveal them to the player
# unless the enemy has a permanent hide tag.
# 
# <scan info: elements>
# This will scan the target enemy's elemental resistances and reveal them to
# the player unless the enemy has a permanent hide tag.
# 
# <scan info: states>
# This will scan the target enemy's state resistances and reveal them to the
# player unless the enemy has a permanent hide tag.
# 
# <scan element: x>
# <scan element: x, x>
# This will scan the target enemy's elemental resistance for element x. Insert
# multiple of these tags to scan more elements. If you have the automatic scan
# element setting on in the module, all skills and items will automatically
# scan whatever element the skill or item deals damage with innately.
# 
# <scan state: x>
# <scan state: x, x>
# This will scan the target enemy's state resistance for element x. Insert
# multiple of these tags to scan more states. If you have the automatic scan
# state setting on in the module, all skills and items will automatically
# scan whatever state the skill or item inflicts innately.
# 
# -----------------------------------------------------------------------------
# Item Notetags - These notetags go in the item notebox in the database.
# -----------------------------------------------------------------------------
# <scan info: all>
# This will scan the target enemy of all properties that are shown in the
# comparison windows. Unless the enemy has a permanent hide tag, all of the
# data becomes available.
# 
# <scan info: parameters>
# This will scan the target enemy's parameters and reveal them to the player
# unless the enemy has a permanent hide tag.
# 
# <scan info: elements>
# This will scan the target enemy's elemental resistances and reveal them to
# the player unless the enemy has a permanent hide tag.
# 
# <scan info: states>
# This will scan the target enemy's state resistances and reveal them to the
# player unless the enemy has a permanent hide tag.
# 
# <scan element: x>
# <scan element: x, x>
# This will scan the target enemy's elemental resistance for element x. Insert
# multiple of these tags to scan more elements. If you have the automatic scan
# element setting on in the module, all skills and items will automatically
# scan whatever element the skill or item deals damage with innately.
# 
# <scan state: x>
# <scan state: x, x>
# This will scan the target enemy's state resistance for element x. Insert
# multiple of these tags to scan more states. If you have the automatic scan
# state setting on in the module, all skills and items will automatically
# scan whatever state the skill or item inflicts innately.
# 
# -----------------------------------------------------------------------------
# Enemy Notetags - These notetags go in the enemies notebox in the database.
# -----------------------------------------------------------------------------
# <hide info: all>
# <show info: all>
# These notetags will set the enemy to either always hide all of their battle
# information or to always show all of their info. The tags will override
# each other if both are used simultaneously.
# 
# <hide info: parameters>
# <show info: parameters>
# These notetags will set the enemy to either always hide their parameter
# information or to always show their parameter info. The tags will override
# each other if both are used simultaneously.
# 
# <hide info: elements>
# <show info: elements>
# These notetags will set the enemy to either always hide their element
# information or to always show their element info. The tags will override
# each other if both are used simultaneously.
# 
# <hide info: states>
# <show info: states>
# These notetags will set the enemy to either always hide their state
# information or to always show their state info. The tags will override
# each other if both are used simultaneously.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
# This script requires Yanfly Engine Ace - Ace Battle Engine v1.10+ and the
# script must be placed under Ace Battle Engine in the script listing.
# 
#==============================================================================

module YEA
  module ENEMY_INFO
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Info Window Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These are the general settings revolving around the info windows shown in
    # battle such as the sound effect played, the button used to open up the
    # menus, the page orders, and the info text.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    INFO_SFX = RPG::SE.new("Book2", 80, 150) # SFX played for Info Window.
    
    # Button used to toggle the Info Window. Keep in mind that L and R are
    # used for moving between pages so it's best to not use those.
    INFO_BUTTON = :SHIFT
    
    # This sets the page order in which data is displayed for the player. The
    # player can switch pages by pressing L or R.
    PAGE_ORDER =[
      :parameters,
      :elements,
      :states,
    ] # Do not remove this.
    
    # If testplay is being used, reveal all battle information for non-hidden
    # enemy information?
    SHOW_DEBUG_ALL = true
    
    # The follow adjusts the settings regarding the help window. If this
    # setting is on, the the help info will be displayed.
    SHOW_HELP_INFO = true
    HELP_WINDOW_Y  = 72    # Y location of the help window.
    
    # This is the text displayed to let the player know how to activate and
    # show the info windows.
    HELP_INFO_SHOW = "\e}Press \eC[4]SHIFT\eC[0] to show target info."
    
    # This is the text displayed to let the player know how to switch between
    # pages for the info windows.
    HELP_INFO_SWITCH = "\e}Press \eC[4]L\eC[0] or \eC[4]R\eC[0] to switch info."
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - General Page Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # The general page shows the stats of the battlers. The player can compare
    # and contrast the stats of both battlers relative to each other. The
    # settings here adjust the font size, the text displayed if parameters are
    # hidden, and whether or not to show parameters by default?
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    PARAM_FONT_SIZE     = 20       # Font size used for parameters.
    HIDDEN_PARAM_TEXT   = "???"    # Text used if parameters are hidden.
    
    # Show the parameters by default? If false, the enemy must be defeated once
    # or scanned to show the those parameters.
    DEFAULT_SHOW_PARAMS = false
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Element Page Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # The elements page shows the elemental resistances of the battlers. The
    # player can compare and contrast the resistances relative to each other.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    ELE_FONT_SIZE   = 20       # Font size used for element resistances.
    HIDDEN_ELE_TEXT = "???"    # Text used if element resistances are hidden.
    SHOWN_ELEMENTS  = [3..10]  # Elements shown. Maximum of 8 can be shown.
    ELEMENT_ICONS   ={         # Contains element icon information.
    # Element ID => Icon,
               3 =>  96, # Fire
               4 =>  97, # Ice
               5 =>  98, # Thunder
               6 =>  99, # Water
               7 => 100, # Earth
               8 => 101, # Wind
               9 => 102, # Holy
              10 => 103, # Dark
    } # Do not remove this.
    
    # Show the elemental resistances by default? If false, a skill with the
    # specific element must be used on the enemy to reveal the element data if
    # the AUTO_SCAN_ELEMENT setting is set to true.
    DEFAULT_SHOW_ELEMENTS = false
    
    # If this is set to true, then skills with elemental properties will
    # automatically scan the specific elemental resistance of that enemy type
    # when used against that enemy.
    AUTO_SCAN_ELEMENT = true
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - States Page Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # The states page shows the state resistances of the battlers. The player
    # can compare and contrast the resistances relative to each other.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    STATE_FONT_SIZE   = 20     # Font size used for state resistances.
    HIDDEN_STATE_TEXT = "???"  # Text used if state resistances are hidden.
    SHOWN_STATES = [7..14]     # States shown. Maximum of 8 can be shown.
    
    # Show the state resistances by default? If false, a skill with the
    # specific state must be used on the enemy to reveal the element data if
    # the AUTO_SCAN_STATES setting is set to true.
    DEFAULT_SHOW_STATES = false
    
    # If this is set to true, then skills with state applying properties will
    # automatically scan the specific state resistance of that enemy type
    # when used against that enemy.
    AUTO_SCAN_STATES = true
    
  end # ENEMY_INFO
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

if $imported["YEA-BattleEngine"]

module YEA
  module ENEMY_INFO
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
    # converted_contants
    #--------------------------------------------------------------------------
    SHOWN_ELEMENTS = convert_integer_array(SHOWN_ELEMENTS)
    SHOWN_STATES = convert_integer_array(SHOWN_STATES)
  end # ENEMY_INFO
  module REGEXP
  module ENEMY
    
    HIDE_INFO = /<(?:HIDE_INFO|hide info):[ ](.*)>/i
    SHOW_INFO = /<(?:SHOW_INFO|show info):[ ](.*)>/i
    
  end # ENEMY
  module USABLEITEM
    
    SCAN_INFO = /<(?:SCAN_INFO|scan info):[ ](.*)>/i
    SCAN_ELE = /<(?:SCAN_ELE|scan ele|scan element):[ ]*(\d+(?:\s*,\s*\d+)*)>/i
    SCAN_STATE = /<(?:SCAN_STATE|scan state):[ ]*(\d+(?:\s*,\s*\d+)*)>/i
    
  end # USABLEITEM
  end # REGEXP
end # YEA

#==============================================================================
# ■ Icon
#==============================================================================

module Icon
  
  #--------------------------------------------------------------------------
  # self.element
  #--------------------------------------------------------------------------
  def self.element(id)
    return 0 unless YEA::ENEMY_INFO::ELEMENT_ICONS.include?(id)
    return YEA::ENEMY_INFO::ELEMENT_ICONS[id]
  end
    
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
  class <<self; alias load_database_etin load_database; end
  def self.load_database
    load_database_etin
    load_notetags_etin
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_etin
  #--------------------------------------------------------------------------
  def self.load_notetags_etin
    groups = [$data_enemies, $data_skills, $data_items]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_etin
      end
    end
  end
  
end # DataManager

#==============================================================================
# ■ RPG::Enemy
#==============================================================================

class RPG::Enemy < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :hide_info
  attr_accessor :show_info
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_etin
  #--------------------------------------------------------------------------
  def load_notetags_etin
    @hide_info = []
    @show_info = []
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::ENEMY::HIDE_INFO
        case $1.upcase
        when "PARAM", "PARAMETER", "PARAMETERS"
          @hide_info.push(:param)
          @show_info.delete(:param)
        when "ELE", "ELEMENT", "ELEMENTS"
          @hide_info.push(:ele)
          @show_info.delete(:ele)
        when "STATE", "STATES"
          @hide_info.push(:state)
          @show_info.delete(:state)
        when "ALL"
          @hide_info.push(:all)
          @show_info.delete(:all)
        end
      #---
      when YEA::REGEXP::ENEMY::SHOW_INFO
        case $1.upcase
        when "PARAM", "PARAMETER", "PARAMETERS"
          @show_info.push(:param)
          @hide_info.delete(:param)
        when "ELE", "ELEMENT", "ELEMENTS"
          @show_info.push(:ele)
          @hide_info.delete(:ele)
        when "STATE", "STATES"
          @show_info.push(:state)
          @hide_info.delete(:state)
        when "ALL"
          @show_info.push(:all)
          @hide_info.delete(:all)
        end
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::Enemy

#==============================================================================
# ■ RPG::UsableItem
#==============================================================================

class RPG::UsableItem < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :scan_info
  attr_accessor :scan_ele
  attr_accessor :scan_state
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_etin
  #--------------------------------------------------------------------------
  def load_notetags_etin
    @scan_info = []
    @scan_ele = []
    @scan_state = []
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::USABLEITEM::SCAN_INFO
        case $1.upcase
        when "PARAM", "PARAMETER", "PARAMETERS"
          @scan_info.push(:param)
        when "ELE", "ELEMENT", "ELEMENTS"
          @scan_info.push(:ele)
        when "STATE", "STATES"
          @scan_info.push(:state)
        when "ALL"
          @scan_info.push(:all)
        end
      #---
      when YEA::REGEXP::USABLEITEM::SCAN_ELE
        $1.scan(/\d+/).each { |num| 
        @scan_ele.push(num.to_i) if num.to_i > 0 }
      when YEA::REGEXP::USABLEITEM::SCAN_STATE
        $1.scan(/\d+/).each { |num| 
        @scan_state.push(num.to_i) if num.to_i > 0 }
      #---
      end
    } # self.note.split
    #---
    @scan_ele.push(self.damage.element_id) if YEA::ENEMY_INFO::AUTO_SCAN_ELEMENT
    if YEA::ENEMY_INFO::AUTO_SCAN_STATES
      for effect in @effects
        next unless effect.code == 21
        next unless effect.data_id > 0
        @scan_state.push(effect.data_id)
      end
    end
  end
  
end # RPG::UsableItem

#==============================================================================
# ■ Game_System
#==============================================================================

class Game_System
  
  #--------------------------------------------------------------------------
  # alias method: initialize
  #--------------------------------------------------------------------------
  alias game_system_initialize_eti initialize
  def initialize
    game_system_initialize_eti
    initialize_enemy_info_data
  end
  
  #--------------------------------------------------------------------------
  # new method: initialize_enemy_info_data
  #--------------------------------------------------------------------------
  def initialize_enemy_info_data
    @param_enemies = [] if @param_enemies.nil?
    @ele_enemies = {} if @ele_enemies.nil?
    @state_enemies = {} if @state_enemies.nil?
  end
  
  #--------------------------------------------------------------------------
  # new method: info_param_enemies
  #--------------------------------------------------------------------------
  def info_param_enemies
    initialize_enemy_info_data if @param_enemies.nil?
    return @param_enemies
  end
  
  #--------------------------------------------------------------------------
  # new method: add_info_param_enemies
  #--------------------------------------------------------------------------
  def add_info_param_enemies(id)
    initialize_enemy_info_data if @param_enemies.nil?
    @param_enemies.push(id) unless @param_enemies.include?(id)
  end
  
  #--------------------------------------------------------------------------
  # new method: info_ele_enemies
  #--------------------------------------------------------------------------
  def info_ele_enemies(ele_id)
    initialize_enemy_info_data if @ele_enemies.nil?
    @ele_enemies[ele_id] = [] if @ele_enemies[ele_id].nil?
    return @ele_enemies[ele_id]
  end
  
  #--------------------------------------------------------------------------
  # new method: add_info_ele_enemies
  #--------------------------------------------------------------------------
  def add_info_ele_enemies(ele_id, id)
    initialize_enemy_info_data if @ele_enemies.nil?
    @ele_enemies[ele_id] = [] if @ele_enemies[ele_id].nil?
    @ele_enemies[ele_id].push(id) unless @ele_enemies[ele_id].include?(id)
  end
  
  #--------------------------------------------------------------------------
  # new method: info_state_enemies
  #--------------------------------------------------------------------------
  def info_state_enemies(state_id)
    initialize_enemy_info_data if @state_enemies.nil?
    @state_enemies[state_id] = [] if @state_enemies[state_id].nil?
    return @state_enemies[state_id]
  end
  
  #--------------------------------------------------------------------------
  # new method: add_info_state_enemies
  #--------------------------------------------------------------------------
  def add_info_state_enemies(state_id, id)
    initialize_enemy_info_data if @state_enemies.nil?
    @state_enemies[state_id] = [] if @state_enemies[state_id].nil?
    @state_enemies[state_id].push(id) if !@state_enemies[state_id].include?(id)
  end
  
end # Game_System

#==============================================================================
# ■ Game_BattlerBase
#==============================================================================

class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # new method: show_info_param?
  #--------------------------------------------------------------------------
  def show_info_param?
    return true if YEA::ENEMY_INFO::SHOW_DEBUG_ALL && ($TEST || $BTEST)
    return YEA::ENEMY_INFO::DEFAULT_SHOW_PARAMS
  end
  
  #--------------------------------------------------------------------------
  # new method: show_info_element?
  #--------------------------------------------------------------------------
  def show_info_element?(ele_id)
    return true if YEA::ENEMY_INFO::SHOW_DEBUG_ALL && ($TEST || $BTEST)
    return YEA::ENEMY_INFO::DEFAULT_SHOW_ELEMENTS
  end
  
  #--------------------------------------------------------------------------
  # new method: show_info_state?
  #--------------------------------------------------------------------------
  def show_info_state?(state_id)
    return true if YEA::ENEMY_INFO::SHOW_DEBUG_ALL && ($TEST || $BTEST)
    return YEA::ENEMY_INFO::DEFAULT_SHOW_STATES
  end
  
end # Game_BattlerBase

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias method: die
  #--------------------------------------------------------------------------
  alias game_battler_die_eti die
  def die
    game_battler_die_eti
    return if actor?
    $game_system.add_info_param_enemies(@enemy_id)
  end
  
  #--------------------------------------------------------------------------
  # alias method: item_user_effect
  #--------------------------------------------------------------------------
  alias game_battler_item_user_effect_eti item_user_effect
  def item_user_effect(user, item)
    game_battler_item_user_effect_eti(user, item)
    scan_enemy_info_effect(user, item)
  end
  
  #--------------------------------------------------------------------------
  # new method: scan_enemy_info_effect
  #--------------------------------------------------------------------------
  def scan_enemy_info_effect(user, item)
    return if self.actor?
    return unless user.actor?
    #---
    for info in item.scan_info
      case info
      when :all
        $game_system.add_info_param_enemies(@enemy_id)
        for i in 0...$data_system.elements.size
          $game_system.add_info_ele_enemies(i, @enemy_id)
        end
        for i in 0...$data_states.size
          $game_system.add_info_state_enemies(i, @enemy_id)
        end
      when :param
        $game_system.add_info_param_enemies(@enemy_id)
      when :ele
        for i in 0...$data_system.elements.size
          $game_system.add_info_ele_enemies(i, @enemy_id)
        end
      when :state
        for i in 0...$data_states.size
          $game_system.add_info_state_enemies(i, @enemy_id)
        end
      end
    end
    #---
    for ele_id in item.scan_ele
      $game_system.add_info_ele_enemies(ele_id, @enemy_id)
    end
    for state_id in item.scan_state
      $game_system.add_info_state_enemies(state_id, @enemy_id)
    end
  end
  
end # Game_Battler

#==============================================================================
# ■ Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  
  #--------------------------------------------------------------------------
  # new method: show_info_param?
  #--------------------------------------------------------------------------
  def show_info_param?
    return true
  end
  
  #--------------------------------------------------------------------------
  # new method: show_info_element?
  #--------------------------------------------------------------------------
  def show_info_element?(ele_id)
    return true
  end
  
  #--------------------------------------------------------------------------
  # new method: show_info_state?
  #--------------------------------------------------------------------------
  def show_info_state?(state_id)
    return true
  end
  
end # Game_Actor

#==============================================================================
# ■ Game_Enemy
#==============================================================================

class Game_Enemy < Game_Battler
  
  #--------------------------------------------------------------------------
  # new method: show_info_param?
  #--------------------------------------------------------------------------
  def show_info_param?
    return false if enemy.hide_info.include?(:param)
    return false if enemy.hide_info.include?(:all)
    return true if enemy.show_info.include?(:param)
    return true if enemy.show_info.include?(:all)
    return true if $game_system.info_param_enemies.include?(@enemy_id)
    return super
  end
  
  #--------------------------------------------------------------------------
  # new method: show_info_element?
  #--------------------------------------------------------------------------
  def show_info_element?(ele_id)
    return false if enemy.hide_info.include?(:ele)
    return false if enemy.hide_info.include?(:all)
    return true if enemy.show_info.include?(:ele)
    return true if enemy.show_info.include?(:all)
    return true if $game_system.info_ele_enemies(ele_id).include?(@enemy_id)
    return super(ele_id)
  end
  
  #--------------------------------------------------------------------------
  # new method: show_info_state?
  #--------------------------------------------------------------------------
  def show_info_state?(state_id)
    return false if enemy.hide_info.include?(:state)
    return false if enemy.hide_info.include?(:all)
    return true if enemy.show_info.include?(:state)
    return true if enemy.show_info.include?(:all)
    return true if $game_system.info_state_enemies(state_id).include?(@enemy_id)
    return super(state_id)
  end
  
end # Game_Enemy

#==============================================================================
# ■ Window_Comparison
#==============================================================================

class Window_Comparison < Window_Base
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(type)
    dx = type == :actor ? 0 : Graphics.width / 2
    dh = fitting_height(4)
    super(dx, Graphics.height - dh, Graphics.width / 2, dh)
    @button = YEA::ENEMY_INFO::INFO_BUTTON
    @battler = nil
    @type = type
    @page = 0
    hide
  end
  
  #--------------------------------------------------------------------------
  # update
  #--------------------------------------------------------------------------
  def update
    super
    return unless @type == :enemy
    process_enemy_window_input
    return unless self.visible
    reveal(SceneManager.scene.enemy_window.enemy)
  end
  
  #--------------------------------------------------------------------------
  # process_enemy_window_input
  #--------------------------------------------------------------------------
  def process_enemy_window_input
    return unless SceneManager.scene_is?(Scene_Battle)
    return unless SceneManager.scene.enemy_window.active
    return if SceneManager.scene.enemy_window.select_all?
    SceneManager.scene.toggle_enemy_info if Input.trigger?(@button)
    return unless self.visible
    SceneManager.scene.enemy_info_page_up if Input.trigger?(:L)
    SceneManager.scene.enemy_info_page_down if Input.trigger?(:R)
  end
  
  #--------------------------------------------------------------------------
  # reveal
  #--------------------------------------------------------------------------
  def reveal(battler)
    return if @battler == battler
    @battler = battler
    refresh
    show
  end
  
  #--------------------------------------------------------------------------
  # clear
  #--------------------------------------------------------------------------
  def clear
    @battler = nil
    @page = 0
    hide
  end
  
  #--------------------------------------------------------------------------
  # actor
  #--------------------------------------------------------------------------
  def actor; return BattleManager.actor; end
  
  #--------------------------------------------------------------------------
  # enemy
  #--------------------------------------------------------------------------
  def enemy; return SceneManager.scene.enemy_window.enemy; end
  
  #--------------------------------------------------------------------------
  # page_up
  #--------------------------------------------------------------------------
  def page_up
    @page = @page == 0 ? YEA::ENEMY_INFO::PAGE_ORDER.size - 1 : @page - 1
    refresh
  end
  
  #--------------------------------------------------------------------------
  # page_down
  #--------------------------------------------------------------------------
  def page_down
    @page = @page == YEA::ENEMY_INFO::PAGE_ORDER.size - 1 ? 0 : @page + 1
    refresh
  end
  
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    reset_font_settings
    draw_page(@page)
  end
  
  #--------------------------------------------------------------------------
  # draw_page
  #--------------------------------------------------------------------------
  def draw_page(page_id)
    return if @battler.nil?
    case YEA::ENEMY_INFO::PAGE_ORDER[page_id]
    when :parameters
      @battler = actor if @type == :actor
      draw_parameters
    when :elements
      @battler = enemy if @type == :actor
      draw_parameters if @type == :actor
      draw_elements if @type == :enemy
    when :states
      @battler = enemy if @type == :actor
      draw_parameters if @type == :actor
      draw_states if @type == :enemy
    end
  end
  
  #--------------------------------------------------------------------------
  # draw_parameters
  #--------------------------------------------------------------------------
  def draw_parameters
    draw_text(4, 0, contents.width, line_height, @battler.name)
    dx = contents.width / 2
    contents.font.size = YEA::ENEMY_INFO::PARAM_FONT_SIZE
    draw_param(2, 0, line_height*1); draw_param(3, dx, line_height*1)
    draw_param(4, 0, line_height*2); draw_param(5, dx, line_height*2)
    draw_param(6, 0, line_height*3); draw_param(7, dx, line_height*3)
  end
  
  #--------------------------------------------------------------------------
  # draw_param
  #--------------------------------------------------------------------------
  def draw_param(param_id, dx, dy)
    dw = contents.width / 2
    colour = Color.new(0, 0, 0, translucent_alpha/2)
    rect = Rect.new(dx+1, dy+1, dw - 2, line_height - 2)
    contents.fill_rect(rect, colour)
    #---
    change_color(system_color)
    draw_text(dx+4, dy, dw-8, line_height, Vocab::param(param_id))
    change_color(normal_color)
    if @battler.show_info_param?
      text = @battler.param(param_id).group
    else
      text = YEA::ENEMY_INFO::HIDDEN_PARAM_TEXT
    end
    draw_text(dx+4, dy, dw-8, line_height, text, 2)
  end
  
  #--------------------------------------------------------------------------
  # draw_elements
  #--------------------------------------------------------------------------
  def draw_elements
    dx = 0; dy = 0
    contents.font.size = YEA::ENEMY_INFO::ELE_FONT_SIZE
    for ele_id in YEA::ENEMY_INFO::SHOWN_ELEMENTS
      draw_element_info(ele_id, dx, dy)
      dx = dx == 0 ? contents.width / 2 : 0
      dy += dx == 0 ? line_height : 0
    end
  end
  
  #--------------------------------------------------------------------------
  # draw_element_info
  #--------------------------------------------------------------------------
  def draw_element_info(ele_id, dx, dy)
    dw = contents.width / 2
    colour = Color.new(0, 0, 0, translucent_alpha/2)
    rect = Rect.new(dx+1, dy+1, dw - 2, line_height - 2)
    contents.fill_rect(rect, colour)
    #---
    draw_icon(Icon.element(ele_id), dx, dy)
    change_color(system_color)
    draw_text(dx+24, dy, dw-24, line_height, $data_system.elements[ele_id])
    change_color(normal_color)
    if @battler.show_info_element?(ele_id)
      text = sprintf("%d%%", (@battler.element_rate(ele_id) * 100).to_i)
    else
      text = YEA::ENEMY_INFO::HIDDEN_ELE_TEXT
    end
    draw_text(dx+4, dy, dw-8, line_height, text, 2)
  end
  
  #--------------------------------------------------------------------------
  # draw_states
  #--------------------------------------------------------------------------
  def draw_states
    dx = 0; dy = 0
    contents.font.size = YEA::ENEMY_INFO::ELE_FONT_SIZE
    for state_id in YEA::ENEMY_INFO::SHOWN_STATES
      draw_state_info(state_id, dx, dy)
      dx = dx == 0 ? contents.width / 2 : 0
      dy += dx == 0 ? line_height : 0
    end
  end
  
  #--------------------------------------------------------------------------
  # draw_state_info
  #--------------------------------------------------------------------------
  def draw_state_info(state_id, dx, dy)
    dw = contents.width / 2
    colour = Color.new(0, 0, 0, translucent_alpha/2)
    rect = Rect.new(dx+1, dy+1, dw - 2, line_height - 2)
    contents.fill_rect(rect, colour)
    #---
    draw_icon($data_states[state_id].icon_index, dx, dy)
    change_color(system_color)
    draw_text(dx+24, dy, dw-24, line_height, $data_states[state_id].name)
    change_color(normal_color)
    if @battler.show_info_state?(state_id)
      text = sprintf("%d%%", (@battler.state_rate(state_id) * 100).to_i)
    else
      text = YEA::ENEMY_INFO::HIDDEN_STATE_TEXT
    end
    draw_text(dx+4, dy, dw-8, line_height, text, 2)
  end
  
end # Window_Comparison

#==============================================================================
# ■ Window_ComparisonHelp
#==============================================================================

class Window_ComparisonHelp < Window_Base
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(info_window)
    dy = YEA::ENEMY_INFO::HELP_WINDOW_Y
    super(-12, dy, Graphics.width + 24, fitting_height(1))
    @info_window = info_window
    self.opacity = 0
    self.z = 300
    @text = ""
    hide
  end
  
  #--------------------------------------------------------------------------
  # update
  #--------------------------------------------------------------------------
  def update
    super
    return unless YEA::ENEMY_INFO::SHOW_HELP_INFO
    update_visibility
    update_text
  end
  
  #--------------------------------------------------------------------------
  # update_visibility
  #--------------------------------------------------------------------------
  def update_visibility
    return unless SceneManager.scene_is?(Scene_Battle)
    return if SceneManager.scene.enemy_window.select_all?
    self.visible = SceneManager.scene.enemy_window.active
  end
  
  #--------------------------------------------------------------------------
  # update_text
  #--------------------------------------------------------------------------
  def update_text
    return unless self.visible
    if @info_window.visible
      text = YEA::ENEMY_INFO::HELP_INFO_SWITCH
    else
      text = YEA::ENEMY_INFO::HELP_INFO_SHOW
    end
    return if @text == text
    @text = text
    refresh
  end
  
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    reset_font_settings
    draw_background
    draw_text_ex(4, 0, @text)
  end
  
  #--------------------------------------------------------------------------
  # draw_background
  #--------------------------------------------------------------------------
  def draw_background
    temp_rect = Rect.new(0, 0, contents.width / 2, contents.height)
    colour1 = Color.new(0, 0, 0, 192)
    colour2 = Color.new(0, 0, 0, 0)
    contents.gradient_fill_rect(temp_rect, colour1, colour2)
  end
  
end # Window_ComparisonHelp

#==============================================================================
# ■ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: create_all_windows
  #--------------------------------------------------------------------------
  alias scene_battle_create_all_windows_eti create_all_windows
  def create_all_windows
    scene_battle_create_all_windows_eti
    create_comparison_windows
  end
  
  #--------------------------------------------------------------------------
  # alias method: create_comparison_windows
  #--------------------------------------------------------------------------
  def create_comparison_windows
    @actor_info_window = Window_Comparison.new(:actor)
    @enemy_info_window = Window_Comparison.new(:enemy)
    @info_help_window = Window_ComparisonHelp.new(@enemy_info_window)
  end
  
  #--------------------------------------------------------------------------
  # new method: toggle_enemy_info
  #--------------------------------------------------------------------------
  def toggle_enemy_info
    YEA::ENEMY_INFO::INFO_SFX.play
    if @enemy_info_window.visible
      hide_comparison_windows
    else
      show_comparison_windows
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: enemy_info_page_up
  #--------------------------------------------------------------------------
  def enemy_info_page_up
    YEA::ENEMY_INFO::INFO_SFX.play
    @actor_info_window.page_up
    @enemy_info_window.page_up
  end
  
  #--------------------------------------------------------------------------
  # new method: enemy_info_page_down
  #--------------------------------------------------------------------------
  def enemy_info_page_down
    YEA::ENEMY_INFO::INFO_SFX.play
    @actor_info_window.page_down
    @enemy_info_window.page_down
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_enemy_ok
  #--------------------------------------------------------------------------
  alias scene_battle_on_enemy_ok_eti on_enemy_ok
  def on_enemy_ok
    hide_comparison_windows
    scene_battle_on_enemy_ok_eti
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_enemy_cancel
  #--------------------------------------------------------------------------
  alias scene_battle_on_enemy_cancel_eti on_enemy_cancel
  def on_enemy_cancel
    hide_comparison_windows
    scene_battle_on_enemy_cancel_eti
  end
  
  #--------------------------------------------------------------------------
  # new method: show_comparison_windows
  #--------------------------------------------------------------------------
  def show_comparison_windows
    @actor_info_window.reveal(BattleManager.actor)
    @enemy_info_window.reveal(@enemy_window.enemy)
    @info_viewport.visible = false
    @skill_window.y = Graphics.height * 2
    @item_window.y = Graphics.height * 2
    @status_aid_window.y = Graphics.height * 2
  end
  
  #--------------------------------------------------------------------------
  # new method: hide_comparison_windows
  #--------------------------------------------------------------------------
  def hide_comparison_windows
    @actor_info_window.clear
    @enemy_info_window.clear
    @info_viewport.visible = true
    @skill_window.y = Graphics.height - @skill_window.height
    @item_window.y = Graphics.height - @item_window.height
    @status_aid_window.y = Graphics.height - @status_aid_window.height
  end
  
end # Scene_Battle

end # $imported["YEA-BattleEngine"]

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================