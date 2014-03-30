#==============================================================================
# 
# ▼ Yanfly Engine Ace - Ace Status Menu v1.02
# -- Last Updated: 2011.12.26
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-StatusMenu"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.08.06 - Fix Sp Paramater TCR
# 2011.12.26 - Compatibility Update: Rename Actor
# 2011.12.23 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script changes the status screen completely to something the player can
# interact with more and be able to view actor data with more clarity. The
# player is able to view the general information for an actor (parameters and
# experience), a parameters bar graph, the various hidden extra parameters
# (named properties in the script), and a customizable biography for the actor.
# Also with this script, biographies can be changed at any time using a script
# call to add more of a personal touch to characters.
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
# $game_actors[x].description = string
# Changes the biography description for actor x to that of the string. Use \n
# to designate linebreaks in the string. If you wish to use text codes, write
# them in the strings as \\n[2] or \\c[3] to make them work properly.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module STATUS
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Command Window Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This section adjusts the commands that appear in the command window used
    # for the status screen. Rearrange the commands, add new ones, remove them
    # as you see fit.
    # 
    # -------------------------------------------------------------------------
    # :command         Description
    # -------------------------------------------------------------------------
    # :general         Adds general page.
    # :parameters      Adds parameters page.
    # :properties      Adds properties page.
    # :biography       Adds biography page.
    # 
    # :rename          Requires YEA - Rename Actor
    # :retitle         Requires YEA - Retitle Actor
    # 
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    COMMANDS =[ # The order at which the menu items are shown.
    # [    :command,    "Display"],
      [    :general,    "General"],
      [ :parameters, "Parameters"],
      [ :properties, "Properties"],
    # [    :custom1,     "Skills"],
    # [    :custom2,  "Equipment"],
    # [    :custom3,      "Class"],
      [  :biography,  "Biography"],
      [     :rename,     "Rename"],  # Requires YEA - Rename Actor
      [    :retitle,    "Retitle"],  # Requires YEA - Rename Actor
    ] # Do not remove this.
    
    #--------------------------------------------------------------------------
    # - Status Custom Commands -
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # For those who use scripts to that may produce unique effects for the
    # status menu, use this hash to manage the custom commands for the Status
    # Command Window. You can disable certain commands or prevent them from
    # appearing by using switches. If you don't wish to bind them to a switch,
    # set the proper switch to 0 for it to have no impact.
    #--------------------------------------------------------------------------
    CUSTOM_STATUS_COMMANDS ={
    # :command => [EnableSwitch, ShowSwitch, Handler Method, Window Draw],
      :custom1 => [           0,          0, :command_name1, :draw_custom1],
      :custom2 => [           0,          0, :command_name2, :draw_custom2],
      :custom3 => [           0,          0, :command_name3, :draw_custom3],
    } # Do not remove this.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - General Window Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These settings adjust the way the general window visually appears.
    # Not many changes need to be done here other than vocab changes.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    PARAMETERS_VOCAB = "Parameters"         # Title used for Parameters.
    EXPERIENCE_VOCAB = "Experience"         # Title used for Experience.
    NEXT_TOTAL_VOCAB = "Next %s Total EXP"  # Label used for total experience.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Parameters Window Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These settings adjust the way the parameters window visually appears.
    # Each of the stats have a non-window colour. Adjust them as you see fit.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    PARAM_COLOUR ={
    # ParamID => [:stat,       Colour1,                   Colour2          ],
            2 => [ :atk, Color.new(225, 100, 100), Color.new(240, 150, 150)],
            3 => [ :def, Color.new(250, 150,  30), Color.new(250, 180, 100)],
            4 => [ :mat, Color.new( 70, 140, 200), Color.new(135, 180, 230)],
            5 => [ :mdf, Color.new(135, 130, 190), Color.new(170, 160, 220)],
            6 => [ :agi, Color.new( 60, 180,  80), Color.new(120, 200, 120)],
            7 => [ :luk, Color.new(255, 240, 100), Color.new(255, 250, 200)],
    } # Do not remove this.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Properties Window Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These settings adjust the way the properties window visually appears.
    # The properties have abbreviations, but leaving them as such makes things
    # confusing (as it's sometimes hard to figure out what the abbreviations
    # mean). Change the way the appear, whether or not they appear, and what
    # order they will appear in.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    PROPERTIES_FONT_SIZE = 16        # Font size used for properties.
    
    # These are the properties that appear in column 1.
    PROPERTIES_COLUMN1 =[
      [:hit, "Hit Rate"],
      [:eva, "Evasion"],
      [:cri, "Critical Hit"],
      [:cev, "Critical Evade"],
      [:mev, "Magic Evasion"],
      [:mrf, "Magic Reflect"],
      [:cnt, "Counter Rate"],
      [:tgr, "Target Rate"],
    ] # Do not remove this.
    
    # These are the properties that appear in column 2.
    PROPERTIES_COLUMN2 =[
      [:hrg, "HP Regen"],
      [:mrg, "MP Regen"],
      [:trg, "TP Regen"],
      [:rec, "Recovery"],
      [:grd, "Guard Rate"],
      [:pha, "Item Boost"],
      [:exr, "EXP Rate"],
      [:tcr, "TP Charge"],
    ] # Do not remove this.
    
    # These are the properties that appear in column 3.
    PROPERTIES_COLUMN3 =[
      [:hcr, "HP Cost Rate"],    # Requires YEA - Skill Cost Manager
      [:mcr, "MP Cost Rate"],
      [:tcr_y, "TP Cost Rate"],    # Requires YEA - Skill Cost Manager
      [:cdr, "Cooldown Rate"],   # Requires YEA - Skill Restrictions
      [:wur, "Warmup Rate"],     # Requires YEA - Skill Restrictions
      [:pdr, "Physical Damage"],
      [:mdr, "Magical Damage"],
      [:fdr, "Floor Damage"],
    ] # Do not remove this.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Biography Window Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These settings adjust the way the biography appears including the title
    # used at the top, the font size, and whatnot.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    BIOGRAPHY_NICKNAME_TEXT = "%s the %s"   # How the nickname will appear.
    BIOGRAPHY_NICKNAME_SIZE = 32            # Size of the font used.
    
  end # STATUS
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

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
# ■ Game_Temp
#==============================================================================

