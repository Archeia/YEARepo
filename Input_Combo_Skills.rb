#==============================================================================
# 
# ▼ Yanfly Engine Ace - Input Combo Skills v1.01
# -- Last Updated: 2011.12.26
# -- Level: Hard
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-InputComboSkills"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.26 - Bug Fix: Crash when no action is performed.
# 2011.12.22 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script enables the usage of Input Combo Skills. When an Input Combo
# Skill is activated by an actor, a list of the potential input attacks appears
# on the side of the screen. The player then presses the various buttons listed
# in the window and attacks will occur in a combo fashion. If a particular
# attack combination is met, a special attack will occur.
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
# <combo skill L: x>
# <combo skill R: x>
# <combo skill X: x>
# <combo skill Y: x>
# <combo skill Z: x>
# Makes the skill with these notetags to become potentially comboable. Replace
# x with the ID of the skill you want the button to cause the skill to combo.
# The combo skill will be usable even if the user has not learned the skill.
# However, if the user is unable to use the skill due to a lack of resources,
# then the skill will be greyed out. The skill can be inputted, but if the user
# lacks the resources, it will not perform and the skill combo will break.
# 
# <combo max: x>
# Sets the maximum number of inputs the player can use for this skill. If this
# tag is not present, it will use the default number of maximum inputs that's
# pre-defined by the module.
# 
# <combo special string: x>
# If the player inputs a sequence that matches the string (any combination of
# L, R, X, Y, Z), then the special skill x will be performed. If a combination
# is met, then the combo chain will end prematurely even if there are more
# inputs left. If the user does not know skill x, then the special combo skill
# x will not be performed.
# 
# <combo only>
# This makes a skill only usable in a combo and cannot be directly used from a
# skill menu. This effect does not affect monsters. Combo skills will still be
# unusable if the user does not meet the skill's other requirements (such as a
# lack of MP or TP).
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
# While this script doesn't interfere with Active Chain Skills, it will most
# likely be unable to used in conjunction with Active Chain Skills. I will not
# provide support for any errors that may occur from this, nor will I be
# responsible for any damage doing this may cause your game.
# 
#==============================================================================

module YEA
  module INPUT_COMBO
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Combo Skill Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These settings adjust the sound effect played when a skill is selected,
    # what the minimum time windows are.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This will be the sound effect played whenever an active combo skill has
    # been selected for comboing.
    INPUT_COMBO_SOUND = RPG::SE.new("Skill2", 80, 100)
    
    # This will be the sound effect played when an input combo matches and
    # activates a specialized combo.
    ACHIEVED_COMBO_SOUND = RPG::SE.new("Skill3", 90, 100)
    
    # How many frames minimum for combo allowance. Sometimes the battlelog
    # window will move too fast for the player to be able to combo. This sets
    # a minimum timer for how long the combo window will stay open.
    MINIMUM_TIME = 90
    
    # This is the bonus number of frames of leeway that the player gets for
    # a larger input sequence. This is because the battlelog window may move
    # too fast for the player to be able to combo. This adds to the minimum
    # timer for how long the combo window will stay open.
    TIME_PER_INPUT = 30
    
    # This sets the default number of inputs that a combo skill can have at
    # maximum. If you wish to exceed this amount or to have lower than this
    # amount, use a notetag to change the skill's max combo amount.
    DEFAULT_MAX_INPUT = 5
    
    # This will be the "Window" colour used for a special skill in the display.
    SPECIAL_SKILL_COLOUR = 17
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Combo Skill Text -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This section adjusts the text that appears for the combo skills. Adjust
    # the text to appear as you see fit. Note that the vocab other than the
    # title can use text codes.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    COMBO_TITLE   = "Input Combo Attacks"
    TITLE_SIZE    = 20
    L_SKILL_ON  = "\eC[17]Q\eC[0]: "
    L_SKILL_OFF = "\eC[7]Q: "
    R_SKILL_ON  = "\eC[17]W\eC[0]: "
    R_SKILL_OFF = "\eC[7]W: "
    X_SKILL_ON  = "\eC[17]A\eC[0]: "
    X_SKILL_OFF = "\eC[7]A: "
    Y_SKILL_ON  = "\eC[17]S\eC[0]: "
    Y_SKILL_OFF = "\eC[7]S: "
    Z_SKILL_ON  = "\eC[17]D\eC[0]: "
    Z_SKILL_OFF = "\eC[7]D: "
    
  end # INPUT_COMBO
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module SKILL
    
    COMBO_MAX     = /<(?:COMBO_MAX|combo max):[ ](\d+)>/i
    COMBO_ONLY    = /<(?:COMBO_ONLY|combo only)>/i
    COMBO_SKILL   = /<(?:COMBO_SKILL|combo skill)[ ]([LRXYZ]):[ ](\d+)>/i
    COMBO_SPECIAL = /<(?:COMBO_SPECIAL|combo special)[ ](.*):[ ](\d+)>/i
    
  end # SKILL
  end # REGEXP
