#==============================================================================
# 
# ▼ Yanfly Engine Ace - Learn Skill Engine v1.00
# -- Last Updated: 2012.01.08
# -- Level: Normal, Hard
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-LearnSkillEngine"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.08 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# For those who want an alternative for actors to learn skills outside of
# leveling, this script allows actors to learn skills through a learn skill
# menu. The actor can use acquired JP, EXP, or Gold to learn skills. Skills can
# also be hidden until certain requirements are met.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Class Notetags - These notetags go in the class notebox in the database.
# -----------------------------------------------------------------------------
# <learn skills: x>
# <learn skills: x, x>
# Sets the class to be able to learn skills x through the Learn Skills menu.
# Insert multiple of these tags to increase the number of skills learned.
# 
# -----------------------------------------------------------------------------
# Skill Notetags - These notetags go in the skill notebox in the database.
# -----------------------------------------------------------------------------
# <learn cost: x jp>
# <learn cost: x exp>
# <learn cost: x gold>
# Sets the learn for cost the skill to require x amounts of JP, x amounts of
# exp, or x amounts of gold. Only one type of cost can be used at a time. For
# JP costs, the Yanfly Engine Ace - JP Manager script must be installed.
# 
# <learn require level: x>
# Sets the skill to require the actor's current level to be x before the skill
# will show up in the skill learning window.
# 
# <learn require skill: x>
# <learn require skill: x, x>
# Sets the skill to require learning skill x (through any means) before the
# skill becomes visible in the skill learning window. Insert multiples of these
# tags to require more skills to be learned in order for the skill to show.
# 
# <learn require switch: x>
# <learn require switch: x, x>
# Sets the skill to require switch x to be ON in order for it to show in the
# skill learning window. Insert multiple switches to to increase the number of
# switches needed to be ON before the skill is shown.
# 
# <learn require eval>
#  string
#  string
# </learn require eval>
# For the more advanced users, replace string with lines of code to check for
# whether or not the skill will be shown in skill learning window. If multiple
# lines are used, they are all considered part of the same line.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
# This script is compatible with Yanfly Engine Ace - JP Manager v1.00+. The
# placement of this script relative to the JP Manager script doesn't matter.
# 
#==============================================================================

module YEA
  module LEARN_SKILL
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - General Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Adjust the general settings here for your game. These adjust how the
    # command name appears, a switch to show the Learn Command
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    COMMAND_NAME = "Learn Skills"    # Name used for Learn Skill command.
    
    # This switch will hide the "Learn" command from view if the switch is OFF.
    # The "Learn" command will be shown if the switch is ON. Set this switch to
    # 0 to not use this effect and to always have the Learn command be shown.
    SHOW_SWITCH   = 0
    
    # This adjusts the order the Skill Types appear in for the command window.
    # Any Skill Types unlisted will not be shown. 
    STYPE_ORDER = [41..999, 1..40]
    
    # For those who installed Yanfly Engine - Skill Restrictions, you can
    # choose to display warmups or cooldowns inside of the menu here.
    DRAW_WARMUP   = true        # Draw warmups for skills?
    DRAW_COOLDOWN = true        # Draw cooldowns for skills?
    
    #-------------------------------------------------------------------------
    # - Default Cost -
    #-------------------------------------------------------------------------
    # This sets the default costs for all skills. If the JP script isn't
    # installed, the type will become :exp instead.
    # 
    # Cost Type       Description
    #  :jp            - Requires YEA - JP Manager.
    #  :exp           - Makes skill cost EXP.
    #  :gold          - Makes skill cost gold.
    #-------------------------------------------------------------------------
    DEFAULT_COST = 100          # Sets the default cost of a skill.
    DEFAULT_TYPE = :jp          # Sets the default cost type.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Learn Window Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These settings adjust the Learn Window's visual appearance. Adjust the
    # way empty text appears, EXP cost suffixes appear, Learned text appears,
    # font sizes, and cost colours here.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    EMPTY_TEXT     = "-"        # Text if no restricts used for the skill.
    EXP_TEXT       = "EXP"      # Text used for EXP costs.
    LEARNED_TEXT   = "Learned"  # Text to indicate skill has been learned.
    LEARNED_SIZE   = 20         # Font size used for learned skill text.
    COLOUR_JP      = 24         # Text colour used for JP Cost.
    COLOUR_EXP     =  5         # Text colour used for EXP Cost.
    COLOUR_GOLD    = 21         # Text colour used for Gold Cost.
    COST_SIZE      = 20         # Font size used for skill costs.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Cost Window Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # When a skill is selected to be learned, the cost window appears. Adjust
    # the settings here to choose how your game's cost window looks. Change the
    # maximum number of rows, the gold icon used for gold costs, the gold text,
    # the learn skill text, the cancel text, and the cancel icon here.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    MAXIMUM_ROWS      = 8               # Maximum number of rows displayed.
    GOLD_ICON         = 361             # Icon used for gold costs.
    GOLD_TEXT         = "Gold Cost"     # Text used for gold costs.
    LEARN_SKILL_TEXT  = "Learn %s?"     # Text used to learn skill.
    LEARN_CANCEL_TEXT = "Cancel"        # Text used for do not learn.
    CANCEL_ICON       = 187             # Icon used for cancel.
    
  end # LEARN_SKILL
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module LEARN_SKILL
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
    STYPE_ORDER = convert_integer_array(STYPE_ORDER)
  end # LEARN_SKILL
  module REGEXP
  module CLASS
    
    LEARN_SKILLS = /<(?:LEARN_SKILLS|learn skills):[ ](\d+(?:\s*,\s*\d+)*)>/i
    
  end # CLASS
  module SKILL
    
    LEARN_COST = /<(?:LEARN_COST|learn cost):[ ](.*)>/i
    LEARN_REQUIRE_LEVEL = 
      /<(?:LEARN_REQUIRE_LEVEL|learn require level):[ ](\d+)>/i
    LEARN_REQUIRE_SKILL =
      /<(?:LEARN_REQUIRE_SKILL|learn require skill):[ ](\d+(?:\s*,\s*\d+)*)>/i
    LEARN_REQUIRE_SWITCH =
      /<(?:LEARN_REQUIRE_SWITCH|learn require switch):[ ](\d+(?:\s*,\s*\d+)*)>/i
    LEARN_REQUIRE_EVAL_ON  = /<(?:LEARN_REQUIRE_EVAL|learn require eval)>/i
    LEARN_REQUIRE_EVAL_OFF = /<\/(?:LEARN_REQUIRE_EVAL|learn require eval)>/i
    
  end # SKILL
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
# ■ Icon
#==============================================================================

