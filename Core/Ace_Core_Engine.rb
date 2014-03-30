#==============================================================================
# 
# ▼ Yanfly Engine Ace - Ace Core Engine v1.09
# -- Last Updated: 2012.02.19
# -- Level: Easy, Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-CoreEngine"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.02.19 - Bug Fixed: Parallax updating works properly with looping maps.
# 2012.02.10 - Bug Fixed: Forced actions no longer cancel out other actions
#              that have been queued up for later.
# 2012.01.08 - Font resets no longer reset bold and italic to off, but instead
#              to whatever default you've set.
# 2011.12.26 - New Bugfix: When using substitute, allies will no longer take
#              place of low HP allies for friendly skills.
# 2011.12.20 - New Bugfix: Force Action no longer cancels out an actor's queue.
#              Credits to Yami for finding and making the fix for!
#              Switch added for those who want removed forced action battlers.
# 2011.12.15 - Updated for better menu gauge appearance.
# 2011.12.10 - Bug Fixed: Right and bottom sides of the map would show
#              the left and top sides of the map.
#            - Bug Fixed: Viewport sizes didn't refresh from smaller maps.
# 2011.12.07 - New Bugfix: Dual weapon normal attacks will now play both
#              animations without one animation interrupting the other.
# 2011.12.04 - Updated certain GUI extensions for increased screen size.
#            - More efficient digit grouping method credits to TDS.
# 2011.12.01 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This is the core engine for Yanfly Engine Ace, made for RPG Maker VX Ace.
# This script provides various changes made to the main engine including bug
# fixes and GUI upgrades.
# 
# -----------------------------------------------------------------------------
# Bug Fix: Animation Overlay
# -----------------------------------------------------------------------------
# - It's the same bug from VX. When an all-screen animation is played against a
# group of enemies, the animation bitmap is actually made multiple times, thus
# causing a pretty extreme overlay when there are a lot of enemies on screen.
# This fix will cause the animation to play only once.
# 
# -----------------------------------------------------------------------------
# Bug Fix: Animation Interruption
# -----------------------------------------------------------------------------
# - A new bug. When a character dual wields and attacks a single target, if an
# animation lasts too long, it will interrupt and/or halt the next animation
# from occurring. This script will cause the first animation to finish playing
# and then continue forth.
# 
# -----------------------------------------------------------------------------
# Bug Fix: Battle Turn Order Fix
# -----------------------------------------------------------------------------
# - Same bug from VX. For those who use the default battle system, once a
# turn's started, the action order for the turn becomes set and unchanged for
# the remainder of that turn. Any changes to a battler's AGI will not be
# altered at all even if the battler were to receive an AGI buff or debuff.
# This fix will cause the speed to be updated properly upon each action.
# 
# -----------------------------------------------------------------------------
# Bug Fix: Forced Action Fix
# -----------------------------------------------------------------------------
# - A new bug. When a battler is forced to perform an action, the battler's
# queued action is removed and the battler loses its place in battle. This
# fix will resume queue after a forced action.
# 
# -----------------------------------------------------------------------------
# Bug Fix: Gauge Overlap Fix
# -----------------------------------------------------------------------------
# - Same bug from VX. When some values exceed certain amounts, gauges can
# overextend past the width they were originally designed to fit in. This fix
# will prevent any overextending from gauges.
# 
# -----------------------------------------------------------------------------
# Bug Fix: Held L and R Menu Scrolling
# -----------------------------------------------------------------------------
# - Before in VX, you can scroll through menus by holding down L and R buttons
# (Q and W on the keyboard) to scroll through menus quickly. This fix will
# re-enable the ability to scroll through menus in such a fashion. Disable it
# in the module if you wish to.
# 
# -----------------------------------------------------------------------------
# Bug Fix: Substitute Healing
# -----------------------------------------------------------------------------
# If an actor has the substitute (cover) flag on them, they will attempt to
# take the place of low HP allies when they're the target of attack. However,
# this is also the case for friendly skills such as heal. This script will fix
# it where if a battler targets an ally, no substitutes will take place.
# 
# -----------------------------------------------------------------------------
# New Feature: Screen Resolution Size
# -----------------------------------------------------------------------------
# - The screen can now be resized from 544x416 with ease and still support maps
# that are smaller than 544x416. Maps smaller than 544x416 will be centered on
# the screen without having sprites jumping all over the place.
# 
# -----------------------------------------------------------------------------
# New Feature: Adjust Animation Speed
# -----------------------------------------------------------------------------
# - RPG Maker VX Ace plays animations at a rate of 15 FPS by default. Speed up
# the animations by changing a simple constant in the module.
# 
# -----------------------------------------------------------------------------
# New Feature: GUI Modifications
# -----------------------------------------------------------------------------
# - There are quite a lot of different modifications you can do to the GUI.
# This includes placing outlines around your gauges, changing the colours of 
# each individual font aspect, and more. Also, you can change the default font
# setting for your games here.
# 
# -----------------------------------------------------------------------------
# New Feature: Numeric Digit Grouping
# -----------------------------------------------------------------------------
# This will change various scenes to display numbers in groups where they are
# separated by a comma every three digits. Thus, a number like 1234567 will
# show up as 1,234,567. This allows for players to read numbers quicker.
# 
# And that's all for the bug fixes and features!
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module CORE
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Screen Resolution Size -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # RPG Maker VX Ace has the option of having larger width and height for
    # your games. Resizing the width and height will have these changes:
    # 
    #              Default   Resized   Min Tiles Default   Min Tiles New
    #    Width       544       640           17                 20
    #    Height      416       480           13                 15
    # 
    # * Note: Maximum width is 640 while maximum height is 480.
    #         Minimum width is 110 while maximum height is 10.
    #         These are limitations set by RPG Maker VX Ace's engine.
    # 
    # By selecting resize, all of the default menus will have their windows
    # adjusted, but scripts provided by non-Yanfly Engine sources may or may
    # not adjust themselves properly.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    RESIZE_WIDTH  = 640
    RESIZE_HEIGHT = 416
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Adjust Animation Speed -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # By default, the animation speed played in battles operates at 15 FPS
    # (frames per second). For those who would like to speed it up, change this
    # constant to one of these values:
    #   RATE   Speed
    #     4      15 fps
    #     3      20 fps
    #     2      30 fps
    #     1      60 fps
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    ANIMATION_RATE = 3
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Digit Grouping -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Setting this to true will cause numbers to be grouped together when they
    # are larger than a thousand. For example, 12345 will appear as 12,345.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    GROUP_DIGITS = true
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Font Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Adjust the default font settings for your game here. The various settings
    # will be explained below.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    FONT_NAME = ["VL Gothic", "Verdana", "Arial", "Courier"]
    # This adjusts the fonts used for your game. If the font at the start of
    # the array doesn't exist on the player's computer, it'll use the next one.
    FONT_SIZE = 24       # Adjusts font size. Default: 24
    FONT_BOLD = false   # Makes font bold. Default: false
    FONT_ITALIC = false  # Makes font italic. Default: false
    FONT_SHADOW = false  # Gives font a shadow. Default: false
    FONT_OUTLINE = true  # Gives font an outline. Default: true
    FONT_COLOUR = Color.new(255, 255, 255, 255)   # Default: 255, 255, 255, 255
    FONT_OUTLINE_COLOUR = Color.new(0, 0, 0, 128) # Default:   0,   0,   0, 128
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Forced Action Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # For those who would like to allow the game to remove a forced action
    # battler from the queue list, use the switch below. If you don't want to
    # use this option, set the switch ID to 0.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    FORCED_ACTION_REMOVE_SWITCH = 0
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Gauge Appearance Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # You can modify the way your gauges appear in the game. If you wish for
    # them to have an outline, it's possible. You can also adjust the height
    # of the gauges, too.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    GAUGE_OUTLINE = true
    GAUGE_HEIGHT = 12
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Held L and R Menu Scrolling -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # VX gave the ability to scroll through menus quickly through holding the
    # L and R buttons (Q and W on the keyboard). VX Ace disabled it. Now, you
    # can re-enable the ability to scroll faster by setting this constant to
    # true. To disable it, set this constant to false.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    QUICK_SCROLLING = true
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - System Text Colours -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Sometimes the system text colours are boring as just orange for HP, blue
    # for MP, and green for TP. Change the values here. Each number corresponds
    # to the colour index of the Window.png skin found in Graphics\System.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    COLOURS ={
    # :text       => ID
      :normal     =>  0,   # Default:  0
      :system     => 16,   # Default: 16
      :crisis     => 17,   # Default: 17
      :knockout   => 18,   # Default: 18
      :gauge_back => 19,   # Default: 19
      :hp_gauge1  => 28,   # Default: 20
      :hp_gauge2  => 29,   # Default: 21
      :mp_gauge1  => 22,   # Default: 22
      :mp_gauge2  => 23,   # Default: 23
      :mp_cost    => 23,   # Default: 23
      :power_up   => 24,   # Default: 24
      :power_down => 25,   # Default: 25
      :tp_gauge1  => 10,   # Default: 28
      :tp_gauge2  =>  2,   # Default: 29
      :tp_cost    =>  2,   # Default: 29
    } # Do not remove this.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - System Text Options -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Here, you can adjust the transparency used for disabled items, the %
    # needed for HP and MP to enter "crisis" mode.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    TRANSPARENCY = 160   # Adjusts transparency of disabled items. Default: 160
    HP_CRISIS = 0.25     # When HP is considered critical. Default: 0.25
    MP_CRISIS = 0.25     # When MP is considered critical. Default: 0.25
    ITEM_AMOUNT = "×%s"  # The prefix used for item amounts.
    
  end # CORE
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

