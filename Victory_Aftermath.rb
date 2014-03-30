#==============================================================================
# 
# Å• Yanfly Engine Ace - Victory Aftermath v1.04
# -- Last Updated: 2014.03.019
# -- Level: Easy, Normal, Hard
# -- Requires: n/a
# -- Special Thanks: Yami for Bug Fixes.
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-VictoryAftermath"] = true

#==============================================================================
# Å• Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2014.03.19 - Fixed a bug where if the battle ends with a stat buff/debuff and
#              it will display the wrong parameters.
# 2012.01.07 - Compatibility Update: JP Manager
# 2012.01.01 - Bug Fixed: Quote tags were mislabeled.
# 2011.12.26 - Compatibility Update: Command Autobattle
# 2011.12.16 - Started Script and Finished.
# 
#==============================================================================
# Å• Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# At the end of each battle, RPG Maker VX Ace by default shows text saying that
# the party has gained so-and-so EXP while this person leveled up and your
# party happened to find these drops. This script changes that text into
# something more visual for your players to see. Active battle members will be
# seen gaining EXP, any kind of level up changes, and a list of the items
# obtained through drops.
# 
#==============================================================================
# Å• Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below Å• Materials/ëfçﬁ but above Å• Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Actor Notetags - These notetags go in the actors notebox in the database.
# -----------------------------------------------------------------------------
# <win quotes>
#  string
#  string
# </win quotes>
# Sets the win quote for the actor. The strings are continuous and can use
# text codes. Use \n for a line break. Type in what you want the actor to say
# for the particular win quote. Use [New Quote] in between the two tags to
# start up a new quote.
# 
# <level quotes>
#  string
#  string
# </level quotes>
# Sets the level up quote for the actor. The strings are continuous and can use
# text codes. Use \n for a line break. Type in what you want the actor to say
# for the particular win quote. Use [New Quote] in between the two tags to
# start up a new quote.
# 
# <drops quotes>
#  string
#  string
# </drops quotes>
# Sets the drops quote for the actor. The strings are continuous and can use
# text codes. Use \n for a line break. Type in what you want the actor to say
# for the particular win quote. Use [New Quote] in between the two tags to
# start up a new quote.
# 
# -----------------------------------------------------------------------------
# Class Notetags - These notetags go in the class notebox in the database.
# -----------------------------------------------------------------------------
# <win quotes>
#  string
#  string
# </win quotes>
# Sets the win quote for the class. The strings are continuous and can use
# text codes. Use \n for a line break. Type in what you want the actor to say
# for the particular win quote. Use [New Quote] in between the two tags to
# start up a new quote.
# 
# <level quotes>
#  string
#  string
# </level quotes>
# Sets the level up quote for the class. The strings are continuous and can use
# text codes. Use \n for a line break. Type in what you want the actor to say
# for the particular win quote. Use [New Quote] in between the two tags to
# start up a new quote.
# 
# <drops quotes>
#  string
#  string
# </drops quotes>
# Sets the drops quote for the class. The strings are continuous and can use
# text codes. Use \n for a line break. Type in what you want the actor to say
# for the particular win quote. Use [New Quote] in between the two tags to
# start up a new quote.
# 
#==============================================================================
# Å• Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module VICTORY_AFTERMATH
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - General Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These are various settings that are used throughout the Victory Aftermath
    # portion of a battle. Adjust them as you see fit.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    VICTORY_BGM  = RPG::BGM.new("Field1", 100, 100)    # Victory BGM
    VICTORY_TICK = RPG::SE.new("Decision1", 100, 150)  # EXP ticking SFX
    LEVEL_SOUND  = RPG::SE.new("Up4", 80, 150)         # Level Up SFX
    SKILLS_TEXT  = "New Skills"                        # New skills text title.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Important Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These are some important settings so please set them up properly. This
    # section includes a switch that allows you to skip the victory aftermath
    # phase (for those back to back battles and making them seamless) and it
    # also allows you to declare a common event to run after each battle. If
    # you do not wish to use either of these features, set them to 0. The
    # common event will run regardless of win or escape.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    SKIP_AFTERMATH_SWITCH  = 0  # If switch on, skip aftermath. 0 to disable.
    SKIP_MUSIC_SWITCH      = 0  # If switch on, skip music. 0 to disable.
    AFTERMATH_COMMON_EVENT = 0  # Runs common event after battle. 0 to disable.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Top Text Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Here, you can adjust the various text that appears in the window that
    # appears at the top of the screen.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    TOP_TEAM         = "%s's team"           # Team name used.
    TOP_VICTORY_TEXT = "%s is victorious!"   # Text used to display victory.
    TOP_LEVEL_UP     = "%s has leveled up!"  # Text used to display level up.
    TOP_SPOILS       = "Victory Spoils!"     # Text used for spoils.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - EXP Gauge Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Adjust how the EXP Gauge appears for the Victory Aftermath here. This
    # includes the text display, the font size, the colour of the gauges, and
    # more. Adjust it all here.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    VICTORY_EXP  = "+%sEXP"      # Text used to display EXP.
    EXP_PERCENT  = "%1.2f%%"     # The way EXP percentage will be displayed.
    LEVELUP_TEXT = "LEVEL UP!"   # Text to replace percentage when leveled.
    MAX_LVL_TEXT = "MAX LEVEL"   # Text to replace percentage when max level.
    FONTSIZE_EXP = 20            # Font size used for EXP.
    EXP_TICKS    = 15            # Ticks to full EXP
    EXP_GAUGE1   = 12            # "Window" skin text colour for gauge.
    EXP_GAUGE2   = 4             # "Window" skin text colour for gauge.
    LEVEL_GAUGE1 = 13            # "Window" skin text colour for leveling.
    LEVEL_GAUGE2 = 5             # "Window" skin text colour for leveling.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Victory Messages -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # In the Victory Aftermath, actors can say unique things. This is the pool
    # of quotes used for actors without any custom victory quotes. Note that
    # actors with custom quotes will take priority over classes with custom
    # quotes, which will take priority over these default quotes. Use \n for
    # a line break in the quotes.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    HEADER_TEXT = "\e>\eC[6]%s\eC[0]\e<\n"  # Always at start of messages.
    FOOTER_TEXT = ""                        # Always at end of messages.
    
    # Win Quotes are what the actors say when a battle is won.
    VICTORY_QUOTES ={
    # :type   => Quotes
      #------------------------------------------------------------------------
      :win    => [ # Occurs as initial victory quote.
                   '"We won! What an exciting fight!"',
                   '"I didn\'t even break a sweat."',
                   '"That wasn\'t so tough."',
                   '"Let\'s fight something harder!"',
                 ],# Do not remove this.
      #------------------------------------------------------------------------
      :level  => [ # Occurs as initial victory quote.
                   '"Yes! Level up!"',
                   '"I\'ve gotten stronger!"',
                   '"Try to keep up with me!"',
                   '"I\'ve grown again!"',
                 ],# Do not remove this.
      #------------------------------------------------------------------------
      :drops  => [ # Occurs as initial victory quote.
                   '"I\'ll be taking these."',
                   '"To the victor goes the spoils."',
                   '"The enemies dropped something!"',
                   '"Hey, what\'s this?"',
                 ],# Do not remove this.
      #------------------------------------------------------------------------
    } # Do not remove this.
    
  end # VICTORY_AFTERMATH