end # YEA

#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_ics load_database; end
  def self.load_database
    load_database_ics
    load_notetags_ics
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_ics
  #--------------------------------------------------------------------------
  def self.load_notetags_ics
    for skill in $data_skills
      next if skill.nil?
      skill.load_notetags_ics
    end
  end
  
end # DataManager

#==============================================================================
# ■ RPG::Skill
#==============================================================================

class RPG::Skill < RPG::UsableItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :combo_only
  attr_accessor :combo_skill
  attr_accessor :combo_max
  attr_accessor :combo_special
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_ics
  #--------------------------------------------------------------------------
  def load_notetags_ics
    @combo_only = false
    @combo_skill = {}
    @combo_special = {}
    @combo_max = YEA::INPUT_COMBO::DEFAULT_MAX_INPUT
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::SKILL::COMBO_ONLY
        @combo_only = true
      when YEA::REGEXP::SKILL::COMBO_SKILL
        case $1.upcase
        when "L"; @combo_skill[:L] = $2.to_i
        when "R"; @combo_skill[:R] = $2.to_i
        when "X"; @combo_skill[:X] = $2.to_i
        when "Y"; @combo_skill[:Y] = $2.to_i
        when "Z"; @combo_skill[:Z] = $2.to_i
        else; next
        end
      when YEA::REGEXP::SKILL::COMBO_MAX
        @combo_max = $1.to_i
      when YEA::REGEXP::SKILL::COMBO_SPECIAL
        @combo_special[$1.to_s.upcase] = $2.to_i
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::UsableItem

#==============================================================================
# ■ Game_Action
#==============================================================================

class Game_Action
  
  #--------------------------------------------------------------------------
  # new method: set_input_combo_skill
  #--------------------------------------------------------------------------
  def set_input_combo_skill(skill_id)
    set_skill(skill_id)
    @target_index = subject.current_action.target_index
    @input_combo_skill = true
  end
  
  #--------------------------------------------------------------------------
  # alias method: valid?
  #--------------------------------------------------------------------------
  alias game_action_valid_ics valid?
  def valid?
    subject.enable_input_combo(true) if @input_combo_skill
    result = game_action_valid_ics
    subject.enable_input_combo(false) if @input_combo_skill
    return result
  end
  
end # Game_Action

#==============================================================================
# ■ Game_BattlerBase
#==============================================================================

class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias method: skill_conditions_met?
  #--------------------------------------------------------------------------
  alias game_battlerbase_skill_conditions_met_ics skill_conditions_met?
  def skill_conditions_met?(skill)
    return false if combo_skill_restriction?(skill)
    return game_battlerbase_skill_conditions_met_ics(skill)
  end
  
  #--------------------------------------------------------------------------
  # new method: combo_skill_restriction?
  #--------------------------------------------------------------------------
  def combo_skill_restriction?(skill)
    return false unless actor?
    return false unless $game_party.in_battle
    return false unless skill.combo_only
    return !@input_combo_enabled
  end
  
  #--------------------------------------------------------------------------
  # alias method: hp=
  #--------------------------------------------------------------------------
  alias game_battlerbase_hpequals_ics hp=
  def hp=(value)
    game_battlerbase_hpequals_ics(value)
    return unless SceneManager.scene_is?(Scene_Battle)
    return unless actor?
    return if value == 0
    SceneManager.scene.refresh_input_combo_skill_window(self)
  end
  
  #--------------------------------------------------------------------------
  # alias method: mp=
  #--------------------------------------------------------------------------
  alias game_battlerbase_mpequals_ics mp=
  def mp=(value)
    game_battlerbase_mpequals_ics(value)
    return unless SceneManager.scene_is?(Scene_Battle)
    return unless actor?
    return if value == 0
    SceneManager.scene.refresh_input_combo_skill_window(self)
  end
  
  #--------------------------------------------------------------------------
  # alias method: tp=
  #--------------------------------------------------------------------------
  alias game_battlerbase_tpequals_ics tp=
  def tp=(value)
    game_battlerbase_tpequals_ics(value)
    return unless SceneManager.scene_is?(Scene_Battle)
    return unless actor?
    return if value == 0
    SceneManager.scene.refresh_input_combo_skill_window(self)
  end
  