Graphics.resize_screen(YEA::CORE::RESIZE_WIDTH, YEA::CORE::RESIZE_HEIGHT)
Font.default_name = YEA::CORE::FONT_NAME
Font.default_size = YEA::CORE::FONT_SIZE
Font.default_bold = YEA::CORE::FONT_BOLD
Font.default_italic = YEA::CORE::FONT_ITALIC
Font.default_shadow = YEA::CORE::FONT_SHADOW
Font.default_outline = YEA::CORE::FONT_OUTLINE
Font.default_color = YEA::CORE::FONT_COLOUR
Font.default_out_color = YEA::CORE::FONT_OUTLINE_COLOUR

#==============================================================================
# ■ Numeric
#==============================================================================

class Numeric  
  
  #--------------------------------------------------------------------------
  # new method: group_digits
  #--------------------------------------------------------------------------
  def group
    return self.to_s unless YEA::CORE::GROUP_DIGITS
    self.to_s.gsub(/(\d)(?=\d{3}+(?:\.|$))(\d{3}\..*)?/,'\1,\2')
  end
  
end # Numeric

#==============================================================================
# ■ Switch
#==============================================================================

module Switch
  
  #--------------------------------------------------------------------------
  # self.forced_action_remove
  #--------------------------------------------------------------------------
  def self.forced_action_remove
    return false if YEA::CORE::FORCED_ACTION_REMOVE_SWITCH <= 0
    return $game_switches[YEA::CORE::FORCED_ACTION_REMOVE_SWITCH]
  end
  