end # YEA

#==============================================================================
# Å• Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module BASEITEM
    
    NEW_QUOTE = /\[(?:NEW_QUOTE|new quote)\]/i
    
    WIN_QUOTE_ON    = /<(?:WIN_QUOTES|win quote|win quotes)>/i
    WIN_QUOTE_OFF   = /<\/(?:WIN_QUOTES|win quote|win quotes)>/i
    LEVEL_QUOTE_ON  = /<(?:LEVEL_QUOTES|level quote|level quotes)>/i
    LEVEL_QUOTE_OFF = /<\/(?:LEVEL_QUOTES|level quote|level quotes)>/i
    DROPS_QUOTE_ON  = /<(?:DROPS_QUOTES|drops quote|drops quotes)>/i
    DROPS_QUOTE_OFF = /<\/(?:DROPS_QUOTES|drops quote|drops quotes)>/i
    
  end # BASEITEM
  end # REGEXP
end # YEA

#==============================================================================
# Å° Switch
#==============================================================================

module Switch
  
  #--------------------------------------------------------------------------
  # self.skip_aftermath
  #--------------------------------------------------------------------------
  def self.skip_aftermath
    return false if YEA::VICTORY_AFTERMATH::SKIP_AFTERMATH_SWITCH <= 0
    return $game_switches[YEA::VICTORY_AFTERMATH::SKIP_AFTERMATH_SWITCH]
  end
  
  #--------------------------------------------------------------------------
  # self.skip_aftermath_music
  #--------------------------------------------------------------------------
  def self.skip_aftermath_music
    return false if YEA::VICTORY_AFTERMATH::SKIP_MUSIC_SWITCH <=0
    return $game_switches[YEA::VICTORY_AFTERMATH::SKIP_MUSIC_SWITCH]
  end
    
end # Switch