module Icon
  
  #--------------------------------------------------------------------------
  # self.cancel
  #--------------------------------------------------------------------------
  def self.cancel
    return YEA::LEARN_SKILL::CANCEL_ICON
  end
  
  #--------------------------------------------------------------------------
  # self.learn_skill_gold
  #--------------------------------------------------------------------------
  def self.learn_skill_gold
    return YEA::LEARN_SKILL::GOLD_ICON
  end
  
end # Icon

#==============================================================================
# ■ Switch
#==============================================================================

module Switch
  
  #--------------------------------------------------------------------------
  # self.show_learn_skill
  #--------------------------------------------------------------------------
  def self.show_learn_skill
    return true if YEA::LEARN_SKILL::SHOW_SWITCH <= 0
    return $game_switches[YEA::LEARN_SKILL::SHOW_SWITCH]
  end
  
end # Switch

#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_lse load_database; end
  def self.load_database
    load_database_lse
    load_notetags_lse
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_lse
  #--------------------------------------------------------------------------
  def self.load_notetags_lse
    groups = [$data_classes, $data_skills]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_lse
      end
    end
  end
  
end # DataManager

#==============================================================================
# ■ RPG::Class
#==============================================================================

class RPG::Class < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :learn_skills
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_lse
  #--------------------------------------------------------------------------
  def load_notetags_lse
    @learn_skills = []
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::CLASS::LEARN_SKILLS
        $1.scan(/\d+/).each { |num| 
        @learn_skills.push(num.to_i) if num.to_i > 0 }
      end
    } # self.note.split
    #---
  end
  
end # RPG::Class

#==============================================================================
# ■ RPG::Skill
#==============================================================================

class RPG::Skill < RPG::UsableItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :learn_cost
  attr_accessor :learn_require_level
  attr_accessor :learn_require_skill
  attr_accessor :learn_require_switch
  attr_accessor :learn_require_eval
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_lse
  #--------------------------------------------------------------------------
  def load_notetags_lse
    @learn_cost = [YEA::LEARN_SKILL::DEFAULT_COST]
    @learn_cost.push(YEA::LEARN_SKILL::DEFAULT_TYPE)
    @learn_require_level = 0
    @learn_require_skill = []
    @learn_require_switch = []
    @learn_require_eval_on = false
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::SKILL::LEARN_COST
        case $1.upcase
        when /(\d+)[ ]JP/i
          next unless $imported["YEA-JPManager"]
          @learn_cost = [$1.to_i, :jp]
        when /(\d+)[ ]EXP/i
          @learn_cost = [$1.to_i, :exp]
        when /(\d+)[ ]GOLD/i
          @learn_cost = [$1.to_i, :gold]
        end
      #---
      when YEA::REGEXP::SKILL::LEARN_REQUIRE_LEVEL
        @learn_require_level = $1.to_i
      when YEA::REGEXP::SKILL::LEARN_REQUIRE_SKILL
        $1.scan(/\d+/).each { |num| 
        @learn_require_skill.push(num.to_i) if num.to_i > 0 }
      when YEA::REGEXP::SKILL::LEARN_REQUIRE_SWITCH
        $1.scan(/\d+/).each { |num| 
        @learn_require_switch.push(num.to_i) if num.to_i > 0 }
      #---
      when YEA::REGEXP::SKILL::LEARN_REQUIRE_EVAL_ON
        @learn_require_eval_on = true
      when YEA::REGEXP::SKILL::LEARN_REQUIRE_EVAL_OFF
        @learn_require_eval_on = false
      else
        next unless @learn_require_eval_on
        @learn_require_eval = "" if @learn_require_eval.nil?
        @learn_require_eval += line.to_s
      #---
      end
    } # self.note.split
    #---
    if !$imported["YEA-JPManager"] && @learn_cost[1] == :jp
      @learn_cost[1] = :exp
    end
  end
  