end # Game_BattlerBase

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias method: on_battle_start
  #--------------------------------------------------------------------------
  alias game_battler_on_battle_start_ics on_battle_start
  def on_battle_start
    game_battler_on_battle_start_ics
    @input_combo_enabled = false
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_battle_end
  #--------------------------------------------------------------------------
  alias game_battler_on_battle_end_ics on_battle_end
  def on_battle_end
    game_battler_on_battle_end_ics
    @input_combo_enabled = false
  end
  
  #--------------------------------------------------------------------------
  # new method: enable_input_combo
  #--------------------------------------------------------------------------
  def enable_input_combo(active)
    return unless actor?
    @input_combo_enabled = active
  end
  
end # Game_Battler

#==============================================================================
# ■ Window_ComboSkillList
#==============================================================================

class Window_ComboSkillList < Window_Base
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize
    dw = [Graphics.width/2, 320].max
    super(-standard_padding, 0, dw, fitting_height(7))
    self.z = 200
    self.opacity = 0
    hide
  end
  
  #--------------------------------------------------------------------------
  # reveal
  #--------------------------------------------------------------------------
  def reveal(battler, skill)
    @battler = battler
    @skill = skill
    @combo_skills = []
    for key in skill.combo_skill
      next if key[1].nil?
      next if $data_skills[key[1]].nil?
      @combo_skills.push($data_skills[key[1]])
    end
    return if @combo_skills == []
    self.y = Graphics.height - fitting_height(4)
    self.y -= fitting_height(@combo_skills.size + 2)
    show
    activate
    refresh
  end
  
  #--------------------------------------------------------------------------
  # refresh_check
  #--------------------------------------------------------------------------
  def refresh_check(battler)
    return if @battler != battler
    refresh
  end
  
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_background_colour
    draw_horz_line(0)
    draw_combo_title
    draw_horz_line(@combo_skills.size * line_height)
    draw_combo_skills
  end
  
  #--------------------------------------------------------------------------
  # draw_background_colour
  #--------------------------------------------------------------------------
  def draw_background_colour
    dh = line_height * (@combo_skills.size + 2)
    rect = Rect.new(0, 0, contents.width, dh)
    back_colour1 = Color.new(0, 0, 0, 192)
    back_colour2 = Color.new(0, 0, 0, 0)
    contents.gradient_fill_rect(rect, back_colour1, back_colour2)
  end
  
  #--------------------------------------------------------------------------
  # draw_horz_line
  #--------------------------------------------------------------------------
  def draw_horz_line(dy)
    line_y = dy + line_height - 2
    line_colour = normal_color
    line_colour.alpha = 48
    contents.fill_rect(0, line_y, contents.width, 2, line_colour)
  end
  
  #--------------------------------------------------------------------------
  # draw_combo_title
  #--------------------------------------------------------------------------
  def draw_combo_title
    reset_font_settings
    text = YEA::INPUT_COMBO::COMBO_TITLE
    contents.font.size = YEA::INPUT_COMBO::TITLE_SIZE
    contents.font.bold = true
    contents.font.italic = true
    draw_text(12, 0, contents.width - 12, line_height, text)
    reset_font_settings
  end
  
  #--------------------------------------------------------------------------
  # draw_combo_skills
  #--------------------------------------------------------------------------
  def draw_combo_skills
    button_array = [:L, :R, :X, :Y, :Z]
    dx = 24
    dy = line_height
    for button in button_array
      next if @skill.combo_skill[button].nil?
      combo_skill = $data_skills[@skill.combo_skill[button]]
      text = text_setting(button, combo_skill)
      text += sprintf("\eI[%d]", combo_skill.icon_index)
      text += combo_skill.name
      draw_text_ex(dx, dy, text)
      dy += line_height
    end
  end
  
  #--------------------------------------------------------------------------
  # text_setting
  #--------------------------------------------------------------------------
  def text_setting(button, skill)
    text = ""
    case button
    when :L
      if @battler.usable?(skill)
        text = YEA::INPUT_COMBO::L_SKILL_ON
      else
        text = YEA::INPUT_COMBO::L_SKILL_OFF
      end
    when :R
      if @battler.usable?(skill)
        text = YEA::INPUT_COMBO::R_SKILL_ON
      else
        text = YEA::INPUT_COMBO::R_SKILL_OFF
      end
    when :X
      if @battler.usable?(skill)
        text = YEA::INPUT_COMBO::X_SKILL_ON
      else
        text = YEA::INPUT_COMBO::X_SKILL_OFF
      end
    when :Y
      if @battler.usable?(skill)
        text = YEA::INPUT_COMBO::Y_SKILL_ON
      else
        text = YEA::INPUT_COMBO::Y_SKILL_OFF
      end
    when :Z
      if @battler.usable?(skill)
        text = YEA::INPUT_COMBO::Z_SKILL_ON
      else
        text = YEA::INPUT_COMBO::Z_SKILL_OFF
      end
    end
    return text
  end
  