#==============================================================================
# Å° Numeric
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
# Å° DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_va load_database; end
  def self.load_database
    load_database_va
    load_notetags_va
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_va
  #--------------------------------------------------------------------------
  def self.load_notetags_va
    groups = [$data_actors, $data_classes]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_va
      end
    end
  end
  
end # DataManager

#==============================================================================
# Å° RPG::BaseItem
#==============================================================================

class RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :win_quotes
  attr_accessor :level_quotes
  attr_accessor :drops_quotes
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_va
  #--------------------------------------------------------------------------
  def load_notetags_va
    @win_quotes = [""]
    @level_quotes = [""]
    @drops_quotes = [""]
    @victory_quote_type = nil
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::BASEITEM::WIN_QUOTE_ON
        @victory_quote_type = :win_quote
      when YEA::REGEXP::BASEITEM::WIN_QUOTE_OFF
        @victory_quote_type = nil
      when YEA::REGEXP::BASEITEM::LEVEL_QUOTE_ON
        @victory_quote_type = :level_quote
      when YEA::REGEXP::BASEITEM::LEVEL_QUOTE_OFF
        @victory_quote_type = nil
      when YEA::REGEXP::BASEITEM::DROPS_QUOTE_ON
        @victory_quote_type = :drops_quote
      when YEA::REGEXP::BASEITEM::DROPS_QUOTE_OFF
        @victory_quote_type = nil
      #---
      when YEA::REGEXP::BASEITEM::NEW_QUOTE
        case @victory_quote_type
        when nil; next
        when :win_quote;   @win_quotes.push("")
        when :level_quote; @level_quotes.push("")
        when :drops_quote; @drops_quotes.push("")
        end
      #---
      else
        case @victory_quote_type
        when nil; next
        when :win_quote;   @win_quotes[@win_quotes.size-1] += line.to_s
        when :level_quote; @level_quotes[@level_quotes.size-1] += line.to_s
        when :drops_quote; @drops_quotes[@drops_quotes.size-1] += line.to_s
        end
      end
    } # self.note.split
    #---
    return unless self.is_a?(RPG::Class)
    quotes = YEA::VICTORY_AFTERMATH::VICTORY_QUOTES
    @win_quotes = quotes[:win].clone if @win_quotes == [""]
    @level_quotes = quotes[:level].clone if @level_quotes == [""]
    @drops_quotes = quotes[:drops].clone if @drops_quotes == [""]
  end
  
end # RPG::BaseItem

#==============================================================================
# Å° BattleManager
#==============================================================================

module BattleManager
  
  #--------------------------------------------------------------------------
  # overwrite method: self.process_victory
  #--------------------------------------------------------------------------
  def self.process_victory
    if $imported["YEA-CommandAutobattle"]
      SceneManager.scene.close_disable_autobattle_window
    end
    return skip_aftermath if Switch.skip_aftermath
    play_battle_end_me
    gain_jp if $imported["YEA-JPManager"]
    display_exp
    gain_exp
    gain_gold
    gain_drop_items
    close_windows
    SceneManager.return
    replay_bgm_and_bgs
    battle_end(0)
    return true
  end
  
  #--------------------------------------------------------------------------
  # new method: self.skip_aftermath
  #--------------------------------------------------------------------------
  def self.skip_aftermath
    $game_party.all_members.each do |actor|
      actor.gain_exp($game_troop.exp_total)
    end
    $game_party.gain_gold($game_troop.gold_total)
    $game_troop.make_drop_items.each do |item|
      $game_party.gain_item(item, 1)
    end
    close_windows
    SceneManager.return
    replay_bgm_and_bgs
    battle_end(0)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: self.play_battle_end_me
  #--------------------------------------------------------------------------
  def self.play_battle_end_me
    return if Switch.skip_aftermath_music
    $game_system.battle_end_me.play
    YEA::VICTORY_AFTERMATH::VICTORY_BGM.play
  end
  
  #--------------------------------------------------------------------------
  # new method: self.set_victory_text
  #--------------------------------------------------------------------------
  def self.set_victory_text(actor, type)
    text = "" + sprintf(YEA::VICTORY_AFTERMATH::HEADER_TEXT, actor.name)
    text += actor.victory_quotes(type)[rand(actor.victory_quotes(type).size)]
    text += YEA::VICTORY_AFTERMATH::FOOTER_TEXT
    $game_message.face_name = actor.face_name
    $game_message.face_index = actor.face_index
    $game_message.add(text)
    wait_for_message
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: self.display_exp
  #--------------------------------------------------------------------------
  def self.display_exp
    SceneManager.scene.show_victory_display_exp
    actor = $game_party.random_target
    @victory_actor = actor
    set_victory_text(@victory_actor, :win)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: self.gain_exp
  #--------------------------------------------------------------------------
  def self.gain_exp
    $game_party.all_members.each do |actor|
      temp_actor = Marshal.load(Marshal.dump(actor))
      actor.gain_exp($game_troop.exp_total)
      next if actor.level == temp_actor.level
      SceneManager.scene.show_victory_level_up(actor, temp_actor)
      set_victory_text(actor, :level)
      wait_for_message
    end
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: self.gain_gold
  #--------------------------------------------------------------------------
  def self.gain_gold
    $game_party.gain_gold($game_troop.gold_total)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: self.gain_drop_items
  #--------------------------------------------------------------------------
  def self.gain_drop_items
    drops = []
    $game_troop.make_drop_items.each do |item|
      $game_party.gain_item(item, 1)
      drops.push(item)
    end
    SceneManager.scene.show_victory_spoils($game_troop.gold_total, drops)
    set_victory_text(@victory_actor, :drops)
    wait_for_message
  end
  
  #--------------------------------------------------------------------------
  # new method: self.close_windows
  #--------------------------------------------------------------------------
  def self.close_windows
    SceneManager.scene.close_victory_windows
  end
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias battle_end_va battle_end; end
  def self.battle_end(result)
    battle_end_va(result)
    return if result == 2
    return if YEA::VICTORY_AFTERMATH::AFTERMATH_COMMON_EVENT <= 0
    event_id = YEA::VICTORY_AFTERMATH::AFTERMATH_COMMON_EVENT
    $game_temp.reserve_common_event(event_id)
  end
  