end # RPG::Skill

#==============================================================================
# ■ Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  
  #--------------------------------------------------------------------------
  # alias method: skills
  #--------------------------------------------------------------------------
  alias game_actor_skills_lse skills
  def skills
    btest_add_learn_skills
    game_actor_skills_lse
  end
  
  #--------------------------------------------------------------------------
  # new method: btest_add_learn_skills
  #--------------------------------------------------------------------------
  def btest_add_learn_skills
    return unless $BTEST
    for skill_id in self.class.learn_skills; learn_skill(skill_id); end
  end
  
  #--------------------------------------------------------------------------
  # new method: exp_class
  #--------------------------------------------------------------------------
  def exp_class(class_id)
    @exp[class_id] = 0 if @exp[class_id].nil?
    return @exp[class_id]
  end
  
  #--------------------------------------------------------------------------
  # lose_exp_class
  #--------------------------------------------------------------------------
  def lose_exp_class(value, class_id)
    exp = exp_class(class_id) - value
    change_exp_class(exp, class_id)
  end
  
  #--------------------------------------------------------------------------
  # change_exp_class
  #--------------------------------------------------------------------------
  def change_exp_class(exp, class_id)
    return change_exp(exp, false) if class_id == @class_id
    @exp[class_id] = [exp, 0].max
  end
  
end # Game_Actor

#==============================================================================
# ■ Window_SkillCommand
#==============================================================================

class Window_SkillCommand < Window_Command
  
  #--------------------------------------------------------------------------
  # alias method: make_command_list
  #--------------------------------------------------------------------------
  alias window_skillcommand_make_command_list_lse make_command_list
  def make_command_list
    window_skillcommand_make_command_list_lse
    return if @actor.nil?
    add_learn_skill_command unless $imported["YEA-SkillMenu"]
  end
  
  #--------------------------------------------------------------------------
  # new method: add_learn_skill_command
  #--------------------------------------------------------------------------
  def add_learn_skill_command
    return unless Switch.show_learn_skill
    name = YEA::LEARN_SKILL::COMMAND_NAME
    add_command(name, :learn_skill, true, @actor.added_skill_types[0])
  end
  
end # Window_SkillCommand

#==============================================================================
# ■ Window_LearnSkillCommand
#==============================================================================

class Window_LearnSkillCommand < Window_Command
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_reader   :skill_window
  
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
  # visible_line_number
  #--------------------------------------------------------------------------
  def visible_line_number; return 4; end
  
  #--------------------------------------------------------------------------
  # actor=
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
    select(item_max - 1) if index >= item_max
  end
  
  #--------------------------------------------------------------------------
  # make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    return if @actor.nil?
    make_unlocked_class_skill_types
    correct_unlocked_class_learned_skills
    for stype_id in YEA::LEARN_SKILL::STYPE_ORDER
      next unless include?(stype_id)
      name = $data_system.skill_types[stype_id]
      add_command(name, :skill, true, stype_id)
    end
  end
  
  #--------------------------------------------------------------------------
  # make_unlocked_class_skill_types
  #--------------------------------------------------------------------------
  def make_unlocked_class_skill_types
    return unless $imported["YEA-ClassSystem"]
    @unlocked_types = []
    unlocked_classes = @actor.unlocked_classes.clone
    unlocked_classes |= YEA::CLASS_SYSTEM::DEFAULT_UNLOCKS
    for class_id in unlocked_classes
      next if $data_classes[class_id].nil?
      for feature in $data_classes[class_id].features
        next unless feature.code == 41
        @unlocked_types.push(feature.data_id)
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # correct_unlocked_class_learned_skills
  #--------------------------------------------------------------------------
  def correct_unlocked_class_learned_skills
    return unless $imported["YEA-ClassSystem"]
    unlocked_classes = @actor.unlocked_classes.clone
    unlocked_classes |= YEA::CLASS_SYSTEM::DEFAULT_UNLOCKS
    for class_id in unlocked_classes
      @actor.learn_class_skills(class_id)
    end
  end
  
  #--------------------------------------------------------------------------
  # include?
  #--------------------------------------------------------------------------
  def include?(stype_id)
    return true if @actor.added_skill_types.include?(stype_id)
    if $imported["YEA-ClassSystem"]
      return true if @unlocked_types.include?(stype_id)
    end
    return false
  end
  
  #--------------------------------------------------------------------------
  # update
  #--------------------------------------------------------------------------
  def update
    super
    @skill_window.stype_id = current_ext if @skill_window
  end
  
  #--------------------------------------------------------------------------
  # skill_window=
  #--------------------------------------------------------------------------
  def skill_window=(skill_window)
    @skill_window = skill_window
    update
  end
  
end # Window_LearnSkillCommand

#==============================================================================
# ■ Window_LearnSkillList
#==============================================================================

