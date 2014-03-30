#==============================================================================
# 
# ▼ Yanfly Engine Ace - Active Chain Skills v1.01
# -- Last Updated: 2011.12.22
# -- Level: Hard
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-ActiveChainSkills"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.22 - Better updating speed for window.
# 2011.12.18 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script enables the usage of Active Chain Skills. When a skill with any
# potential chain skill occurs, potentially chainable skills will be listed on
# the side of the screen and if the player presses the right button to trigger
# that chain skill, the battler's next action will lead into the next chain
# skill. Chain skills can only be used by actors and can be endlessly chained
# until either the actor runs out of skill cost resources or until the actor
# performs a chained skill without any skills to chain off of.
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
# <chain skill L: x>
# <chain skill R: x>
# <chain skill X: x>
# <chain skill Y: x>
# <chain skill Z: x>
# Makes the skill with these notetags to become potentially chainable. Replace
# x with the ID of the skill you want the button to cause the skill to chain.
# Note that if the actor has not learned the chain skill, the chain skill will
# not be listed. If the actor has learned the chain skill but lacks resources
# to use it, it will be greyed out.
# 
# <chain only>
# This makes the skill usable only if it's used in a chain. This effect does
# not affect monsters. Chain only skills can still be unusable if the user does
# not meet the skill's other requirements. This means that the skill will be
# disabled in the skill window when you try to actively use it from the window.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
# While this script doesn't interfere with Input Combo Skills, it will most
# likely be unable to used in conjunction with Input Combo Skills. I will not
# provide support for any errors that may occur from this, nor will I be
# responsible for any damage doing this may cause your game.
# 
#==============================================================================