end # BattleManager

#==============================================================================
# Å° Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  
  #--------------------------------------------------------------------------
  # overwrite method: gain_exp
  #--------------------------------------------------------------------------
  def gain_exp(exp)
    enabled = !SceneManager.scene_is?(Scene_Battle)
    change_exp(self.exp + (exp * final_exp_rate).to_i, enabled)
  end
  
  #--------------------------------------------------------------------------
  # new method: victory_quotes
  #--------------------------------------------------------------------------
  def victory_quotes(type)
    case type
    when :win
      return self.actor.win_quotes if self.actor.win_quotes != [""]
      return self.class.win_quotes
    when :level
      return self.actor.level_quotes if self.actor.level_quotes != [""]
      return self.class.level_quotes
    when :drops
      return self.actor.drops_quotes if self.actor.drops_quotes != [""]
      return self.class.drops_quotes
    else
      return ["NOTEXT"]
    end
  end
  
end # Game_Actor

#==============================================================================
# Å° Window_VictoryTitle
#==============================================================================

class Window_VictoryTitle < Window_Base
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, Graphics.width, fitting_height(1))
    self.z = 200
    self.openness = 0
  end
  
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh(message = "")
    contents.clear
    draw_text(0, 0, contents.width, line_height, message, 1)
  end
  
end # Window_VictoryTitle

#==============================================================================
# Å° Window_VictoryEXP_Back
#==============================================================================