class Window_LearnSkillList < Window_SkillList
  
  #--------------------------------------------------------------------------
  # col_max
  #--------------------------------------------------------------------------
  def col_max; return 1; end
  
  #--------------------------------------------------------------------------
  # select_last
  #--------------------------------------------------------------------------
  def select_last; select(0); end
  
  #--------------------------------------------------------------------------
  # actor=
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    super(actor)
    make_learn_skills_list
  end
  
  #--------------------------------------------------------------------------
  # make_learn_skills_list
  #--------------------------------------------------------------------------
  def make_learn_skills_list
    @learn_skills = []
    @skill_classes = {}
    return if @actor.nil?
    for skill_id in @actor.class.learn_skills
      next if $data_skills[skill_id].nil?
      next if @learn_skills.include?($data_skills[skill_id])
      skill = $data_skills[skill_id]
      @learn_skills.push(skill)
      @skill_classes[skill] = [] if @skill_classes[skill].nil?
      @skill_classes[skill].push(@actor.class.id)
    end
    make_unlocked_class_skills
  end
  
  #--------------------------------------------------------------------------
  # make_unlocked_class_skills
  #--------------------------------------------------------------------------
  def make_unlocked_class_skills
    return unless $imported["YEA-ClassSystem"]
    @unlocked_types = []
    unlocked_classes = @actor.unlocked_classes.clone
    unlocked_classes |= YEA::CLASS_SYSTEM::DEFAULT_UNLOCKS
    for class_id in unlocked_classes
      next if $data_classes[class_id].nil?
      for skill_id in $data_classes[class_id].learn_skills
        next if $data_skills[skill_id].nil?
        skill = $data_skills[skill_id]
        @learn_skills.push(skill) unless @learn_skills.include?(skill)
        @skill_classes[skill] = [] if @skill_classes[skill].nil?
        @skill_classes[skill] |= [class_id]
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # skill_classes
  #--------------------------------------------------------------------------
  def skill_classes(skill)
    return @skill_classes[skill]
  end
  
  #--------------------------------------------------------------------------
  # make_item_list
  #--------------------------------------------------------------------------
  def make_item_list
    return if @learn_skills.nil?
    @data = @learn_skills.select {|skill| include?(skill) }
  end
  
  #--------------------------------------------------------------------------
  # include?
  #--------------------------------------------------------------------------
  def include?(item)
    return false if item.nil?
    return false unless meet_requirements?(item)
    return item.stype_id == @stype_id
  end
  
  #--------------------------------------------------------------------------
  # meet_requirements?
  #--------------------------------------------------------------------------
  def meet_requirements?(item)
    return false if @actor.nil?
    return false unless meet_level_requirements?(item)
    return false unless meet_skill_requirements?(item)
    return false unless meet_switch_requirements?(item)
    return false unless meet_eval_requirements?(item)
    return true
  end
  
  #--------------------------------------------------------------------------
  # meet_level_requirements?
  #--------------------------------------------------------------------------
  def meet_level_requirements?(item)
    return @actor.level >= item.learn_require_level
  end
  
  #--------------------------------------------------------------------------
  # meet_skill_requirements?
  #--------------------------------------------------------------------------
  def meet_skill_requirements?(item)
    for skill_id in item.learn_require_skill
      next if $data_skills[skill_id].nil?
      return false unless @actor.skill_learn?($data_skills[skill_id])
    end
    return true
  end
  
  #--------------------------------------------------------------------------
  # meet_switch_requirements?
  #--------------------------------------------------------------------------
  def meet_switch_requirements?(item)
    for switch_id in item.learn_require_switch
      return false unless $game_switches[switch_id]
    end
    return true
  end
  
  #--------------------------------------------------------------------------
  # meet_eval_requirements?
  #--------------------------------------------------------------------------
  def meet_eval_requirements?(item)
    return true if item.learn_require_eval.nil?
    return eval(item.learn_require_eval)
  end
  
  #--------------------------------------------------------------------------
  # enable?
  #--------------------------------------------------------------------------
  def enable?(skill)
    return false if skill.nil?
    return false unless enabled_jp?(skill)
    return false unless enabled_exp?(skill)
    return false unless enabled_gold?(skill)
    return !@actor.skill_learn?(skill)
  end
  
  #--------------------------------------------------------------------------
  # enabled_jp?
  #--------------------------------------------------------------------------
  def enabled_jp?(skill)
    return true if skill.learn_cost[1] != :jp
    cost = skill.learn_cost[0]
    for class_id in @skill_classes[skill]
      return true if @actor.jp(class_id) >= cost
    end
    return false
  end
  
  #--------------------------------------------------------------------------
  # enabled_exp?
  #--------------------------------------------------------------------------
  def enabled_exp?(skill)
    return true if skill.learn_cost[1] != :exp
    cost = skill.learn_cost[0]
    for class_id in @skill_classes[skill]
      return true if @actor.exp_class(class_id) >= cost
    end
    return false
  end
  
  #--------------------------------------------------------------------------
  # enabled_gold?
  #--------------------------------------------------------------------------
  def enabled_gold?(skill)
    return true if skill.learn_cost[1] != :gold
    cost = skill.learn_cost[0]
    return $game_party.gold >= cost
  end
  
  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    skill = @data[index]
    return if skill.nil?
    rect = item_rect(index)
    rect.width = (contents.width - spacing) / 2 - 4
    draw_item_name(skill, rect.x, rect.y, enable?(skill), rect.width - 24)
    draw_skill_cost(rect, skill)
    draw_restriction_info(skill, index)
    draw_learn_cost(skill, index)
  end
  
  #--------------------------------------------------------------------------
  # skill_restriction?
  #--------------------------------------------------------------------------
  def skill_restriction?(index)
    return false
  end
  
  #--------------------------------------------------------------------------
  # draw_restriction_info
  #--------------------------------------------------------------------------
  def draw_restriction_info(skill, index)
    return unless $imported["YEA-SkillRestrictions"]
    rect = item_rect(index)
    rect.x = contents.width / 2
    rect.width /= 2
    rect.width /= 3
    rect.width -= 8
    draw_skill_warmup(skill, rect)
    rect.x += rect.width + 4
    draw_skill_cooldown(skill, rect)
  end
  
  #--------------------------------------------------------------------------
  # draw_skill_warmup
  #--------------------------------------------------------------------------
  def draw_skill_warmup(skill, rect)
    return unless YEA::LEARN_SKILL::DRAW_WARMUP
    enabled = enable?(skill)
    enabled = false if skill.warmup <= 0
    change_color(warmup_colour, enabled)
    icon = Icon.warmup
    if icon > 0
      draw_icon(icon, rect.x + rect.width-24, rect.y, enable?(skill))
      rect.width -= 24
    end
    contents.font.size = YEA::SKILL_RESTRICT::WARMUP_SIZE
    value = skill.warmup > 0 ? skill.warmup.group : empty_text
    text = sprintf(YEA::SKILL_RESTRICT::WARMUP_SUFFIX, value)
    draw_text(rect, text, 2)
    reset_font_settings
  end
  
  #--------------------------------------------------------------------------
  # draw_skill_cooldown
  #--------------------------------------------------------------------------
  def draw_skill_cooldown(skill, rect)
    return unless YEA::LEARN_SKILL::DRAW_COOLDOWN
    enabled = enable?(skill)
    enabled = false if skill.cooldown <= 0
    change_color(cooldown_colour, enabled)
    icon = Icon.cooldown
    if icon > 0
      draw_icon(icon, rect.x + rect.width-24, rect.y, enable?(skill))
      rect.width -= 24
    end
    contents.font.size = YEA::SKILL_RESTRICT::COOLDOWN_SIZE
    value = skill.cooldown > 0 ? skill.cooldown.group : empty_text
    text = sprintf(YEA::SKILL_RESTRICT::COOLDOWN_SUFFIX, value)
    draw_text(rect, text, 2)
    reset_font_settings
  end
  
  #--------------------------------------------------------------------------
  # empty_text
  #--------------------------------------------------------------------------
  def empty_text
    return YEA::LEARN_SKILL::EMPTY_TEXT
  end
  
  #--------------------------------------------------------------------------
  # draw_learn_cost
  #--------------------------------------------------------------------------
  def draw_learn_cost(skill, index)
    rect = item_rect(index)
    rect.width -= 4
    if @actor.skill_learn?(skill)
      draw_learned_skill(rect)
    else
      draw_learn_skill_cost(skill, rect)
    end
    reset_font_settings
  end
  
  #--------------------------------------------------------------------------
  # draw_learned_skill
  #--------------------------------------------------------------------------
  def draw_learned_skill(rect)
    contents.font.size = YEA::LEARN_SKILL::LEARNED_SIZE
    change_color(normal_color)
    draw_text(rect, YEA::LEARN_SKILL::LEARNED_TEXT, 2)
  end
  
  #--------------------------------------------------------------------------
  # draw_learn_skill_cost
  #--------------------------------------------------------------------------
  def draw_learn_skill_cost(skill, rect)
    case skill.learn_cost[1]
    when :jp
      return unless $imported["YEA-JPManager"]
      draw_jp_cost(skill, rect)
    when :exp
      draw_exp_cost(skill, rect)
    when :gold
      draw_gold_cost(skill, rect)
    else; return
    end
  end
  
  #--------------------------------------------------------------------------
  # draw_jp_cost
  #--------------------------------------------------------------------------
  def draw_jp_cost(skill, rect)
    enabled = enabled_jp?(skill)
    if Icon.jp > 0
      draw_icon(Icon.jp, rect.x + rect.width - 24, rect.y, enabled)
      rect.width -= 24
    end
    contents.font.size = YEA::LEARN_SKILL::COST_SIZE
    change_color(system_color, enabled)
    draw_text(rect, Vocab::jp, 2)
    rect.width -= text_size(Vocab::jp).width
    cost = skill.learn_cost[0]
    text = cost.group
    change_color(text_color(YEA::LEARN_SKILL::COLOUR_JP), enabled)
    draw_text(rect, text, 2)
  end
  
  #--------------------------------------------------------------------------
  # draw_exp_cost
  #--------------------------------------------------------------------------
  def draw_exp_cost(skill, rect)
    enabled = enabled_exp?(skill)
    contents.font.size = YEA::LEARN_SKILL::COST_SIZE
    change_color(system_color, enabled)
    draw_text(rect, YEA::LEARN_SKILL::EXP_TEXT, 2)
    rect.width -= text_size(YEA::LEARN_SKILL::EXP_TEXT).width
    cost = skill.learn_cost[0]
    text = cost.group
    change_color(text_color(YEA::LEARN_SKILL::COLOUR_EXP), enabled)
    draw_text(rect, text, 2)
  end
  
  #--------------------------------------------------------------------------
  # draw_gold_cost
  #--------------------------------------------------------------------------
  def draw_gold_cost(skill, rect)
    enabled = enabled_jp?(skill)
    contents.font.size = YEA::LEARN_SKILL::COST_SIZE
    change_color(system_color, enabled)
    draw_text(rect, Vocab::currency_unit, 2)
    rect.width -= text_size(Vocab::currency_unit).width
    cost = skill.learn_cost[0]
    text = cost.group
    change_color(text_color(YEA::LEARN_SKILL::COLOUR_GOLD), enabled)
    draw_text(rect, text, 2)
  end
  