end # Switch

#==============================================================================
# ■ BattleManager
#==============================================================================

module BattleManager
  
  #--------------------------------------------------------------------------
  # overwrite method: turn_start
  #--------------------------------------------------------------------------
  def self.turn_start
    @phase = :turn
    clear_actor
    $game_troop.increase_turn
    @performed_battlers = []
    make_action_orders
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: next_subject
  #--------------------------------------------------------------------------
  def self.next_subject
    @performed_battlers = [] if @performed_battlers.nil?
    loop do
      @action_battlers -= @performed_battlers
      battler = @action_battlers.shift
      return nil unless battler
      next unless battler.index && battler.alive?
      @performed_battlers.push(battler)
      return battler
    end
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: force_action
  #--------------------------------------------------------------------------
  def self.force_action(battler)
    @action_forced = [] if @action_forced == nil
    @action_forced.push(battler)
    return unless Switch.forced_action_remove
    @action_battlers.delete(battler)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: action_forced?
  #--------------------------------------------------------------------------
  def self.action_forced?
    @action_forced != nil
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: action_forced_battler
  #--------------------------------------------------------------------------
  def self.action_forced_battler
    @action_forced.shift
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: clear_action_force
  #--------------------------------------------------------------------------
  def self.clear_action_force
    @action_forced = nil if @action_forced.empty?
  end
  