class Window_VictoryEXP_Back < Window_Selectable
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize
    super(0, fitting_height(1), Graphics.width, window_height)
    self.z = 200
    self.openness = 0
  end
  
  #--------------------------------------------------------------------------
  # window_height
  #--------------------------------------------------------------------------
  def window_height
    return Graphics.height - fitting_height(4) - fitting_height(1)
  end
  
  #--------------------------------------------------------------------------
  # col_max
  #--------------------------------------------------------------------------
  def col_max; return item_max; end
  
  #--------------------------------------------------------------------------
  # spacing
  #--------------------------------------------------------------------------
  def spacing; return 8; end
  
  #--------------------------------------------------------------------------
  # item_max
  #--------------------------------------------------------------------------
  def item_max; return $game_party.battle_members.size; end
  
  #--------------------------------------------------------------------------
  # open
  #--------------------------------------------------------------------------
  def open
    @exp_total = $game_troop.exp_total
    super
  end
  
  #--------------------------------------------------------------------------
  # item_rect
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new
    rect.width = item_width
    rect.height = contents.height
    rect.x = index % col_max * (item_width + spacing)
    rect.y = index / col_max * item_height
    return rect
  end
  
  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    actor = $game_party.battle_members[index]
    return if actor.nil?
    rect = item_rect(index)
    reset_font_settings
    draw_actor_name(actor, rect)
    draw_exp_gain(actor, rect)
    draw_jp_gain(actor, rect)
    draw_actor_face(actor, rect)
  end
  
  #--------------------------------------------------------------------------
  # draw_actor_name
  #--------------------------------------------------------------------------
  def draw_actor_name(actor, rect)
    name = actor.name
    draw_text(rect.x, rect.y+line_height, rect.width, line_height, name, 1)
  end
  
  #--------------------------------------------------------------------------
  # draw_actor_face
  #--------------------------------------------------------------------------
  def draw_actor_face(actor, rect)
    face_name = actor.face_name
    face_index = actor.face_index
    bitmap = Cache.face(face_name)
    rw = [rect.width, 96].min
    face_rect = Rect.new(face_index % 4 * 96, face_index / 4 * 96, rw, 96)
    rx = (rect.width - rw) / 2 + rect.x
    contents.blt(rx, rect.y + line_height * 2, bitmap, face_rect, 255)
  end
  
  #--------------------------------------------------------------------------
  # draw_exp_gain
  #--------------------------------------------------------------------------
  def draw_exp_gain(actor, rect)
    dw = rect.width - (rect.width - [rect.width, 96].min) / 2
    dy = rect.y + line_height * 3 + 96
    fmt = YEA::VICTORY_AFTERMATH::VICTORY_EXP
    text = sprintf(fmt, actor_exp_gain(actor).group)
    contents.font.size = YEA::VICTORY_AFTERMATH::FONTSIZE_EXP
    change_color(power_up_color)
    draw_text(rect.x, dy, dw, line_height, text, 2)
  end
  
  #--------------------------------------------------------------------------
  # actor_exp_gain
  #--------------------------------------------------------------------------
  def actor_exp_gain(actor)
    n = @exp_total * actor.final_exp_rate
    return n.to_i
  end
  
  #--------------------------------------------------------------------------
  # draw_jp_gain
  #--------------------------------------------------------------------------
  def draw_jp_gain(actor, rect)
    return unless $imported["YEA-JPManager"]
    dw = rect.width - (rect.width - [rect.width, 96].min) / 2
    dy = rect.y + line_height * 4 + 96
    fmt = YEA::JP::VICTORY_AFTERMATH
    text = sprintf(fmt, actor_jp_gain(actor).group, Vocab::jp)
    contents.font.size = YEA::VICTORY_AFTERMATH::FONTSIZE_EXP
    change_color(power_up_color)
    draw_text(rect.x, dy, dw, line_height, text, 2)
  end
  
  #--------------------------------------------------------------------------
  # actor_jp_gain
  #--------------------------------------------------------------------------
  def actor_jp_gain(actor)
    n = actor.battle_jp_earned
    if actor.exp + actor_exp_gain(actor) > actor.exp_for_level(actor.level + 1)
      n += YEA::JP::LEVEL_UP unless actor.max_level?
    end
    return n
  end
  
end # Window_VictoryEXP_Back

#==============================================================================
# Å° Window_VictoryEXP_Front
#==============================================================================