end # Window_LearnSkillList

#==============================================================================
# ■ Window_LearnSkillCostBack
#==============================================================================

class Window_LearnSkillCostBack < Window_Base
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(item_window)
    dw = Graphics.width * 3 / 4
    dx = (Graphics.width - dw) / 2
    super(dx, 0, dw, fitting_height(2))
    self.openness = 0
    self.back_opacity = 255
    @front_window = nil
    @item_window = item_window
    @skill = nil
  end
  
  #--------------------------------------------------------------------------
  # reveal
  #--------------------------------------------------------------------------
  def reveal(skill, skill_classes)
    @skill = skill
    return if @skill.nil?
    case @skill.learn_cost[1]
    when :gold
      self.height = fitting_height(3)
    else
      maximum = [skill_classes.size, YEA::LEARN_SKILL::MAXIMUM_ROWS].min
      self.height = fitting_height(maximum + 2)
    end
    create_contents
    self.y = (Graphics.height - self.height) / 2
    refresh
    open
  end
  
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    reset_font_settings
    draw_learn_skill_text
    rect = Rect.new(0, 0, contents.width - 4, line_height)
    draw_learn_skill_cost(@skill, rect)
  end
  
  #--------------------------------------------------------------------------
  # draw_learn_skill_text
  #--------------------------------------------------------------------------
  def draw_learn_skill_text
    name = sprintf("\eI[%d]%s", @skill.icon_index, @skill.name)
    fmt = YEA::LEARN_SKILL::LEARN_SKILL_TEXT
    text = sprintf(fmt, name)
    draw_text_ex(4, 0, text)
  end
  
  #--------------------------------------------------------------------------
  # draw_learn_skill_cost
  #--------------------------------------------------------------------------
  def draw_learn_skill_cost(skill, rect)
    case skill.learn_cost[1]
    when :jp
      return unless $imported["YEA-JPManager"]
      draw_jp_cost(skill, rect)
    when :exp
      draw_exp_cost(skill, rect)
    when :gold
      draw_gold_cost(skill, rect)
    else; return
    end
  end
  
  #--------------------------------------------------------------------------
  # draw_jp_cost
  #--------------------------------------------------------------------------
  def draw_jp_cost(skill, rect)
    enabled = true
    if Icon.jp > 0
      draw_icon(Icon.jp, rect.x + rect.width - 24, rect.y, enabled)
      rect.width -= 24
    end
    contents.font.size = YEA::LEARN_SKILL::COST_SIZE
    change_color(system_color, enabled)
    draw_text(rect, Vocab::jp, 2)
    rect.width -= text_size(Vocab::jp).width
    cost = skill.learn_cost[0]
    text = cost.group
    change_color(text_color(YEA::LEARN_SKILL::COLOUR_JP), enabled)
    draw_text(rect, text, 2)
  end
  
  #--------------------------------------------------------------------------
  # draw_exp_cost
  #--------------------------------------------------------------------------
  def draw_exp_cost(skill, rect)
    enabled = true
    contents.font.size = YEA::LEARN_SKILL::COST_SIZE
    change_color(system_color, enabled)
    draw_text(rect, YEA::LEARN_SKILL::EXP_TEXT, 2)
    rect.width -= text_size(YEA::LEARN_SKILL::EXP_TEXT).width
    cost = skill.learn_cost[0]
    text = cost.group
    change_color(text_color(YEA::LEARN_SKILL::COLOUR_EXP), enabled)
    draw_text(rect, text, 2)
  end
  
  #--------------------------------------------------------------------------
  # draw_gold_cost
  #--------------------------------------------------------------------------
  def draw_gold_cost(skill, rect)
    enabled = true
    contents.font.size = YEA::LEARN_SKILL::COST_SIZE
    change_color(system_color, enabled)
    draw_text(rect, Vocab::currency_unit, 2)
    rect.width -= text_size(Vocab::currency_unit).width
    cost = skill.learn_cost[0]
    text = cost.group
    change_color(text_color(YEA::LEARN_SKILL::COLOUR_GOLD), enabled)
    draw_text(rect, text, 2)
  end
  