module YEA
  module ACTIVE_CHAIN
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Chain Skill Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Adjust general settings here. These settings adjust the sound effect
    # played when an active skill is selected and what the minimum time window
    # is for an active chain skill.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This will be the sound effect played whenever an active chain skill has
    # been selected for chaining.
    ACTIVE_SKILL_SOUND = RPG::SE.new("Skill2", 80, 100)
    
    # How many frames minimum for chain allowance. Sometimes the battlelog
    # window will move too fast for the player to be able to chain. This sets
    # a minimum timer for how long the chain window will stay open.
    MINIMUM_TIME = 120
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Chain Skill Text -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This section adjusts the text that appears for the chain skills. Adjust
    # the text to appear as you see fit. Note that the vocab other than the
    # title can use text codes.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    CHAIN_TITLE  = "Active Chain Skills"
    TITLE_SIZE   = 20
    L_SKILL_ON   = "\eC[17]Q\eC[0]Chain: "
    L_SKILL_OFF  = "\eC[7]QChain: "
    L_SKILL_ACT  = "\eC[17]QChain: "
    R_SKILL_ON   = "\eC[17]W\eC[0]Chain: "
    R_SKILL_OFF  = "\eC[7]WChain: "
    R_SKILL_ACT  = "\eC[17]WChain: "
    X_SKILL_ON   = "\eC[17]A\eC[0]ttack: "
    X_SKILL_OFF  = "\eC[7]Attack: "
    X_SKILL_ACT  = "\eC[17]Attack: "
    Y_SKILL_ON   = "\eC[17]S\eC[0]trike: "
    Y_SKILL_OFF  = "\eC[7]Strike: "
    Y_SKILL_ACT  = "\eC[17]Strike: "
    Z_SKILL_ON   = "\eC[17]D\eC[0]efend: "
    Z_SKILL_OFF  = "\eC[7]Defend: "
    Z_SKILL_ACT  = "\eC[17]Defend: "
    
  end # ACTIVE_CHAIN
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module SKILL
    
    CHAIN_ONLY  = /<(?:CHAIN_ONLY|chain only)>/i
    CHAIN_SKILL = /<(?:CHAIN_SKILL|chain skill)[ ]([LRXYZ]):[ ](\d+)>/i
    
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
  class <<self; alias load_database_acs load_database; end
  def self.load_database
    load_database_acs
    load_notetags_acs
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_acs
  #--------------------------------------------------------------------------
  def self.load_notetags_acs
    for skill in $data_skills
      next if skill.nil?
      skill.load_notetags_acs
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
  attr_accessor :chain_only
  attr_accessor :chain_skill
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_acs
  #--------------------------------------------------------------------------
  def load_notetags_acs
    @chain_only = false
    @chain_skill = {}
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::SKILL::CHAIN_ONLY
        @chain_only = true
      when YEA::REGEXP::SKILL::CHAIN_SKILL
        case $1.upcase
        when "L"; @chain_skill[:L] = $2.to_i
        when "R"; @chain_skill[:R] = $2.to_i
        when "X"; @chain_skill[:X] = $2.to_i
        when "Y"; @chain_skill[:Y] = $2.to_i
        when "Z"; @chain_skill[:Z] = $2.to_i
        else; next
        end
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
  # new method: set_active_chain_skill
  #--------------------------------------------------------------------------
  def set_active_chain_skill(skill_id)
    set_skill(skill_id)
    @target_index = subject.current_action.target_index
    @active_chain_skill = true
  end
  
  #--------------------------------------------------------------------------
  # alias method: valid?
  #--------------------------------------------------------------------------
  alias game_action_valid_acs valid?
  def valid?
    subject.enable_active_chain(true) if @active_chain_skill
    result = game_action_valid_acs
    subject.enable_active_chain(false) if @active_chain_skill
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
  alias game_battlerbase_skill_conditions_met_acs skill_conditions_met?
  def skill_conditions_met?(skill)
    return false if chain_skill_restriction?(skill)
    return game_battlerbase_skill_conditions_met_acs(skill)
  end
  
  #--------------------------------------------------------------------------
  # new method: chain_skill_restriction?
  #--------------------------------------------------------------------------
  def chain_skill_restriction?(skill)
    return false unless actor?
    return false unless $game_party.in_battle
    return false unless skill.chain_only
    return !@active_chain_enabled
  end
  
  #--------------------------------------------------------------------------
  # alias method: hp=
  #--------------------------------------------------------------------------
  alias game_battlerbase_hpequals_acs hp=
  def hp=(value)
    game_battlerbase_hpequals_acs(value)
    return unless SceneManager.scene_is?(Scene_Battle)
    return unless actor?
    return if value == 0
    SceneManager.scene.refresh_active_chain_skill_window(self)
  end
  
  #--------------------------------------------------------------------------
  # alias method: mp=
  #--------------------------------------------------------------------------
  alias game_battlerbase_mpequals_acs mp=
  def mp=(value)
    game_battlerbase_mpequals_acs(value)
    return unless SceneManager.scene_is?(Scene_Battle)
    return unless actor?
    return if value == 0
    SceneManager.scene.refresh_active_chain_skill_window(self)
  end
  
  #--------------------------------------------------------------------------
  # alias method: tp=
  #--------------------------------------------------------------------------
  alias game_battlerbase_tpequals_acs tp=
  def tp=(value)
    game_battlerbase_tpequals_acs(value)
    return unless SceneManager.scene_is?(Scene_Battle)
    return unless actor?
    return if value == 0
    SceneManager.scene.refresh_active_chain_skill_window(self)
  end
  
end # Game_BattlerBase

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias method: on_battle_start
  #--------------------------------------------------------------------------
  alias game_battler_on_battle_start_acs on_battle_start
  def on_battle_start
    game_battler_on_battle_start_acs
    @active_chain_enabled = false
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_battle_end
  #--------------------------------------------------------------------------
  alias game_battler_on_battle_end_acs on_battle_end
  def on_battle_end
    game_battler_on_battle_end_acs
    @active_chain_enabled = false
  end
  
  #--------------------------------------------------------------------------
  # new method: enable_active_chain
  #--------------------------------------------------------------------------
  def enable_active_chain(active)
    return unless actor?
    @active_chain_enabled = active
  end
  
  #--------------------------------------------------------------------------
  # new method: add_active_skill_chain
  #--------------------------------------------------------------------------
  def add_active_skill_chain(skill_id)
    chain_skill = Game_Action.new(self)
    chain_skill.set_active_chain_skill(skill_id)
    @actions.insert(1, chain_skill)
  end
  
end # Game_Battler

#==============================================================================
# ■ Window_ChainSkillList
#==============================================================================