end # BattleManager

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :pseudo_ani_id
  
  #--------------------------------------------------------------------------
  # alias method: clear_sprite_effects
  #--------------------------------------------------------------------------
  alias game_battler_clear_sprite_effects_ace clear_sprite_effects
  def clear_sprite_effects
    game_battler_clear_sprite_effects_ace
    @pseudo_ani_id = 0
  end
  
  #--------------------------------------------------------------------------
  # alias method: force_action
  #--------------------------------------------------------------------------
  alias game_battler_force_action_ace force_action
  def force_action(skill_id, target_index)
    clone_current_actions
    game_battler_force_action_ace(skill_id, target_index)
  end
  
  #--------------------------------------------------------------------------
  # new method: clone_current_actions
  #--------------------------------------------------------------------------
  def clone_current_actions
    @cloned_actions = @actions.dup
  end
  
  #--------------------------------------------------------------------------
  # new method: restore_cloned_actions
  #--------------------------------------------------------------------------
  def restore_cloned_actions
    return if @cloned_actions.nil?
    @actions = @cloned_actions.dup
    @cloned_actions = nil
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_action_end
  #--------------------------------------------------------------------------
  alias game_battler_on_action_end_ace on_action_end
  def on_action_end
    game_battler_on_action_end_ace
    restore_cloned_actions
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_battle_end
  #--------------------------------------------------------------------------
  alias game_battler_on_battle_end_ace on_battle_end
  def on_battle_end
    game_battler_on_battle_end_ace
    @cloned_actions = nil
  end
  
end # Game_Battler

#==============================================================================
# ■ Game_Troop
#==============================================================================

class Game_Troop < Game_Unit
  
  #--------------------------------------------------------------------------
  # overwrite method: setup
  #--------------------------------------------------------------------------
  def setup(troop_id)
    clear
    @troop_id = troop_id
    @enemies = []
    troop.members.each do |member|
      next unless $data_enemies[member.enemy_id]
      enemy = Game_Enemy.new(@enemies.size, member.enemy_id)
      enemy.hide if member.hidden
      enemy.screen_x = member.x + (Graphics.width - 544)/2
      enemy.screen_y = member.y + (Graphics.height - 416)
      @enemies.push(enemy)
    end
    init_screen_tone
    make_unique_names
  end
  
end # Game_Troop

#==============================================================================
# ■ Game_Map
#==============================================================================

class Game_Map
  
  #--------------------------------------------------------------------------
  # overwrite method: scroll_down
  #--------------------------------------------------------------------------
  def scroll_down(distance)
    if loop_vertical?
      @display_y += distance
      @display_y %= @map.height * 256
      @parallax_y += distance if @parallax_loop_y
    else
      last_y = @display_y
      dh = Graphics.height > height * 32 ? height : screen_tile_y
      @display_y = [@display_y + distance, height - dh].min
      @parallax_y += @display_y - last_y
    end
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: scroll_right
  #--------------------------------------------------------------------------
  def scroll_right(distance)
    if loop_horizontal?
      @display_x += distance
      @display_x %= @map.width * 256
      @parallax_x += distance if @parallax_loop_x
    else
      last_x = @display_x
      dw = Graphics.width > width * 32 ? width : screen_tile_x
      @display_x = [@display_x + distance, width - dw].min
      @parallax_x += @display_x - last_x
    end
  end
  