end # Window_LearnSkillCostBack

#==============================================================================
# ■ Window_LearnSkillCostFront
#==============================================================================

class Window_LearnSkillCostFront < Window_Command
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(item_window, cost_window)
    super((Graphics.width - window_width) / 2, 0)
    self.openness = 0
    self.opacity = 0
    @item_window = item_window
    @cost_window = cost_window
    @skill = nil
    @actor = nil
    deactivate
  end
  
  #--------------------------------------------------------------------------
  # window_width
  #--------------------------------------------------------------------------
  def window_width; return Graphics.width * 3 / 4; end
  
  #--------------------------------------------------------------------------
  # skill_class
  #--------------------------------------------------------------------------
  def skill_class
    return @skill_classes.nil? ? nil : @skill_classes[index]
  end
  
  #--------------------------------------------------------------------------
  # reveal
  #--------------------------------------------------------------------------
  def reveal(skill, skill_classes, actor)
    @skill = skill
    @skill_classes = skill_classes.clone
    @actor = actor
    return if @skill.nil?
    case @skill.learn_cost[1]
    when :gold
      self.height = fitting_height(2)
    else
      maximum = [skill_classes.size, YEA::LEARN_SKILL::MAXIMUM_ROWS].min
      self.height = fitting_height(maximum + 1)
    end
    create_contents
    self.y = @cost_window.y + line_height
    refresh
    select(0)
    open
    activate
  end
  
  #--------------------------------------------------------------------------
  # make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    return if @skill_classes.nil?
    if @skill.learn_cost[1] == :gold
      add_command("GOLD", :gold, true)
      add_command(YEA::LEARN_SKILL::LEARN_CANCEL_TEXT, :cancel, true)
      return
    end
    for class_id in @skill_classes
      name = $data_classes[class_id].name
      add_command(name, :class, enabled?(class_id), class_id)
    end
    add_command(YEA::LEARN_SKILL::LEARN_CANCEL_TEXT, :cancel, true)
  end
  
  #--------------------------------------------------------------------------
  # enabled?
  #--------------------------------------------------------------------------
  def enabled?(class_id)
    cost = @skill.learn_cost[0]
    case @skill.learn_cost[1]
    when :jp
      return @actor.jp(class_id) >= cost
    when :exp
      return @actor.exp_class(class_id) >= cost
    end
    return true
  end
  
  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    reset_font_settings
    rect = item_rect(index)
    rect.x += 24
    rect.width -= 28
    return draw_cancel_text(index, rect) if @list[index][:symbol] == :cancel
    draw_class_name(index, rect) if @skill.learn_cost[1] != :gold
    draw_party_gold(rect) if @skill.learn_cost[1] == :gold
    draw_learn_skill_cost(@skill, rect, index)
  end
  
  #--------------------------------------------------------------------------
  # draw_cancel_text
  #--------------------------------------------------------------------------
  def draw_cancel_text(index, rect)
    draw_icon(Icon.cancel, rect.x, rect.y)
    text = command_name(index)
    draw_text(rect.x+24, rect.y, rect.width-24, line_height, text)
  end
  
  #--------------------------------------------------------------------------
  # draw_class_name
  #--------------------------------------------------------------------------
  def draw_class_name(index, rect)
    class_id = @list[index][:ext]
    return if $data_classes[class_id].nil?
    enabled = enabled?(class_id)
    if $imported["YEA-ClassSystem"]
      draw_icon($data_classes[class_id].icon_index, rect.x, rect.y, enabled)
    end
    rect.x += 24
    rect.width -= 24
    change_color(normal_color, enabled)
    draw_text(rect, $data_classes[class_id].name)
  end
  
  #--------------------------------------------------------------------------
  # draw_class_name
  #--------------------------------------------------------------------------
  def draw_party_gold(rect)
    enabled = true
    draw_icon(Icon.learn_skill_gold, rect.x, rect.y)
    rect.x += 24
    rect.width -= 24
    change_color(normal_color, enabled)
    draw_text(rect, YEA::LEARN_SKILL::GOLD_TEXT)
  end
  
  #--------------------------------------------------------------------------
  # draw_learn_skill_cost
  #--------------------------------------------------------------------------
  def draw_learn_skill_cost(skill, rect, index)
    case skill.learn_cost[1]
    when :jp
      return unless $imported["YEA-JPManager"]
      draw_jp_cost(skill, rect, index)
    when :exp
      draw_exp_cost(skill, rect, index)
    when :gold
      draw_gold_cost(skill, rect)
    else; return
    end
  end
  
  #--------------------------------------------------------------------------
  # draw_jp_cost
  #--------------------------------------------------------------------------
  def draw_jp_cost(skill, rect, index)
    enabled = enabled?(@list[index][:ext])
    if Icon.jp > 0
      draw_icon(Icon.jp, rect.x + rect.width - 24, rect.y, enabled)
      rect.width -= 24
    end
    contents.font.size = YEA::LEARN_SKILL::COST_SIZE
    change_color(system_color, enabled)
    draw_text(rect, Vocab::jp, 2)
    rect.width -= text_size(Vocab::jp).width
    cost = @actor.jp(@list[index][:ext])
    text = cost.group
    change_color(text_color(YEA::LEARN_SKILL::COLOUR_JP), enabled)
    draw_text(rect, text, 2)
  end
  
  #--------------------------------------------------------------------------
  # draw_exp_cost
  #--------------------------------------------------------------------------
  def draw_exp_cost(skill, rect, index)
    enabled = enabled?(@list[index][:ext])
    contents.font.size = YEA::LEARN_SKILL::COST_SIZE
    change_color(system_color, enabled)
    draw_text(rect, YEA::LEARN_SKILL::EXP_TEXT, 2)
    rect.width -= text_size(YEA::LEARN_SKILL::EXP_TEXT).width
    cost = @actor.exp_class(@list[index][:ext])
    text = cost.group
    change_color(text_color(YEA::LEARN_SKILL::COLOUR_EXP), enabled)
    draw_text(rect, text, 2)
  end
  
  #--------------------------------------------------------------------------
  # draw_gold_cost
  #--------------------------------------------------------------------------
  def draw_gold_cost(skill, rect)
    enabled = $game_party.gold >= skill.learn_cost[0]
    contents.font.size = YEA::LEARN_SKILL::COST_SIZE
    change_color(system_color, enabled)
    draw_text(rect, Vocab::currency_unit, 2)
    rect.width -= text_size(Vocab::currency_unit).width
    cost = $game_party.gold
    text = cost.group
    change_color(text_color(YEA::LEARN_SKILL::COLOUR_GOLD), enabled)
    draw_text(rect, text, 2)
  end
  