class Game_Temp
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :scene_status_index
  attr_accessor :scene_status_oy
  
end # Game_Temp

#==============================================================================
# ■ Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  
  #--------------------------------------------------------------------------
  # new method: description=
  #--------------------------------------------------------------------------
  def description=(text)
    @description = text
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: description
  #--------------------------------------------------------------------------
  def description
    return @description unless @description.nil?
    return actor.description
  end
  
end # Game_Actor

#==============================================================================
# ■ Window_StatusCommand
#==============================================================================

class Window_StatusCommand < Window_Command
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :item_window
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(dx, dy)
    super(dx, dy)
    @actor = nil
  end
  
  #--------------------------------------------------------------------------
  # window_width
  #--------------------------------------------------------------------------
  def window_width; return 160; end
  
  #--------------------------------------------------------------------------
  # actor=
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
  
  #--------------------------------------------------------------------------
  # visible_line_number
  #--------------------------------------------------------------------------
  def visible_line_number; return 4; end
  
  #--------------------------------------------------------------------------
  # ok_enabled?
  #--------------------------------------------------------------------------
  def ok_enabled?
    return handle?(current_symbol)
  end
  
  #--------------------------------------------------------------------------
  # make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    return unless @actor
    for command in YEA::STATUS::COMMANDS
      case command[0]
      #--- Default ---
      when :general, :parameters, :properties, :biography
        add_command(command[1], command[0])
      #--- Yanfly Engine Ace ---
      when :rename
        next unless $imported["YEA-RenameActor"]
        add_command(command[1], command[0], @actor.rename_allow?)
      when :retitle
        next unless $imported["YEA-RenameActor"]
        add_command(command[1], command[0], @actor.retitle_allow?)
      #--- Custom Commands ---
      else
        process_custom_command(command)
      end
    end
    if !$game_temp.scene_status_index.nil?
      select($game_temp.scene_status_index)
      self.oy = $game_temp.scene_status_oy
    end
    $game_temp.scene_status_index = nil
    $game_temp.scene_status_oy = nil
  end
  
  #--------------------------------------------------------------------------
  # process_ok
  #--------------------------------------------------------------------------
  def process_ok
    $game_temp.scene_status_index = index
    $game_temp.scene_status_oy = self.oy
    super
  end
  
  #--------------------------------------------------------------------------
  # process_custom_command
  #--------------------------------------------------------------------------
  def process_custom_command(command)
    return unless YEA::STATUS::CUSTOM_STATUS_COMMANDS.include?(command[0])
    show = YEA::STATUS::CUSTOM_STATUS_COMMANDS[command[0]][1]
    continue = show <= 0 ? true : $game_switches[show]
    return unless continue
    text = command[1]
    switch = YEA::STATUS::CUSTOM_STATUS_COMMANDS[command[0]][0]
    enabled = switch <= 0 ? true : $game_switches[switch]
    add_command(text, command[0], enabled)
  end
  
  #--------------------------------------------------------------------------
  # update
  #--------------------------------------------------------------------------
  def update
    super
    update_item_window
  end
  
  #--------------------------------------------------------------------------
  # update_item_window
  #--------------------------------------------------------------------------
  def update_item_window
    return if @item_window.nil?
    return if @current_index == current_symbol
    @current_index = current_symbol
    @item_window.refresh
  end
  
  #--------------------------------------------------------------------------
  # item_window=
  #--------------------------------------------------------------------------
  def item_window=(window)
    @item_window = window
    update
  end
  
  #--------------------------------------------------------------------------
  # update_help
  #--------------------------------------------------------------------------
  def update_help
    return if @actor.nil?
    @help_window.set_text(@actor.actor.description)
  end
  