end # Game_Map

#==============================================================================
# ■ Game_Event
#==============================================================================

class Game_Event < Game_Character
  
  #--------------------------------------------------------------------------
  # overwrite method: near_the_screen?
  #--------------------------------------------------------------------------
  def near_the_screen?(dx = nil, dy = nil)
    dx = [Graphics.width, $game_map.width * 256].min/32 - 5 if dx.nil?
    dy = [Graphics.height, $game_map.height * 256].min/32 - 5 if dy.nil?
    ax = $game_map.adjust_x(@real_x) - Graphics.width / 2 / 32
    ay = $game_map.adjust_y(@real_y) - Graphics.height / 2 / 32
    ax >= -dx && ax <= dx && ay >= -dy && ay <= dy
  end
  
end # Game_Event

#==============================================================================
# ■ Sprite_Base
#==============================================================================

class Sprite_Base < Sprite
  
  #--------------------------------------------------------------------------
  # overwrite method: set_animation_rate
  #--------------------------------------------------------------------------
  def set_animation_rate
    @ani_rate = YEA::CORE::ANIMATION_RATE
  end
  
  #--------------------------------------------------------------------------
  # new method: start_pseudo_animation
  #--------------------------------------------------------------------------
  def start_pseudo_animation(animation, mirror = false)
    dispose_animation
    @animation = animation
    return if @animation.nil?
    @ani_mirror = mirror
    set_animation_rate
    @ani_duration = @animation.frame_max * @ani_rate + 1
    @ani_sprites = []
  end
  
end # Sprite_Base

#==============================================================================
# ■ Sprite_Battler
#==============================================================================

class Sprite_Battler < Sprite_Base
  
  #--------------------------------------------------------------------------
  # alias method: setup_new_animation
  #--------------------------------------------------------------------------
  alias sprite_battler_setup_new_animation_ace setup_new_animation
  def setup_new_animation
    sprite_battler_setup_new_animation_ace
    return if @battler.nil?
    return if @battler.pseudo_ani_id.nil?
    return if @battler.pseudo_ani_id <= 0
    animation = $data_animations[@battler.pseudo_ani_id]
    mirror = @battler.animation_mirror
    start_pseudo_animation(animation, mirror)
    @battler.pseudo_ani_id = 0
  end
  
end # Sprite_Battler

#==============================================================================
# ■ Spriteset_Map
#==============================================================================

class Spriteset_Map
  
  #--------------------------------------------------------------------------
  # overwrite method: create_viewports
  #--------------------------------------------------------------------------
  def create_viewports
    if Graphics.width > $game_map.width * 32 && !$game_map.loop_horizontal?
      dx = (Graphics.width - $game_map.width * 32) / 2
    else
      dx = 0
    end
    dw = [Graphics.width, $game_map.width * 32].min
    dw = Graphics.width if $game_map.loop_horizontal?
    if Graphics.height > $game_map.height * 32 && !$game_map.loop_vertical?
      dy = (Graphics.height - $game_map.height * 32) / 2
    else
      dy = 0
    end
    dh = [Graphics.height, $game_map.height * 32].min
    dh = Graphics.height if $game_map.loop_vertical?
    @viewport1 = Viewport.new(dx, dy, dw, dh)
    @viewport2 = Viewport.new(dx, dy, dw, dh)
    @viewport3 = Viewport.new(dx, dy, dw, dh)
    @viewport2.z = 50
    @viewport3.z = 100
  end
  
  #--------------------------------------------------------------------------
  # new method: update_viewport_sizes
  #--------------------------------------------------------------------------
  def update_viewport_sizes
    if Graphics.width > $game_map.width * 32 && !$game_map.loop_horizontal?
      dx = (Graphics.width - $game_map.width * 32) / 2
    else
      dx = 0
    end
    dw = [Graphics.width, $game_map.width * 32].min
    dw = Graphics.width if $game_map.loop_horizontal?
    if Graphics.height > $game_map.height * 32 && !$game_map.loop_vertical?
      dy = (Graphics.height - $game_map.height * 32) / 2
    else
      dy = 0
    end
    dh = [Graphics.height, $game_map.height * 32].min
    dh = Graphics.height if $game_map.loop_vertical?
    rect = Rect.new(dx, dy, dw, dh)
    for viewport in [@viewport1, @viewport2, @viewport3]
      viewport.rect = rect
    end
  end
  