end # Window_ComboSkillList

#==============================================================================
# ■ Window_ComboInfo
#==============================================================================

class Window_ComboInfo < Window_Base
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, Graphics.width, fitting_height(1))
    self.y = Graphics.height - fitting_height(4) - fitting_height(1)
    self.opacity = 0
    self.z = 200
    @combos = []
    @special = nil
    hide
  end
  
  #--------------------------------------------------------------------------
  # reveal
  #--------------------------------------------------------------------------
  def reveal
    @combos = []
    @special = nil
    refresh
    show
  end
  
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    dx = draw_combo_icons
    draw_special(dx)
  end
  
  #--------------------------------------------------------------------------
  # add_combo
  #--------------------------------------------------------------------------
  def add_combo(icon, special = nil)
    @combos.push(icon)
    @special = special
    refresh
  end
  
  #--------------------------------------------------------------------------
  # draw_combo_icons
  #--------------------------------------------------------------------------
  def draw_combo_icons
    dx = 0
    for icon in @combos
      draw_icon(icon, dx, 0)
      dx += 24
    end
    return dx
  end
  
  #--------------------------------------------------------------------------
  # draw_special
  #--------------------------------------------------------------------------
  def draw_special(dx)
    return if @special.nil?
    draw_icon(@special.icon_index, dx + 12, 0)
    colour = text_color(YEA::INPUT_COMBO::SPECIAL_SKILL_COLOUR)
    change_color(colour)
    draw_text(dx + 36, 0, contents.width, line_height, @special.name)
  end
  
end # Window_ComboInfo