end # Window_StatusCommand

#==============================================================================
# ■ Window_StatusActor
#==============================================================================

class Window_StatusActor < Window_Base
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(dx, dy)
    super(dx, dy, window_width, fitting_height(4))
    @actor = nil
  end
  
  #--------------------------------------------------------------------------
  # window_width
  #--------------------------------------------------------------------------
  def window_width; return Graphics.width - 160; end
  
  #--------------------------------------------------------------------------
  # actor=
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
  
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    return unless @actor
    draw_actor_face(@actor, 0, 0)
    draw_actor_simple_status(@actor, 108, line_height / 2)
  end
  
end # Window_StatusActor

#==============================================================================
# ■ Window_StatusItem
#==============================================================================

class Window_StatusItem < Window_Base
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(dx, dy, command_window)
    super(dx, dy, Graphics.width, Graphics.height - dy)
    @command_window = command_window
    @actor = nil
    refresh
  end
  
  #--------------------------------------------------------------------------
  # actor=
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
  
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    reset_font_settings
    return unless @actor
    draw_window_contents
  end
  
  #--------------------------------------------------------------------------
  # draw_window_contents
  #--------------------------------------------------------------------------
  def draw_window_contents
    case @command_window.current_symbol
    when :general
      draw_actor_general
    when :parameters
      draw_parameter_graph
    when :properties
      draw_properties_list
    when :biography, :rename, :retitle
      draw_actor_biography
    else
      draw_custom
    end
  end
  
  #--------------------------------------------------------------------------
  # draw_actor_general
  #--------------------------------------------------------------------------
  def draw_actor_general
    change_color(system_color)
    text = YEA::STATUS::PARAMETERS_VOCAB
    draw_text(0, 0, contents.width/2, line_height, text, 1)
    text = YEA::STATUS::EXPERIENCE_VOCAB
    draw_text(contents.width/2, 0, contents.width/2, line_height, text, 1)
    draw_general_parameters
    draw_general_experience
  end
  
  #--------------------------------------------------------------------------
  # draw_general_parameters
  #--------------------------------------------------------------------------
  def draw_general_parameters
    dx = 24
    dy = line_height / 2
    draw_actor_level(dx, line_height*1+dy, contents.width/2 - 24)
    draw_actor_param(0, dx, line_height*2+dy, contents.width/2 - 24)
    draw_actor_param(1, dx, line_height*3+dy, contents.width/2 - 24)
    draw_actor_param(2, dx, line_height*4+dy, contents.width/4 - 12)
    draw_actor_param(4, dx, line_height*5+dy, contents.width/4 - 12)
    draw_actor_param(6, dx, line_height*6+dy, contents.width/4 - 12)
    dx += contents.width/4 - 12
    draw_actor_param(3, dx, line_height*4+dy, contents.width/4 - 12)
    draw_actor_param(5, dx, line_height*5+dy, contents.width/4 - 12)
    draw_actor_param(7, dx, line_height*6+dy, contents.width/4 - 12)
  end
  
  #--------------------------------------------------------------------------
  # draw_actor_level
  #--------------------------------------------------------------------------
  def draw_actor_level(dx, dy, dw)
    colour = Color.new(0, 0, 0, translucent_alpha/2)
    rect = Rect.new(dx+1, dy+1, dw-2, line_height-2)
    contents.fill_rect(rect, colour)
    change_color(system_color)
    draw_text(dx+4, dy, dw-8, line_height, Vocab::level)
    change_color(normal_color)
    draw_text(dx+4, dy, dw-8, line_height, @actor.level.group, 2)
  end
  
  #--------------------------------------------------------------------------
  # draw_actor_param
  #--------------------------------------------------------------------------
  def draw_actor_param(param_id, dx, dy, dw)
    colour = Color.new(0, 0, 0, translucent_alpha/2)
    rect = Rect.new(dx+1, dy+1, dw-2, line_height-2)
    contents.fill_rect(rect, colour)
    change_color(system_color)
    draw_text(dx+4, dy, dw-8, line_height, Vocab::param(param_id))
    change_color(normal_color)
    draw_text(dx+4, dy, dw-8, line_height, @actor.param(param_id).group, 2)
  end
  
  #--------------------------------------------------------------------------
  # draw_general_experience
  #--------------------------------------------------------------------------
  def draw_general_experience
    if @actor.max_level?
      s1 = @actor.exp.group
      s2 = "-------"
      s3 = "-------"
    else
      s1 = @actor.exp.group
      s2 = (@actor.next_level_exp - @actor.exp).group
      s3 = @actor.next_level_exp.group
    end
    s_next = sprintf(Vocab::ExpNext, Vocab::level)
    total_next_text = sprintf(YEA::STATUS::NEXT_TOTAL_VOCAB, Vocab::level)
    change_color(system_color)
    dx = contents.width/2 + 12
    dy = line_height * 3 / 2
    dw = contents.width/2 - 36
    draw_text(dx, dy + line_height * 0, dw, line_height, Vocab::ExpTotal)
    draw_text(dx, dy + line_height * 2, dw, line_height, s_next)
    draw_text(dx, dy + line_height * 4, dw, line_height, total_next_text)
    change_color(normal_color)
    draw_text(dx, dy + line_height * 1, dw, line_height, s1, 2)
    draw_text(dx, dy + line_height * 3, dw, line_height, s2, 2)
    draw_text(dx, dy + line_height * 5, dw, line_height, s3, 2)
  end
  
  #--------------------------------------------------------------------------
  # draw_parameter_graph
  #--------------------------------------------------------------------------
  def draw_parameter_graph
    draw_parameter_title
    dy = line_height * 3/2
    maximum = 1
    minimum = @actor.param_max(2)
    for i in 2..7
      maximum = [@actor.param(i), maximum].max
      minimum = [@actor.param(i), minimum].min
    end
    maximum += minimum * 0.33 unless maximum == minimum
    for i in 2..7
      rate = calculate_rate(maximum, minimum, i)
      dy = line_height * i - line_height/2
      draw_param_gauge(i, dy, rate)
      change_color(system_color)
      draw_text(28, dy, contents.width - 56, line_height, Vocab::param(i))
      dw = (contents.width - 48) * rate - 8
      change_color(normal_color)
      draw_text(28, dy, dw, line_height, @actor.param(i).group, 2)
    end
  end
  
  #--------------------------------------------------------------------------
  # calculate_rate
  #--------------------------------------------------------------------------
  def calculate_rate(maximum, minimum, param_id)
    return 1.0 if maximum == minimum
    rate = (@actor.param(param_id).to_f - minimum) / (maximum - minimum).to_f
    rate *= 0.67
    rate += 0.33
    return rate
  end
  
  #--------------------------------------------------------------------------
  # draw_param_gauge
  #--------------------------------------------------------------------------
  def draw_param_gauge(param_id, dy, rate)
    dw = contents.width - 48
    colour1 = param_gauge1(param_id)
    colour2 = param_gauge2(param_id)
    draw_gauge(24, dy, dw, rate, colour1, colour2)
  end
  
  #--------------------------------------------------------------------------
  # param_gauge1
  #--------------------------------------------------------------------------
  def param_gauge1(param_id)
    return YEA::STATUS::PARAM_COLOUR[param_id][1]
  end
  
  #--------------------------------------------------------------------------
  # param_gauge2
  #--------------------------------------------------------------------------
  def param_gauge2(param_id)
    return YEA::STATUS::PARAM_COLOUR[param_id][2]
  end
  
  #--------------------------------------------------------------------------
  # draw_parameter_title
  #--------------------------------------------------------------------------
  def draw_parameter_title
    colour = Color.new(0, 0, 0, translucent_alpha/2)
    rect = Rect.new(0, 0, contents.width, contents.height)
    contents.fill_rect(rect, colour)
    change_color(system_color)
    text = YEA::STATUS::PARAMETERS_VOCAB
    draw_text(0, line_height/3, contents.width, line_height, text, 1)
  end
  
  #--------------------------------------------------------------------------
  # draw_properties_list
  #--------------------------------------------------------------------------
  def draw_properties_list
    contents.font.size = YEA::STATUS::PROPERTIES_FONT_SIZE
    draw_properties_column1
    draw_properties_column2
    draw_properties_column3
    reset_font_settings
  end
  
  #--------------------------------------------------------------------------
  # draw_properties_column1
  #--------------------------------------------------------------------------
  def draw_properties_column1
    dx = 24
    dw = (contents.width - 24) / 3 - 24
    dy = 0
    for property in YEA::STATUS::PROPERTIES_COLUMN1
      dy = draw_property(property, dx, dy, dw)
    end
  end
  
  #--------------------------------------------------------------------------
  # draw_properties_column2
  #--------------------------------------------------------------------------
  def draw_properties_column2
    dx = 24 + (contents.width - 24) / 3
    dw = (contents.width - 24) / 3 - 24
    dy = 0
    for property in YEA::STATUS::PROPERTIES_COLUMN2
      dy = draw_property(property, dx, dy, dw)
    end
  end
  
  #--------------------------------------------------------------------------
  # draw_properties_column3
  #--------------------------------------------------------------------------
  def draw_properties_column3
    dx = 24 + (contents.width - 24) / 3 * 2
    dw = (contents.width - 24) / 3 - 24
    dy = 0
    for property in YEA::STATUS::PROPERTIES_COLUMN3
      dy = draw_property(property, dx, dy, dw)
    end
  end
  
  #--------------------------------------------------------------------------
  # draw_property
  #--------------------------------------------------------------------------
  def draw_property(property, dx, dy, dw)
    fmt = "%1.2f%%"
    case property[0]
    #---
    when :hit
      value = sprintf(fmt, @actor.hit * 100)
    when :eva
      value = sprintf(fmt, @actor.eva * 100)
    when :cri
      value = sprintf(fmt, @actor.cri * 100)
    when :cev
      value = sprintf(fmt, @actor.cev * 100)
    when :mev
      value = sprintf(fmt, @actor.mev * 100)
    when :mrf
      value = sprintf(fmt, @actor.mrf * 100)
    when :cnt
      value = sprintf(fmt, @actor.cnt * 100)
    when :hrg
      value = sprintf(fmt, @actor.hrg * 100)
    when :mrg
      value = sprintf(fmt, @actor.mrg * 100)
    when :trg
      value = sprintf(fmt, @actor.trg * 100)
    when :tgr
      value = sprintf(fmt, @actor.tgr * 100)
    when :grd
      value = sprintf(fmt, @actor.grd * 100)
    when :rec
      value = sprintf(fmt, @actor.rec * 100)
    when :pha
      value = sprintf(fmt, @actor.pha * 100)
    when :mcr
      value = sprintf(fmt, @actor.mcr * 100)
    when :tcr
      value = sprintf(fmt, @actor.tcr * 100)
    when :pdr
      value = sprintf(fmt, @actor.pdr * 100)
    when :mdr
      value = sprintf(fmt, @actor.mdr * 100)
    when :fdr
      value = sprintf(fmt, @actor.fdr * 100)
    when :exr
      value = sprintf(fmt, @actor.exr * 100)
    when :hcr
      return dy unless $imported["YEA-SkillCostManager"]
      value = sprintf(fmt, @actor.hcr * 100)
    when :tcr_y
      return dy unless $imported["YEA-SkillCostManager"]
      value = sprintf(fmt, @actor.tcr_y * 100)
    when :gcr
      return dy unless $imported["YEA-SkillCostManager"]
      value = sprintf(fmt, @actor.gcr * 100)
    when :cdr
      return dy unless $imported["YEA-SkillRestrictions"]
      value = sprintf(fmt, @actor.cdr * 100)
    when :wur
      return dy unless $imported["YEA-SkillRestrictions"]
      value = sprintf(fmt, @actor.wur * 100)
    #---
    else; return dy
    end
    colour = Color.new(0, 0, 0, translucent_alpha/2)
    rect = Rect.new(dx+1, dy+1, dw-2, line_height-2)
    contents.fill_rect(rect, colour)
    change_color(system_color)
    draw_text(dx+4, dy, dw-8, line_height, property[1], 0)
    change_color(normal_color)
    draw_text(dx+4, dy, dw-8, line_height, value, 2)
    return dy + line_height
  end
  
  #--------------------------------------------------------------------------
  # draw_actor_biography
  #--------------------------------------------------------------------------
  def draw_actor_biography
    fmt = YEA::STATUS::BIOGRAPHY_NICKNAME_TEXT
    text = sprintf(fmt, @actor.name, @actor.nickname)
    contents.font.size = YEA::STATUS::BIOGRAPHY_NICKNAME_SIZE
    draw_text(0, 0, contents.width, line_height*2, text, 1)
    reset_font_settings
    draw_text_ex(24, line_height*2, @actor.description)
  end
  
  #--------------------------------------------------------------------------
  # draw_custom
  #--------------------------------------------------------------------------
  def draw_custom
    current_symbol = @command_window.current_symbol
    return unless YEA::STATUS::CUSTOM_STATUS_COMMANDS.include?(current_symbol)
    method(YEA::STATUS::CUSTOM_STATUS_COMMANDS[current_symbol][3]).call
  end
  
  #--------------------------------------------------------------------------
  # draw_custom1
  #--------------------------------------------------------------------------
  def draw_custom1
    dx = 0; dy = 0
    for skill in @actor.skills
      next if skill.nil?
      next unless @actor.added_skill_types.include?(skill.stype_id)
      draw_item_name(skill, dx, dy)
      dx = dx == contents.width / 2 + 16 ? 0 : contents.width / 2 + 16
      dy += line_height if dx == 0
      return if dy + line_height > contents.height
    end
  end
  
  #--------------------------------------------------------------------------
  # draw_custom2
  #--------------------------------------------------------------------------
  def draw_custom2
    dx = 4; dy = 0; slot_id = 0
    for equip in @actor.equips
      change_color(system_color)
      text = Vocab.etype(@actor.equip_slots[slot_id])
      draw_text(dx, dy, contents.width - dx, line_height, text)
      reset_font_settings
      draw_item_name(equip, dx+92, dy) unless equip.nil?
      slot_id += 1
      dy += line_height
      break if dy + line_height > contents.height
    end
    dw = Graphics.width * 2 / 5 - 24
    dx = contents.width - dw; dy = 0
    param_id = 0
    8.times do
      colour = Color.new(0, 0, 0, translucent_alpha/2)
      rect = Rect.new(dx+1, dy+1, dw - 2, line_height - 2)
      contents.fill_rect(rect, colour)
      size = $imported["YEA-AceEquipEngine"] ? YEA::EQUIP::STATUS_FONT_SIZE : 20
      contents.font.size = size
      change_color(system_color)
      draw_text(dx+4, dy, dw, line_height, Vocab::param(param_id))
      change_color(normal_color)
      dwa = (Graphics.width * 2 / 5 - 2) / 2
      draw_text(dx, dy, dwa, line_height, @actor.param(param_id).group, 2)
      reset_font_settings
      change_color(system_color)
      draw_text(dx + dwa, dy, 22, line_height, "→", 1)
      param_id += 1
      dy += line_height
      break if dy + line_height > contents.height
    end
  end
  
  #--------------------------------------------------------------------------
  # draw_custom3
  #--------------------------------------------------------------------------
  def draw_custom3
    return unless $imported["YEA-ClassSystem"]
    data = []
    for class_id in YEA::CLASS_SYSTEM::CLASS_ORDER
      next if $data_classes[class_id].nil?
      item = $data_classes[class_id]
      next unless @actor.unlocked_classes.include?(item.id) or 
        YEA::CLASS_SYSTEM::DEFAULT_UNLOCKS.include?(item.id)
      data.push(item)
    end
    dx = 0; dy = 0; class_index = 0
    for class_id in data
      item = data[class_index]
      reset_font_settings
      if item == @actor.class
        change_color(text_color(YEA::CLASS_SYSTEM::CURRENT_CLASS_COLOUR))
      elsif item == @actor.subclass
        change_color(text_color(YEA::CLASS_SYSTEM::SUBCLASS_COLOUR))
      else
        change_color(normal_color)
      end
      icon = item.icon_index
      draw_icon(icon, dx, dy)
      text = item.name
      draw_text(24, dy, contents.width-24, line_height, text)
      next if YEA::CLASS_SYSTEM::MAINTAIN_LEVELS
      level = @actor.class_level(item.id)
      contents.font.size = YEA::CLASS_SYSTEM::LEVEL_FONT_SIZE
      text = sprintf(YEA::CLASS_SYSTEM::CLASS_LEVEL, level.group)
      dwa = contents.width - (Graphics.width * 2 / 5 - 24) - 28
      draw_text(dx, dy, dwa, line_height, text, 2)
      class_index += 1
      dy += line_height
      break if dy + line_height > contents.height
    end
    dw = Graphics.width * 2 / 5 - 24
    dx = contents.width - dw; dy = 0
    param_id = 0
    8.times do
      colour = Color.new(0, 0, 0, translucent_alpha/2)
      rect = Rect.new(dx+1, dy+1, dw - 2, line_height - 2)
      contents.fill_rect(rect, colour)
      contents.font.size = YEA::CLASS_SYSTEM::PARAM_FONT_SIZE
      change_color(system_color)
      draw_text(dx+4, dy, dw, line_height, Vocab::param(param_id))
      change_color(normal_color)
      dwa = (Graphics.width * 2 / 5 - 2) / 2
      draw_text(dx, dy, dwa, line_height, @actor.param(param_id).group, 2)
      reset_font_settings
      change_color(system_color)
      draw_text(dx + dwa, dy, 22, line_height, "→", 1)
      param_id += 1
      dy += line_height
      break if dy + line_height > contents.height
    end
  end
  