end # Spriteset_Map

#==============================================================================
# ■ Window_Base
#==============================================================================

class Window_Base < Window
  
  #--------------------------------------------------------------------------
  # overwrite method: reset_font_settings
  #--------------------------------------------------------------------------
  def reset_font_settings
    change_color(normal_color)
    contents.font.size = Font.default_size
    contents.font.bold = Font.default_bold
    contents.font.italic = Font.default_italic
    contents.font.out_color = Font.default_out_color
  end
  
  #--------------------------------------------------------------------------
  # overwrite methods: color
  #--------------------------------------------------------------------------
  def normal_color;      text_color(YEA::CORE::COLOURS[:normal]);      end;
  def system_color;      text_color(YEA::CORE::COLOURS[:system]);      end;
  def crisis_color;      text_color(YEA::CORE::COLOURS[:crisis]);      end;
  def knockout_color;    text_color(YEA::CORE::COLOURS[:knockout]);    end;
  def gauge_back_color;  text_color(YEA::CORE::COLOURS[:gauge_back]);  end;
  def hp_gauge_color1;   text_color(YEA::CORE::COLOURS[:hp_gauge1]);   end;
  def hp_gauge_color2;   text_color(YEA::CORE::COLOURS[:hp_gauge2]);   end;
  def mp_gauge_color1;   text_color(YEA::CORE::COLOURS[:mp_gauge1]);   end;
  def mp_gauge_color2;   text_color(YEA::CORE::COLOURS[:mp_gauge2]);   end;
  def mp_cost_color;     text_color(YEA::CORE::COLOURS[:mp_cost]);     end;
  def power_up_color;    text_color(YEA::CORE::COLOURS[:power_up]);    end;
  def power_down_color;  text_color(YEA::CORE::COLOURS[:power_down]);  end;
  def tp_gauge_color1;   text_color(YEA::CORE::COLOURS[:tp_gauge1]);   end;
  def tp_gauge_color2;   text_color(YEA::CORE::COLOURS[:tp_gauge2]);   end;
  def tp_cost_color;     text_color(YEA::CORE::COLOURS[:tp_cost]);     end;
  
  #--------------------------------------------------------------------------
  # overwrite method: translucent_alpha
  #--------------------------------------------------------------------------
  def translucent_alpha
    return YEA::CORE::TRANSPARENCY
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: hp_color
  #--------------------------------------------------------------------------
  def hp_color(actor)
    return knockout_color if actor.hp == 0
    return crisis_color if actor.hp < actor.mhp * YEA::CORE::HP_CRISIS
    return normal_color
  end
  #--------------------------------------------------------------------------
  # overwrite method: mp_color
  #--------------------------------------------------------------------------
  def mp_color(actor)
    return crisis_color if actor.mp < actor.mmp * YEA::CORE::MP_CRISIS
    return normal_color
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_gauge
  #--------------------------------------------------------------------------
  def draw_gauge(dx, dy, dw, rate, color1, color2)
    dw -= 2 if YEA::CORE::GAUGE_OUTLINE
    fill_w = [(dw * rate).to_i, dw].min
    gauge_h = YEA::CORE::GAUGE_HEIGHT
    gauge_y = dy + line_height - 2 - gauge_h
    if YEA::CORE::GAUGE_OUTLINE
      outline_colour = gauge_back_color
      outline_colour.alpha = translucent_alpha
      contents.fill_rect(dx, gauge_y-1, dw+2, gauge_h+2, outline_colour)
      dx += 1
    end
    contents.fill_rect(dx, gauge_y, dw, gauge_h, gauge_back_color)
    contents.gradient_fill_rect(dx, gauge_y, fill_w, gauge_h, color1, color2)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_actor_level
  #--------------------------------------------------------------------------
  def draw_actor_level(actor, dx, dy)
    change_color(system_color)
    draw_text(dx, dy, 32, line_height, Vocab::level_a)
    change_color(normal_color)
    draw_text(dx + 32, dy, 24, line_height, actor.level.group, 2)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_current_and_max_values
  #--------------------------------------------------------------------------
  def draw_current_and_max_values(dx, dy, dw, current, max, color1, color2)
    total = current.group + "/" + max.group
    if dw < text_size(total).width + text_size(Vocab.hp).width
      change_color(color1)
      draw_text(dx, dy, dw, line_height, current.group, 2)
    else
      xr = dx + text_size(Vocab.hp).width
      dw -= text_size(Vocab.hp).width
      change_color(color2)
      text = "/" + max.group
      draw_text(xr, dy, dw, line_height, text, 2)
      dw -= text_size(text).width
      change_color(color1)
      draw_text(xr, dy, dw, line_height, current.group, 2)
    end
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_actor_tp
  #--------------------------------------------------------------------------
  def draw_actor_tp(actor, x, y, width = 124)
    draw_gauge(x, y, width, actor.tp_rate, tp_gauge_color1, tp_gauge_color2)
    change_color(system_color)
    draw_text(x, y, 30, line_height, Vocab::tp_a)
    change_color(tp_color(actor))
    draw_text(x + width - 42, y, 42, line_height, actor.tp.to_i.group, 2)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_actor_param
  #--------------------------------------------------------------------------
  def draw_actor_param(actor, x, y, param_id)
    change_color(system_color)
    draw_text(x, y, 120, line_height, Vocab::param(param_id))
    change_color(normal_color)
    draw_text(x + 120, y, 36, line_height, actor.param(param_id).group, 2)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_currency_value
  #--------------------------------------------------------------------------
  def draw_currency_value(value, unit, x, y, width)
    cx = text_size(unit).width
    change_color(normal_color)
    draw_text(x, y, width - cx - 2, line_height, value.group, 2)
    change_color(system_color)
    draw_text(x, y, width, line_height, unit, 2)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_actor_simple_status
  #--------------------------------------------------------------------------
  def draw_actor_simple_status(actor, dx, dy)
    draw_actor_name(actor, dx, dy)
    draw_actor_level(actor, dx, dy + line_height * 1)
    draw_actor_icons(actor, dx, dy + line_height * 2)
    dw = contents.width - dx - 124
    draw_actor_class(actor, dx + 120, dy, dw)
    draw_actor_hp(actor, dx + 120, dy + line_height * 1, dw)
    draw_actor_mp(actor, dx + 120, dy + line_height * 2, dw)
  end
  