#==============================================================================
# ■ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: create_all_windows
  #--------------------------------------------------------------------------
  alias scene_battle_create_all_windows_ics create_all_windows
  def create_all_windows
    scene_battle_create_all_windows_ics
    create_combo_skill_window
  end
  
  #--------------------------------------------------------------------------
  # new method: create_combo_skill_window
  #--------------------------------------------------------------------------
  def create_combo_skill_window
    @input_combo_skill_window = Window_ComboSkillList.new
    @input_combo_info_window = Window_ComboInfo.new
    @input_combo_skill_counter = 0
  end
  
  #--------------------------------------------------------------------------
  # alias method: use_item
  #--------------------------------------------------------------------------
  alias scene_battle_use_item_ics use_item
  def use_item
    @subject.enable_input_combo(true)
    item = @subject.current_action.item
    combo_skill_list_appear(true, item)
    start_input_combo_skill_counter(item)
    scene_battle_use_item_ics
    loop do
      break if break_input_combo?(item)
      update_basic
      update_combo_skill_queue
    end
    combo_skill_list_appear(false, item)
    @subject.enable_input_combo(false)
  end
  
  #--------------------------------------------------------------------------
  # new method: combo_skill_list_appear
  #--------------------------------------------------------------------------
  def combo_skill_list_appear(visible, skill)
    return if @subject.nil?
    return unless @subject.actor?
    return unless skill.is_a?(RPG::Skill)
    return if visible && @input_combo_skill_window.visible
    if visible
      @break_combo = false
      @current_combo_skill = skill
      @total_combo_skills = 0
      @combo_skill_queue = []
      @combo_skill_string = ""
      @input_combo_skill_window.reveal(@subject, skill)
      @input_combo_info_window.reveal
    else
      @input_combo_skill_window.hide 
      @input_combo_info_window.hide
      return if @subject.current_action.nil?
      @subject.current_action.set_skill(@current_combo_skill.id)
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: refresh_input_combo_skill_window
  #--------------------------------------------------------------------------
  def refresh_input_combo_skill_window(battler)
    return unless @input_combo_skill_window.visible
    @input_combo_skill_window.refresh_check(battler)
  end
  
  #--------------------------------------------------------------------------
  # new method: start_input_combo_skill_counter
  #--------------------------------------------------------------------------
  def start_input_combo_skill_counter(skill)
    return unless @input_combo_skill_window.visible
    @input_combo_skill_counter = YEA::INPUT_COMBO::MINIMUM_TIME
    bonus_time = skill.combo_max * YEA::INPUT_COMBO::TIME_PER_INPUT
    @input_combo_skill_counter += bonus_time
  end
  
  #--------------------------------------------------------------------------
  # new method: break_input_combo?
  #--------------------------------------------------------------------------
  def break_input_combo?(item)
    return true if @break_combo
    return true if @current_combo_skill.nil?
    return true if @current_combo_skill.combo_skill == {}
    return false if @combo_skill_queue != []
    return true if @total_combo_skills == @current_combo_skill.combo_max
    return @input_combo_skill_counter <= 0
  end
  
  #--------------------------------------------------------------------------
  # new method: update_combo_skill_queue
  #--------------------------------------------------------------------------
  def update_combo_skill_queue
    return if @combo_skill_queue == []
    action = @combo_skill_queue.shift
    if !@subject.usable?(action)
      @break_combo = true
      return
    end
    @subject.current_action.set_input_combo_skill(action.id)
    @log_window.clear
    execute_action
  end
  
  #--------------------------------------------------------------------------
  # alias method: update_basic
  #--------------------------------------------------------------------------
  alias scene_battle_update_basic_ics update_basic
  def update_basic
    scene_battle_update_basic_ics
    update_input_combo_skill_counter
    update_input_combo_skill_select
  end
  
  #--------------------------------------------------------------------------
  # new method: update_input_combo_skill_counter
  #--------------------------------------------------------------------------
  def update_input_combo_skill_counter
    return if @input_combo_skill_counter == 0
    @input_combo_skill_counter -= 1
  end
  
  #--------------------------------------------------------------------------
  # new method: update_input_combo_skill_select
  #--------------------------------------------------------------------------
  def update_input_combo_skill_select
    return unless @input_combo_skill_window.visible
    return if @total_combo_skills >= @current_combo_skill.combo_max
    if Input.trigger?(:L)
      check_input_combo_skill(:L)
    elsif Input.trigger?(:R)
      check_input_combo_skill(:R)
    elsif Input.trigger?(:X)
      check_input_combo_skill(:X)
    elsif Input.trigger?(:Y)
      check_input_combo_skill(:Y)
    elsif Input.trigger?(:Z)
      check_input_combo_skill(:Z)
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: check_input_combo_skill
  #--------------------------------------------------------------------------
  def check_input_combo_skill(button)
    skill_id = @current_combo_skill.combo_skill[button]
    return if skill_id.nil?
    return if $data_skills[skill_id].nil?
    case button
    when :L; @combo_skill_string += "L"
    when :R; @combo_skill_string += "R"
    when :X; @combo_skill_string += "X"
    when :Y; @combo_skill_string += "Y"
    when :Z; @combo_skill_string += "Z"
    end
    if special_input_combo?
      icon = $data_skills[skill_id].icon_index
      @combo_skill_queue.push($data_skills[skill_id])
      skill_id = @current_combo_skill.combo_special[@combo_skill_string]
      combo_skill = $data_skills[skill_id]
      @input_combo_info_window.add_combo(icon, combo_skill)
      YEA::INPUT_COMBO::ACHIEVED_COMBO_SOUND.play
      @total_combo_skills = @current_combo_skill.combo_max
    else
      YEA::INPUT_COMBO::INPUT_COMBO_SOUND.play
      combo_skill = $data_skills[skill_id]
      @input_combo_info_window.add_combo(combo_skill.icon_index)
      @total_combo_skills += 1
    end
    @combo_skill_queue.push(combo_skill)
    return unless @total_combo_skills == @current_combo_skill.combo_max
    @input_combo_skill_counter = 0
  end
  
  #--------------------------------------------------------------------------
  # new method: special_input_combo?
  #--------------------------------------------------------------------------
  def special_input_combo?
    combo_hash = @current_combo_skill.combo_special
    return false unless combo_hash.include?(@combo_skill_string)
    skill = $data_skills[combo_hash[@combo_skill_string]]
    return @subject.skills.include?(skill)
  end
  
end # Scene_Battle

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================