end # Window_StatusItem

#==============================================================================
# ■ Scene_Status
#==============================================================================

class Scene_Status < Scene_MenuBase
  
  #--------------------------------------------------------------------------
  # start
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_command_window
    create_status_window
    create_item_window
    relocate_windows
  end
  
  #--------------------------------------------------------------------------
  # create_command_window
  #--------------------------------------------------------------------------
  def create_command_window
    wy = @help_window.height
    @command_window = Window_StatusCommand.new(0, wy)
    @command_window.viewport = @viewport
    @command_window.actor = @actor
    @command_window.help_window = @help_window
    @command_window.set_handler(:cancel,   method(:return_scene))
    @command_window.set_handler(:pagedown, method(:next_actor))
    @command_window.set_handler(:pageup,   method(:prev_actor))
    process_custom_status_commands
  end
  
  #--------------------------------------------------------------------------
  # process_custom_status_commands
  #--------------------------------------------------------------------------
  def process_custom_status_commands
    for command in YEA::STATUS::COMMANDS
      next unless YEA::STATUS::CUSTOM_STATUS_COMMANDS.include?(command[0])
      called_method = YEA::STATUS::CUSTOM_STATUS_COMMANDS[command[0]][2]
      @command_window.set_handler(command[0], method(called_method))
    end
  end
  
  #--------------------------------------------------------------------------
  # create_status_window
  #--------------------------------------------------------------------------
  def create_status_window
    wy = @help_window.height
    @status_window = Window_StatusActor.new(@command_window.width, wy)
    @status_window.viewport = @viewport
    @status_window.actor = @actor
  end
  
  #--------------------------------------------------------------------------
  # create_item_window
  #--------------------------------------------------------------------------
  def create_item_window
    dy = @command_window.y + @command_window.height
    @item_window = Window_StatusItem.new(0, dy, @command_window)
    @item_window.viewport = @viewport
    @item_window.actor = @actor
    @command_window.item_window = @item_window
  end
  
  #--------------------------------------------------------------------------
  # relocate_windows
  #--------------------------------------------------------------------------
  def relocate_windows
    return unless $imported["YEA-AceMenuEngine"]
    case Menu.help_window_location
    when 0 # Top
      @help_window.y = 0
      @command_window.y = @help_window.height
      @item_window.y = @command_window.y + @command_window.height
    when 1 # Middle
      @command_window.y = 0
      @help_window.y = @command_window.height
      @item_window.y = @help_window.y + @help_window.height
    else # Bottom
      @command_window.y = 0
      @item_window.y = @command_window.height
      @help_window.y = @item_window.y + @item_window.height
    end
    @status_window.y = @command_window.y
  end
  
  #--------------------------------------------------------------------------
  # on_actor_change
  #--------------------------------------------------------------------------
  def on_actor_change
    @command_window.actor = @actor
    @status_window.actor = @actor
    @item_window.actor = @actor
    @command_window.activate
  end
  
  #--------------------------------------------------------------------------
  # new method: command_name1
  #--------------------------------------------------------------------------
  def command_name1
    SceneManager.call(Scene_Skill)
  end
  
  #--------------------------------------------------------------------------
  # new method: command_name2
  #--------------------------------------------------------------------------
  def command_name2
    SceneManager.call(Scene_Equip)
  end
  
  #--------------------------------------------------------------------------
  # new method: command_name3
  #--------------------------------------------------------------------------
  def command_name3
    unless $imported["YEA-ClassSystem"]
      @command_window.activate
      return
    end
    SceneManager.call(Scene_Class)
  end
  
end # Scene_Status

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================