end # Window_LearnSkillCostFront

#==============================================================================
# ■ Scene_Skill
#==============================================================================

class Scene_Skill < Scene_ItemBase
  
  #--------------------------------------------------------------------------
  # alias method: create_command_window
  #--------------------------------------------------------------------------
  alias scene_skill_create_command_window_lse create_command_window
  def create_command_window
    scene_skill_create_command_window_lse
    @command_window.set_handler(:learn_skill, method(:command_learn_skill))
  end
  
  #--------------------------------------------------------------------------
  # new method: command_learn_skill
  #--------------------------------------------------------------------------
  def command_learn_skill
    SceneManager.call(Scene_LearnSkill)
  end
  
end # Scene_Skill

#==============================================================================
# ■ Scene_LearnSkill
#==============================================================================

class Scene_LearnSkill < Scene_Skill
  
  #--------------------------------------------------------------------------
  # start
  #--------------------------------------------------------------------------
  def start
    super
    create_cost_windows
  end
  
  #--------------------------------------------------------------------------
  # create_command_window
  #--------------------------------------------------------------------------
  def create_command_window
    wy = @help_window.height
    @command_window = Window_LearnSkillCommand.new(0, wy)
    @command_window.viewport = @viewport
    @command_window.help_window = @help_window
    @command_window.actor = @actor
    @command_window.set_handler(:skill,    method(:command_skill))
    @command_window.set_handler(:cancel,   method(:return_scene))
    @command_window.set_handler(:pagedown, method(:next_actor))
    @command_window.set_handler(:pageup,   method(:prev_actor))
  end
  
  #--------------------------------------------------------------------------
  # create_item_window
  #--------------------------------------------------------------------------
  def create_item_window
    wx = 0
    wy = @status_window.y + @status_window.height
    ww = Graphics.width
    wh = Graphics.height - wy
    @item_window = Window_LearnSkillList.new(wx, wy, ww, wh)
    @item_window.actor = @actor
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))
    @command_window.skill_window = @item_window
  end
  
  #--------------------------------------------------------------------------
  # create_cost_windows
  #--------------------------------------------------------------------------
  def create_cost_windows
    @cost_window = Window_LearnSkillCostBack.new(@item_window)
    @cost_front = Window_LearnSkillCostFront.new(@item_window, @cost_window)
    @cost_window.viewport = @viewport
    @cost_front.viewport = @viewport
    @cost_front.set_handler(:ok, method(:on_cost_ok))
    @cost_front.set_handler(:cancel, method(:on_cost_cancel))
  end
  
  #--------------------------------------------------------------------------
  # on_item_ok
  #--------------------------------------------------------------------------
  def on_item_ok
    skill = @item_window.item
    @cost_window.reveal(skill, @item_window.skill_classes(skill))
    @cost_front.reveal(skill, @item_window.skill_classes(skill), @actor)
  end
  
  #--------------------------------------------------------------------------
  # on_cost_ok
  #--------------------------------------------------------------------------
  def on_cost_ok
    Sound.play_use_skill
    skill = @item_window.item
    @actor.learn_skill(skill.id)
    cost = skill.learn_cost[0]
    case skill.learn_cost[1]
    when :jp
      @actor.lose_jp(cost, @cost_front.skill_class)
    when :exp
      @actor.lose_exp_class(cost, @cost_front.skill_class)
    when :gold
      $game_party.lose_gold(cost)
    end
    on_cost_cancel
    refresh_windows
  end
  
  #--------------------------------------------------------------------------
  # on_cost_cancel
  #--------------------------------------------------------------------------
  def on_cost_cancel
    @cost_front.close
    @cost_window.close
    @item_window.activate
  end
  
  #--------------------------------------------------------------------------
  # refresh_windows
  #--------------------------------------------------------------------------
  def refresh_windows
    @item_window.refresh
    @status_window.refresh
  end
  
end # Scene_LearnSkill

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================