class Window_VictoryEXP_Front < Window_VictoryEXP_Back
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize
    super
    self.back_opacity = 0
    @ticks = 0
    @counter = 30
    contents.font.size = YEA::VICTORY_AFTERMATH::FONTSIZE_EXP
  end
  
  #--------------------------------------------------------------------------
  # update
  #--------------------------------------------------------------------------
  def update
    super
    update_tick
  end
  
  #--------------------------------------------------------------------------
  # update_tick
  #--------------------------------------------------------------------------
  def update_tick
    return unless self.openness >= 255
    return unless self.visible
    return if complete_ticks?
    @counter -= 1
    return unless @counter <= 0
    return if @ticks >= YEA::VICTORY_AFTERMATH::EXP_TICKS
    YEA::VICTORY_AFTERMATH::VICTORY_TICK.play
    @counter = 4
    @ticks += 1
    refresh
  end
  
  #--------------------------------------------------------------------------
  # complete_ticks?
  #--------------------------------------------------------------------------
  def complete_ticks?
    for actor in $game_party.battle_members
      total_ticks = YEA::VICTORY_AFTERMATH::EXP_TICKS
      bonus_exp = actor_exp_gain(actor) * @ticks / total_ticks
      now_exp = actor.exp - actor.current_level_exp + bonus_exp
      next_exp = actor.next_level_exp - actor.current_level_exp
      rate = now_exp * 1.0 / next_exp
      return false if rate < 1.0
    end
    return true
  end
  
  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    actor = $game_party.battle_members[index]
    return if actor.nil?
    rect = item_rect(index)
    draw_actor_exp(actor, rect)
  end
  
  #--------------------------------------------------------------------------
  # exp_gauge1
  #--------------------------------------------------------------------------
  def exp_gauge1; return text_color(YEA::VICTORY_AFTERMATH::EXP_GAUGE1); end
  
  #--------------------------------------------------------------------------
  # exp_gauge2
  #--------------------------------------------------------------------------
  def exp_gauge2; return text_color(YEA::VICTORY_AFTERMATH::EXP_GAUGE2); end
  
  #--------------------------------------------------------------------------
  # lvl_gauge1
  #--------------------------------------------------------------------------
  def lvl_gauge1; return text_color(YEA::VICTORY_AFTERMATH::LEVEL_GAUGE1); end
  
  #--------------------------------------------------------------------------
  # lvl_gauge2
  #--------------------------------------------------------------------------
  def lvl_gauge2; return text_color(YEA::VICTORY_AFTERMATH::LEVEL_GAUGE2); end
  
  #--------------------------------------------------------------------------
  # draw_actor_exp
  #--------------------------------------------------------------------------
  def draw_actor_exp(actor, rect)
    if actor.max_level?
      draw_exp_gauge(actor, rect, 1.0)
      return
    end
    total_ticks = YEA::VICTORY_AFTERMATH::EXP_TICKS
    bonus_exp = actor_exp_gain(actor) * @ticks / total_ticks
    now_exp = actor.exp - actor.current_level_exp + bonus_exp
    next_exp = actor.next_level_exp - actor.current_level_exp
    rate = now_exp * 1.0 / next_exp
    draw_exp_gauge(actor, rect, rate)
  end
  
  #--------------------------------------------------------------------------
  # draw_exp_gauge
  #--------------------------------------------------------------------------
  def draw_exp_gauge(actor, rect, rate)
    rate = [[rate, 1.0].min, 0.0].max
    dx = (rect.width - [rect.width, 96].min) / 2 + rect.x
    dy = rect.y + line_height * 2 + 96
    dw = [rect.width, 96].min
    colour1 = rate >= 1.0 ? lvl_gauge1 : exp_gauge1
    colour2 = rate >= 1.0 ? lvl_gauge2 : exp_gauge2
    draw_gauge(dx, dy, dw, rate, colour1, colour2)
    fmt = YEA::VICTORY_AFTERMATH::EXP_PERCENT
    text = sprintf(fmt, [rate * 100, 100.00].min)
    if [rate * 100, 100.00].min == 100.00
      text = YEA::VICTORY_AFTERMATH::LEVELUP_TEXT
      text = YEA::VICTORY_AFTERMATH::MAX_LVL_TEXT if actor.max_level?
    end
    draw_text(dx, dy, dw, line_height, text, 1)
  end
  
end # Window_VictoryEXP_Front

#==============================================================================
# Å° Window_VictoryLevelUp
#==============================================================================