class Window_ChainSkillList < Window_Base
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize
    dw = [Graphics.width/2, 320].max
    super(-standard_padding, 0, dw, fitting_height(6))
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
    @chain_skills = []
    for key in skill.chain_skill
      next if key[1].nil?
      next if $data_skills[key[1]].nil?
      next unless @battler.skills.include?($data_skills[key[1]])
      @chain_skills.push($data_skills[key[1]])
    end
    return if @chain_skills == []
    self.y = Graphics.height - fitting_height(4)
    self.y -= fitting_height(@chain_skills.size + 1)
    show
    activate
    @enabled = true
    refresh
  end
  
  #--------------------------------------------------------------------------
  # button=
  #--------------------------------------------------------------------------
  def button=(button)
    @button = button
    @enabled = false
    refresh unless @button.nil?
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
    @button = nil if @enabled
    contents.clear
    draw_background_colour
    draw_horz_line(0)
    draw_combo_title
    draw_chain_skills
  end
  
  #--------------------------------------------------------------------------
  # draw_background_colour
  #--------------------------------------------------------------------------
  def draw_background_colour
    dh = line_height * (@chain_skills.size + 1)
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
    text = YEA::ACTIVE_CHAIN::CHAIN_TITLE
    contents.font.size = YEA::ACTIVE_CHAIN::TITLE_SIZE
    contents.font.bold = true
    contents.font.italic = true
    draw_text(12, 0, contents.width - 12, line_height, text)
    reset_font_settings
  end
  
  #--------------------------------------------------------------------------
  # draw_chain_skills
  #--------------------------------------------------------------------------
  def draw_chain_skills
    button_array = [:L, :R, :X, :Y, :Z]
    dx = 24
    dy = line_height
    for button in button_array
      next if @skill.chain_skill[button].nil?
      chain_skill = $data_skills[@skill.chain_skill[button]]
      next unless @battler.skills.include?(chain_skill)
      text = text_setting(button, chain_skill)
      text += sprintf("\eI[%d]", chain_skill.icon_index)
      text += chain_skill.name
      draw_text_ex(dx, dy, text)
      dy += line_height
    end
  end
  
  #--------------------------------------------------------------------------
  # text_setting
  #--------------------------------------------------------------------------
  def text_setting(button, skill)
    active = button == @button
    text = ""
    case button
    when :L
      if @enabled && @battler.usable?(skill)
        text = YEA::ACTIVE_CHAIN::L_SKILL_ON
      elsif !@enabled && active
        text = YEA::ACTIVE_CHAIN::L_SKILL_ACT
      else
        text = YEA::ACTIVE_CHAIN::L_SKILL_OFF
      end
    when :R
      if @enabled && @battler.usable?(skill)
        text = YEA::ACTIVE_CHAIN::R_SKILL_ON
      elsif !@enabled && active
        text = YEA::ACTIVE_CHAIN::R_SKILL_ACT
      else
        text = YEA::ACTIVE_CHAIN::R_SKILL_OFF
      end
    when :X
      if @enabled && @battler.usable?(skill)
        text = YEA::ACTIVE_CHAIN::X_SKILL_ON
      elsif !@enabled && active
        text = YEA::ACTIVE_CHAIN::X_SKILL_ACT
      else
        text = YEA::ACTIVE_CHAIN::X_SKILL_OFF
      end
    when :Y
      if @enabled && @battler.usable?(skill)
        text = YEA::ACTIVE_CHAIN::Y_SKILL_ON
      elsif !@enabled && active
        text = YEA::ACTIVE_CHAIN::Y_SKILL_ACT
      else
        text = YEA::ACTIVE_CHAIN::Y_SKILL_OFF
      end
    when :Z
      if @enabled && @battler.usable?(skill)
        text = YEA::ACTIVE_CHAIN::Z_SKILL_ON
      elsif !@enabled && active
        text = YEA::ACTIVE_CHAIN::Z_SKILL_ACT
      else
        text = YEA::ACTIVE_CHAIN::Z_SKILL_OFF
      end
    end
    return text
  end
  
end # Window_ChainSkillList