end # Window_Base

#==============================================================================
# ■ Window_Selectable
#==============================================================================

class Window_Selectable < Window_Base
  
  #--------------------------------------------------------------------------
  # overwrite method: process_cursor_move
  #--------------------------------------------------------------------------
  if YEA::CORE::QUICK_SCROLLING
  def process_cursor_move
    return unless cursor_movable?
    last_index = @index
    cursor_down (Input.trigger?(:DOWN))  if Input.repeat?(:DOWN)
    cursor_up   (Input.trigger?(:UP))    if Input.repeat?(:UP)
    cursor_right(Input.trigger?(:RIGHT)) if Input.repeat?(:RIGHT)
    cursor_left (Input.trigger?(:LEFT))  if Input.repeat?(:LEFT)
    cursor_pagedown   if !handle?(:pagedown) && Input.repeat?(:R)
    cursor_pageup     if !handle?(:pageup)   && Input.repeat?(:L)
    Sound.play_cursor if @index != last_index
  end
  end # YEA::CORE::QUICK_SCROLLING
  
end # Window_Selectable

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
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_item_number
  #--------------------------------------------------------------------------
  def draw_item_number(rect, item)
    text = sprintf(YEA::CORE::ITEM_AMOUNT, $game_party.item_number(item).group)
    draw_text(rect, text, 2)
  end
  