class Window_VictoryLevelUp < Window_Base
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize
    super(0, fitting_height(1), Graphics.width, window_height)
    self.z = 200
    hide
  end
  
  #--------------------------------------------------------------------------
  # window_height
  #--------------------------------------------------------------------------
  def window_height
    return Graphics.height - fitting_height(4) - fitting_height(1)
  end
  
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh(actor, temp_actor)
    contents.clear
    reset_font_settings
    YEA::VICTORY_AFTERMATH::LEVEL_SOUND.play
    draw_actor_changes(actor, temp_actor)
  end
  
  #--------------------------------------------------------------------------
  # draw_actor_changes
  #--------------------------------------------------------------------------
  def draw_actor_changes(actor, temp_actor)
    dx = contents.width / 16
    draw_actor_image(actor, temp_actor, dx)
    draw_param_names(actor, dx)
    draw_former_stats(temp_actor)
    draw_arrows
    draw_newer_stats(actor, temp_actor)
    draw_new_skills(actor, temp_actor)
  end
  
  #--------------------------------------------------------------------------
  # draw_actor_image
  #--------------------------------------------------------------------------
  def draw_actor_image(actor, temp_actor, dx)
    draw_text(dx, line_height, 96, line_height, actor.name, 1)
    draw_actor_face(actor, dx, line_height * 2)
    exp = actor.exp - temp_actor.exp
    text = sprintf(YEA::VICTORY_AFTERMATH::VICTORY_EXP, exp.group)
    change_color(power_up_color)
    contents.font.size = YEA::VICTORY_AFTERMATH::FONTSIZE_EXP
    draw_text(0, line_height * 2 + 96, dx + 96, line_height, text, 2)
    reset_font_settings
  end
  
  #--------------------------------------------------------------------------
  # draw_param_names
  #--------------------------------------------------------------------------
  def draw_param_names(actor, dx)
    dx += 108
    change_color(system_color)
    text = Vocab.level
    draw_text(dx, 0, contents.width - dx, line_height, text)
    dy = 0
    for i in 0...8
      dy += line_height
      text = Vocab.param(i)
      draw_text(dx, dy, contents.width - dx, line_height, text)
    end
  end
  
  #--------------------------------------------------------------------------
  # draw_former_stats
  #--------------------------------------------------------------------------
  def draw_former_stats(actor)
    dw = contents.width / 2 - 12
    dy = 0
    change_color(normal_color)
    draw_text(0, dy, dw, line_height, actor.level.group, 2)
    for i in 0...8
      dy += line_height
      draw_text(0, dy, dw, line_height, actor.param_base(i).group, 2)
    end
  end
  
  #--------------------------------------------------------------------------
  # draw_arrows
  #--------------------------------------------------------------------------
  def draw_arrows
    dx = contents.width / 2 - 12
    dy = 0
    change_color(system_color)
    for i in 0..8
      draw_text(dx, dy, 24, line_height, "Å®", 1)
      dy += line_height
    end
  end
  
  #--------------------------------------------------------------------------
  # draw_newer_stats
  #--------------------------------------------------------------------------
  def draw_newer_stats(actor, temp_actor)
    dx = contents.width / 2 + 12
    dw = contents.width - dx
    dy = 0
    change_color(param_change_color(actor.level - temp_actor.level))
    draw_text(dx, dy, dw, line_height, actor.level.group, 0)
    for i in 0...8
      dy += line_height
      change_color(param_change_color(actor.param_base(i) - temp_actor.param_base(i)))
      draw_text(dx, dy, dw, line_height, actor.param_base(i).group, 0)
    end
  end
  #--------------------------------------------------------------------------
  # draw_new_skills
  #--------------------------------------------------------------------------
  def draw_new_skills(actor, temp_actor)
    return if temp_actor.skills.size == actor.skills.size
    dw = 172 + 24
    dx = contents.width - dw
    change_color(system_color)
    text = YEA::VICTORY_AFTERMATH::SKILLS_TEXT
    draw_text(dx, 0, dw, line_height, text, 0)
  end
  
end # Window_VictoryLevelUp

#==============================================================================
# Å° Window_VictorySkills
#==============================================================================

class Window_VictorySkills < Window_Selectable
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize
    dy = fitting_height(1) + 24
    dw = 172 + 24 + 24
    dh = Graphics.height - fitting_height(4) - fitting_height(1) - 24
    super(Graphics.width - dw, dy, dw, dh)
    self.opacity = 0
    self.z = 200
    hide
  end
  
  #--------------------------------------------------------------------------
  # item_max
  #--------------------------------------------------------------------------
  def item_max; return @data.nil? ? 0 : @data.size; end
  
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh(actor, temp_actor)
    contents.clear
    if actor.skills.size == temp_actor.skills.size
      unselect
      @data = []
      create_contents
      return
    end
    @data = actor.skills - temp_actor.skills
    if @data.size > 8
      select(0)
      activate
    else
      unselect
      deactivate
    end
    create_contents
    draw_all_items
  end
  
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect(index)
    skill = @data[index]
    return if skill.nil?
    rect.width -= 4
    draw_item_name(skill, rect.x, rect.y, true)
  end
  
end # Window_VictorySkills

#==============================================================================
# Å° Window_VictorySpoils
#==============================================================================