#==============================================================================
# ■ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: create_all_windows
  #--------------------------------------------------------------------------
  alias scene_battle_create_all_windows_acs create_all_windows
  def create_all_windows
    scene_battle_create_all_windows_acs
    create_chain_skill_window
  end
  
  #--------------------------------------------------------------------------
  # new method: create_chain_skill_window
  #--------------------------------------------------------------------------
  def create_chain_skill_window
    @active_chain_skill_window = Window_ChainSkillList.new
    @active_chain_skill_counter = 0
  end
  
  #--------------------------------------------------------------------------
  # alias method: use_item
  #--------------------------------------------------------------------------
  alias scene_battle_use_item_acs use_item
  def use_item
    @subject.enable_active_chain(true)
    item = @subject.current_action.item
    chain_skill_list_appear(true, item)
    start_active_skill_counter(item)
    scene_battle_use_item_acs
    wait_active_skill_counter
    chain_skill_list_appear(false, item)
    @subject.enable_active_chain(false)
  end
  
  #--------------------------------------------------------------------------
  # new method: chain_skill_list_appear
  #--------------------------------------------------------------------------
  def chain_skill_list_appear(visible, skill)
    return if @subject.nil?
    return unless @subject.actor?
    return unless skill.is_a?(RPG::Skill)
    @active_chain_skill = 0
    @current_chain_skill = skill
    @active_chain_skill_window.reveal(@subject, skill) if visible
    @active_chain_skill_window.hide unless visible
  end
  
  #--------------------------------------------------------------------------
  # new method: refresh_active_chain_skill_window
  #--------------------------------------------------------------------------
  def refresh_active_chain_skill_window(battler)
    return unless @active_chain_skill_window.visible
    @active_chain_skill_window.refresh_check(battler)
  end
  
  #--------------------------------------------------------------------------
  # new method: start_active_skill_counter
  #--------------------------------------------------------------------------
  def start_active_skill_counter(skill)
    return unless @active_chain_skill_window.visible
    @active_chain_skill_counter = YEA::ACTIVE_CHAIN::MINIMUM_TIME
  end
  
  #--------------------------------------------------------------------------
  # new method: wait_active_skill_counter
  #--------------------------------------------------------------------------
  def wait_active_skill_counter
    return unless @active_chain_skill_window.visible
    wait(@active_chain_skill_counter)
  end
  
  #--------------------------------------------------------------------------
  # new method: update_active_chain_skill_counter
  #--------------------------------------------------------------------------
  def update_active_chain_skill_counter
    return if @active_chain_skill_counter == 0
    @active_chain_skill_counter -= 1
  end
  
  #--------------------------------------------------------------------------
  # alias method: update_basic
  #--------------------------------------------------------------------------
  alias scene_battle_update_basic_acs update_basic
  def update_basic
    scene_battle_update_basic_acs
    update_active_chain_skill_counter
    update_active_chain_skill_select
  end
  
  #--------------------------------------------------------------------------
  # new method: update_active_chain_skill_select
  #--------------------------------------------------------------------------
  def update_active_chain_skill_select
    return unless @active_chain_skill_window.visible
    return if @active_chain_skill > 0
    if Input.press?(:L)
      check_active_chain_skill(:L)
    elsif Input.press?(:R)
      check_active_chain_skill(:R)
    elsif Input.press?(:X)
      check_active_chain_skill(:X)
    elsif Input.press?(:Y)
      check_active_chain_skill(:Y)
    elsif Input.press?(:Z)
      check_active_chain_skill(:Z)
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: check_active_chain_skill
  #--------------------------------------------------------------------------
  def check_active_chain_skill(button)
    skill_id = @current_chain_skill.chain_skill[button]
    return if skill_id.nil?
    return if $data_skills[skill_id].nil?
    chain_skill = $data_skills[skill_id]
    return unless @subject.usable?(chain_skill)
    return unless @subject.skills.include?(chain_skill)
    @active_chain_skill_counter = 12
    @active_chain_skill = skill_id
    @active_chain_skill_window.button = button
    YEA::ACTIVE_CHAIN::ACTIVE_SKILL_SOUND.play
    @subject.add_active_skill_chain(skill_id)
  end
  
end # Scene_Battle

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================