end # Window_ItemList

#==============================================================================
# ■ Window_SkillList
#==============================================================================

class Window_SkillList < Window_Selectable
  
  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    skill = @data[index]
    return if skill.nil?
    rect = item_rect(index)
    rect.width -= 4
    draw_item_name(skill, rect.x, rect.y, enable?(skill), rect.width - 24)
    draw_skill_cost(rect, skill)
  end
  
end # Window_SkillList

#==============================================================================
# ■ Window_Status
#==============================================================================

class Window_Status < Window_Selectable
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_exp_info
  #--------------------------------------------------------------------------
  def draw_exp_info(x, y)
    s1 = @actor.max_level? ? "-------" : @actor.exp
    s2 = @actor.max_level? ? "-------" : @actor.next_level_exp - @actor.exp
    s_next = sprintf(Vocab::ExpNext, Vocab::level)
    change_color(system_color)
    draw_text(x, y + line_height * 0, 180, line_height, Vocab::ExpTotal)
    draw_text(x, y + line_height * 2, 180, line_height, s_next)
    change_color(normal_color)
    s1 = s1.group if s1.is_a?(Integer)
    s2 = s2.group if s2.is_a?(Integer)
    draw_text(x, y + line_height * 1, 180, line_height, s1, 2)
    draw_text(x, y + line_height * 3, 180, line_height, s2, 2)
  end
  
end # Window_Status

#==============================================================================
# ■ Window_ShopBuy
#==============================================================================

class Window_ShopBuy < Window_Selectable
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    rect = item_rect(index)
    draw_item_name(item, rect.x, rect.y, enable?(item))
    rect.width -= 4
    draw_text(rect, price(item).group, 2)
  end
  
end # Window_ShopBuy

#==============================================================================
# ■ Scene_Map
#==============================================================================

class Scene_Map < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: post_transfer
  #--------------------------------------------------------------------------
  alias scene_map_post_transfer_ace post_transfer
  def post_transfer
    @spriteset.update_viewport_sizes
    scene_map_post_transfer_ace
  end
  
end # Scene_Map

#==============================================================================
# ■ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: check_substitute
  #--------------------------------------------------------------------------
  alias scene_battle_check_substitute_ace check_substitute
  def check_substitute(target, item)
    return false if @subject.actor? == target.actor?
    return scene_battle_check_substitute_ace(target, item)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: process_forced_action
  #--------------------------------------------------------------------------
  def process_forced_action
    while BattleManager.action_forced?
      last_subject = @subject
      @subject = BattleManager.action_forced_battler
      process_action
      @subject = last_subject
      BattleManager.clear_action_force
    end
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: show_attack_animation
  #--------------------------------------------------------------------------
  def show_attack_animation(targets)
    if @subject.actor?
      show_normal_animation(targets, @subject.atk_animation_id1, false)
      wait_for_animation
      show_normal_animation(targets, @subject.atk_animation_id2, true)
    else
      Sound.play_enemy_attack
      abs_wait_short
    end
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: show_normal_animation
  #--------------------------------------------------------------------------
  def show_normal_animation(targets, animation_id, mirror = false)
    animation = $data_animations[animation_id]
    return if animation.nil?
    ani_check = false
    targets.each do |target|
      if ani_check && target.animation_id <= 0
        target.pseudo_ani_id = animation_id
      else
        target.animation_id = animation_id
      end
      target.animation_mirror = mirror
      abs_wait_short unless animation.to_screen?
      ani_check = true if animation.to_screen?
    end
    abs_wait_short if animation.to_screen?
  end
  
end # Scene_Battle

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================