class Window_VictorySpoils < Window_ItemList
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize
    super(0, fitting_height(1), Graphics.width, window_height)
    self.z = 200
    hide
  end
  
  #--------------------------------------------------------------------------
  # window_height
  #--------------------------------------------------------------------------
  def window_height
    return Graphics.height - fitting_height(4) - fitting_height(1)
  end
  
  #--------------------------------------------------------------------------
  # spacing
  #--------------------------------------------------------------------------
  def spacing; return 32; end
  
  #--------------------------------------------------------------------------
  # make
  #--------------------------------------------------------------------------
  def make(gold, drops)
    @gold = gold
    @drops = drops
    refresh
    select(0)
    activate
  end
  
  #--------------------------------------------------------------------------
  # make_item_list
  #--------------------------------------------------------------------------
  def make_item_list
    @data = [nil]
    items = {}
    weapons = {}
    armours = {}
    @goods = {}
    for item in @drops
      case item
      when RPG::Item
        items[item] = 0 if items[item].nil?
        items[item] += 1
      when RPG::Weapon
        weapons[item] = 0 if weapons[item].nil?
        weapons[item] += 1
      when RPG::Armor
        armours[item] = 0 if armours[item].nil?
        armours[item] += 1
      end
    end
    items = items.sort { |a,b| a[0].id <=> b[0].id }
    weapons = weapons.sort { |a,b| a[0].id <=> b[0].id }
    armours = armours.sort { |a,b| a[0].id <=> b[0].id }
    for key in items; @goods[key[0]] = key[1]; @data.push(key[0]); end
    for key in weapons; @goods[key[0]] = key[1]; @data.push(key[0]); end
    for key in armours; @goods[key[0]] = key[1]; @data.push(key[0]); end
  end
  
  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    rect = item_rect(index)
    reset_font_settings
    if item.nil?
      draw_gold(rect)
      return
    end
    rect.width -= 4
    draw_item_name(item, rect.x, rect.y, true, rect.width - 24)
    draw_item_number(rect, item)
  end
  
  #--------------------------------------------------------------------------
  # draw_gold
  #--------------------------------------------------------------------------
  def draw_gold(rect)
    text = Vocab.currency_unit
    draw_currency_value(@gold, text, rect.x, rect.y, rect.width)
  end
  
  #--------------------------------------------------------------------------
  # draw_item_number
  #--------------------------------------------------------------------------
  def draw_item_number(rect, item)
    number = @goods[item].group
    if $imported["YEA-AdjustLimits"]
      contents.font.size = YEA::LIMIT::ITEM_FONT
      text = sprintf(YEA::LIMIT::ITEM_PREFIX, number)
      draw_text(rect, text, 2)
    else
      draw_text(rect, sprintf(":%s", number), 2)
    end
  end
  
end # Window_VictorySpoils

#==============================================================================
# Å° Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: create_all_windows
  #--------------------------------------------------------------------------
  alias scene_battle_create_all_windows_va create_all_windows
  def create_all_windows
    scene_battle_create_all_windows_va
    create_victory_aftermath_windows
  end
  
  #--------------------------------------------------------------------------
  # new method: create_victory_aftermath_windows
  #--------------------------------------------------------------------------
  def create_victory_aftermath_windows
    @victory_title_window = Window_VictoryTitle.new
    @victory_exp_window_back = Window_VictoryEXP_Back.new
    @victory_exp_window_front = Window_VictoryEXP_Front.new
    @victory_level_window = Window_VictoryLevelUp.new
    @victory_level_skills = Window_VictorySkills.new
    @victory_spoils_window = Window_VictorySpoils.new
  end
  
  #--------------------------------------------------------------------------
  # new method: show_victory_display_exp
  #--------------------------------------------------------------------------
  def show_victory_display_exp
    @victory_title_window.open
    name = $game_party.battle_members[0].name
    fmt = YEA::VICTORY_AFTERMATH::TOP_TEAM
    name = sprintf(fmt, name) if $game_party.battle_members.size > 1
    fmt = YEA::VICTORY_AFTERMATH::TOP_VICTORY_TEXT
    text = sprintf(fmt, name)
    @victory_title_window.refresh(text)
    #---
    @victory_exp_window_back.open
    @victory_exp_window_back.refresh
    @victory_exp_window_front.open
    @victory_exp_window_front.refresh
  end
  
  #--------------------------------------------------------------------------
  # new method: show_victory_level_up
  #--------------------------------------------------------------------------
  def show_victory_level_up(actor, temp_actor)
    @victory_exp_window_back.hide
    @victory_exp_window_front.hide
    #---
    fmt = YEA::VICTORY_AFTERMATH::TOP_LEVEL_UP
    text = sprintf(fmt, actor.name)
    @victory_title_window.refresh(text)
    #---
    @victory_level_window.show
    @victory_level_window.refresh(actor, temp_actor)
    @victory_level_skills.show
    @victory_level_skills.refresh(actor, temp_actor)
  end
  
  #--------------------------------------------------------------------------
  # new method: show_victory_spoils
  #--------------------------------------------------------------------------
  def show_victory_spoils(gold, drops)
    @victory_exp_window_back.hide
    @victory_exp_window_front.hide
    @victory_level_window.hide
    @victory_level_skills.hide
    #---
    text = YEA::VICTORY_AFTERMATH::TOP_SPOILS
    @victory_title_window.refresh(text)
    #---
    @victory_spoils_window.show
    @victory_spoils_window.make(gold, drops)
  end
  
  #--------------------------------------------------------------------------
  # new method: close_victory_windows
  #--------------------------------------------------------------------------
  def close_victory_windows
    @victory_title_window.close
    @victory_exp_window_back.close
    @victory_exp_window_front.close
    @victory_level_window.close
    @victory_level_skills.close
    @victory_spoils_window.close
    wait(16)
  end
  
end # Scene_Battle

#==============================================================================
# 
# Å• End of File
# 
#==============================================================================