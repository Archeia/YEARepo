#==============================================================================
# 
# ▼ Yanfly Engine Ace - Battle Engine Add-On: Enemy HP Bars v1.10
# -- Last Updated: 2012.02.10
# -- Level: Easy, Normal
# -- Requires: YEA - Ace Battle Engine v1.00+.
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-EnemyHPBars"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.02.10 - Bug Fixed: AoE selection doesn't reveal hidden enemies.
# 2012.02.01 - Bug Fixed: Back and front of gauge randomly don't appear.
# 2012.01.11 - Efficiency update.
# 2012.01.04 - Compatibility Update: Area of Effect
# 2011.12.28 - Efficiency update.
#            - Bug Fixed: HP bars didn't disappear after a heal.
# 2011.12.26 - Bug Fixed: HP bars were not depleting.
# 2011.12.23 - Efficiency update.
# 2011.12.10 - Bug Fixed: HP bars no longer appear when dead and an AoE skill
#              has been selected.
# 2011.12.08 - New feature. Hide HP Bars until defeated once.
# 2011.12.06 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script shows HP gauges on enemies as they're selected for targeting or
# whenever they're damaged. The HP gauges will actually slide downward or
# upward as the enemies take damage.
# 
# Included in v1.01 is the option to require the player having slain an enemy
# once before enemies of that type will show their HP gauge.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Enemy Notetags - These notetags go in the enemy notebox in the database.
# -----------------------------------------------------------------------------
# <back gauge: x>
# Changes the colour of the enemy HP back gauge to x where x is the text colour
# used from the "Window" skin image under Graphics\System.
# 
# <hp gauge 1: x>
# <hp gauge 2: x>
# Changes the colour of the enemy HP HP gauge to x where x is the text colour
# used from the "Window" skin image under Graphics\System.
# 
# <hide gauge>
# <show gauge>
# Hides/shows HP gauge for enemies in battle. These gauges appear whenever the
# enemy is targeted for battle or whenever the enemy takes HP damage. Note that
# using the <show gauge> tag will bypass the requirement for needing to defeat
# an enemy once if that setting is enabled.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
# This script requires Yanfly Engine Ace - Ace Battle Engine v1.00+ and the
# script must be placed under Ace Battle Engine in the script listing.
# 
#==============================================================================

module YEA
  module BATTLE
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Enemy HP Gauges -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Adjust the settings for the enemy HP gauges. You can choose to show the
    # enemy HP gauges by default, the size of the gauge, the colour of the
    # gauge, and the back colour of the gauge.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    SHOW_ENEMY_HP_GAUGE    = true   # Display Enemy HP Gauge?
    ANIMATE_HP_GAUGE       = true   # Animate the HP gauge?
    DEFEAT_ENEMIES_FIRST   = false  # Must defeat enemy first to show HP?
    ENEMY_GAUGE_WIDTH      = 128    # How wide the enemy gauges are.
    ENEMY_GAUGE_HEIGHT     = 12     # How tall the enemy gauges are.
    ENEMY_HP_GAUGE_COLOUR1 = 20     # Colour 1 for HP.
    ENEMY_HP_GAUGE_COLOUR2 = 21     # Colour 2 for HP.
    ENEMY_BACKGAUGE_COLOUR = 19     # Gauge Back colour.
    
  end # BATTLE
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

if $imported["YEA-BattleEngine"]

module YEA
  module REGEXP
  module ENEMY
    
    HIDE_GAUGE = /<(?:HIDE_GAUGE|hide gauge)>/i
    SHOW_GAUGE = /<(?:SHOW_GAUGE|show gauge)>/i
    
    BACK_GAUGE = /<(?:BACK_GAUGE|back gauge):[ ]*(\d+)>/i
    HP_GAUGE_1 = /<(?:HP_GAUGE_1|hp gauge 1):[ ]*(\d+)>/i
    HP_GAUGE_2 = /<(?:HP_GAUGE_2|hp gauge 2):[ ]*(\d+)>/i
    
  end # ENEMY
  end # REGEXP
end # YEA

#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_ehpb load_database; end
  def self.load_database
    load_database_ehpb
    load_notetags_ehpb
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_ehpb
  #--------------------------------------------------------------------------
  def self.load_notetags_ehpb
    groups = [$data_enemies]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_ehpb
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
  attr_accessor :show_gauge
  attr_accessor :require_death_show_gauge
  attr_accessor :back_gauge_colour
  attr_accessor :hp_gauge_colour1
  attr_accessor :hp_gauge_colour2
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_ehpb
  #--------------------------------------------------------------------------
  def load_notetags_ehpb
    @show_gauge = YEA::BATTLE::SHOW_ENEMY_HP_GAUGE
    @require_death_show_gauge = YEA::BATTLE::DEFEAT_ENEMIES_FIRST
    @back_gauge_colour = YEA::BATTLE::ENEMY_BACKGAUGE_COLOUR
    @hp_gauge_colour1 = YEA::BATTLE::ENEMY_HP_GAUGE_COLOUR1
    @hp_gauge_colour2 = YEA::BATTLE::ENEMY_HP_GAUGE_COLOUR2
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::ENEMY::HIDE_GAUGE
        @show_gauge = false
      when YEA::REGEXP::ENEMY::SHOW_GAUGE
        @show_gauge = true
        @require_death_show_gauge = false
      when YEA::REGEXP::ENEMY::BACK_GAUGE
        @back_gauge_colour = [$1.to_i, 31].min
      when YEA::REGEXP::ENEMY::HP_GAUGE_1
        @hp_gauge_colour1 = [$1.to_i, 31].min
      when YEA::REGEXP::ENEMY::HP_GAUGE_2
        @hp_gauge_colour2 = [$1.to_i, 31].min
      end
    } # self.note.split
    #---
  end
  
end # RPG::Enemy

#==============================================================================
# ■ Sprite_Battler
#==============================================================================

class Sprite_Battler < Sprite_Base
  
  #--------------------------------------------------------------------------
  # alias method: initialize
  #--------------------------------------------------------------------------
  alias sprite_battler_initialize_ehpb initialize
  def initialize(viewport, battler = nil)
    sprite_battler_initialize_ehpb(viewport, battler)
    create_enemy_gauges
  end
  
  #--------------------------------------------------------------------------
  # alias method: dispose
  #--------------------------------------------------------------------------
  alias sprite_battler_dispose_ehpb dispose
  def dispose
    sprite_battler_dispose_ehpb
    dispose_enemy_gauges
  end
  
  #--------------------------------------------------------------------------
  # alias method: update
  #--------------------------------------------------------------------------
  alias sprite_battler_update_ehpb update
  def update
    sprite_battler_update_ehpb
    update_enemy_gauges
  end
  
  #--------------------------------------------------------------------------
  # new method: create_enemy_gauges
  #--------------------------------------------------------------------------
  def create_enemy_gauges
    return if @battler.nil?
    return if @battler.actor?
    return unless @battler.enemy.show_gauge
    @back_gauge_viewport = Enemy_HP_Gauge_Viewport.new(@battler, self, :back)
    @hp_gauge_viewport = Enemy_HP_Gauge_Viewport.new(@battler, self, :hp)
  end
  
  #--------------------------------------------------------------------------
  # new method: dispose_enemy_gauges
  #--------------------------------------------------------------------------
  def dispose_enemy_gauges
    @back_gauge_viewport.dispose unless @back_gauge_viewport.nil?
    @hp_gauge_viewport.dispose unless @hp_gauge_viewport.nil?
  end
  
  #--------------------------------------------------------------------------
  # new method: update_enemy_gauges
  #--------------------------------------------------------------------------
  def update_enemy_gauges
    @back_gauge_viewport.update unless @back_gauge_viewport.nil?
    @hp_gauge_viewport.update unless @hp_gauge_viewport.nil?
  end
  
  #--------------------------------------------------------------------------
  # new method: update_enemy_gauge_value
  #--------------------------------------------------------------------------
  def update_enemy_gauge_value
    @back_gauge_viewport.new_hp_updates unless @back_gauge_viewport.nil?
    @hp_gauge_viewport.new_hp_updates unless @hp_gauge_viewport.nil?
  end
  
end # Sprite_Battler

#==============================================================================
# ■ Game_BattlerBase
#==============================================================================

class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :hidden
  
  #--------------------------------------------------------------------------
  # alias method: refresh
  #--------------------------------------------------------------------------
  alias game_battlerbase_refresh_ehpb refresh
  def refresh
    game_battlerbase_refresh_ehpb
    return unless SceneManager.scene_is?(Scene_Battle)
    return if actor?
    sprite.update_enemy_gauge_value
  end
  
end # Game_BattlerBase

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias method: die
  #--------------------------------------------------------------------------
  alias game_battler_die_ehpb die
  def die
    game_battler_die_ehpb
    return if actor?
    $game_party.add_defeated_enemy(@enemy_id)
  end
  
  #--------------------------------------------------------------------------
  # alias method: hp=
  #--------------------------------------------------------------------------
  alias game_battlerbase_hpequals_ehpb hp=
  def hp=(value)
    game_battlerbase_hpequals_ehpb(value)
    return unless SceneManager.scene_is?(Scene_Battle)
    return if actor?
    return if value == 0
    sprite.update_enemy_gauge_value
  end
  
end # Game_Battler

#==============================================================================
# ■ Game_Party
#==============================================================================

class Game_Party < Game_Unit
  
  #--------------------------------------------------------------------------
  # alias method: init_all_items
  #--------------------------------------------------------------------------
  alias game_party_init_all_items_ehpb init_all_items
  def init_all_items
    game_party_init_all_items_ehpb
    @defeated_enemies = []
  end
  
  #--------------------------------------------------------------------------
  # new method: defeated_enemies
  #--------------------------------------------------------------------------
  def defeated_enemies
    @defeated_enemies = [] if @defeated_enemies.nil?
    return @defeated_enemies
  end
  
  #--------------------------------------------------------------------------
  # new method: add_defeated_enemy
  #--------------------------------------------------------------------------
  def add_defeated_enemy(id)
    @defeated_enemies = [] if @defeated_enemies.nil?
    @defeated_enemies.push(id) unless @defeated_enemies.include?(id)
  end
  
end # Game_Party

#==============================================================================
# ■ Enemy_HP_Gauge_Viewport
#==============================================================================

class Enemy_HP_Gauge_Viewport < Viewport
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(battler, sprite, type)
    @battler = battler
    @base_sprite = sprite
    @type = type
    dw = YEA::BATTLE::ENEMY_GAUGE_WIDTH
    dw += 2 if @type == :back
    @start_width = dw
    dh = YEA::BATTLE::ENEMY_GAUGE_HEIGHT
    dh += 2 if @type == :back
    rect = Rect.new(0, 0, dw, dh)
    @current_hp = @battler.hp
    @current_mhp = @battler.mhp
    @target_gauge_width = target_gauge_width
    @gauge_rate = 1.0
    setup_original_hide_gauge
    super(rect)
    self.z = 125
    create_gauge_sprites
    self.visible = false
    update_position
  end
  
  #--------------------------------------------------------------------------
  # dispose
  #--------------------------------------------------------------------------
  def dispose
    @sprite.bitmap.dispose unless @sprite.bitmap.nil?
    @sprite.dispose
    super
  end
  
  #--------------------------------------------------------------------------
  # update
  #--------------------------------------------------------------------------
  def update
    super
    self.visible = gauge_visible?
    @sprite.ox += 4 if YEA::BATTLE::ANIMATE_HP_GAUGE
    update_position
    update_gauge
    @visible_counter -= 1
  end
  
  #--------------------------------------------------------------------------
  # setup_original_hide_gauge
  #--------------------------------------------------------------------------
  def setup_original_hide_gauge
    @original_hide = @battler.enemy.require_death_show_gauge
    return unless @original_hide
    if YEA::BATTLE::DEFEAT_ENEMIES_FIRST
      enemy_id = @battler.enemy_id
      @original_hide = !$game_party.defeated_enemies.include?(enemy_id)
    end
  end
  
  #--------------------------------------------------------------------------
  # create_gauge_sprites
  #--------------------------------------------------------------------------
  def create_gauge_sprites
    @sprite = Plane.new(self)
    dw = self.rect.width * 2
    @sprite.bitmap = Bitmap.new(dw, self.rect.height)
    case @type
    when :back
      colour1 = Colour.text_colour(@battler.enemy.back_gauge_colour)
      colour2 = Colour.text_colour(@battler.enemy.back_gauge_colour)
    when :hp
      colour1 = Colour.text_colour(@battler.enemy.hp_gauge_colour1)
      colour2 = Colour.text_colour(@battler.enemy.hp_gauge_colour2)
    end
    dx = 0
    dy = 0
    dw = self.rect.width
    dh = self.rect.height
    @gauge_width = target_gauge_width
    @sprite.bitmap.gradient_fill_rect(dx, dy, dw, dh, colour1, colour2)
    @sprite.bitmap.gradient_fill_rect(dw, dy, dw, dh, colour2, colour1)
    @visible_counter = 0
  end
  
  #--------------------------------------------------------------------------
  # update_visible
  #--------------------------------------------------------------------------
  def gauge_visible?
    update_original_hide
    return false if @original_hide
    return false if case_original_hide?
    return true if @visible_counter > 0
    return true if @gauge_width != @target_gauge_width
    if SceneManager.scene_is?(Scene_Battle)
      return false if SceneManager.scene.enemy_window.nil?
      unless @battler.dead?
        if SceneManager.scene.enemy_window.active
          return true if SceneManager.scene.enemy_window.enemy == @battler
          return true if SceneManager.scene.enemy_window.select_all?
          return true if highlight_aoe?
        end
      end
    end
    return false
  end
  
  #--------------------------------------------------------------------------
  # highlight_aoe?
  #--------------------------------------------------------------------------
  def highlight_aoe?
    return false unless $imported["YEA-AreaofEffect"]
    return false if @battler.enemy? && @battler.hidden
    return SceneManager.scene.enemy_window.hightlight_aoe?(@battler)
  end
  
  #--------------------------------------------------------------------------
  # new_hp_updates
  #--------------------------------------------------------------------------
  def new_hp_updates
    return if @current_hp == @battler.hp && @current_mhp == @battler.mhp
    @current_hp = @battler.hp
    @current_mhp = @battler.mhp
    return if @gauge_rate == target_gauge_rate
    @gauge_rate = target_gauge_rate
    @target_gauge_width = target_gauge_width
    @visible_counter = 60
  end
  
  #--------------------------------------------------------------------------
  # case_original_hide?
  #--------------------------------------------------------------------------
  def case_original_hide?
    return false if !@battler.enemy.require_death_show_gauge
    if YEA::BATTLE::DEFEAT_ENEMIES_FIRST
      enemy_id = @battler.enemy_id
      return true unless $game_party.defeated_enemies.include?(enemy_id)
    end
    return false
  end
  
  #--------------------------------------------------------------------------
  # update_original_hide
  #--------------------------------------------------------------------------
  def update_original_hide
    return unless @original_hide
    return if @battler.dead?
    enemy_id = @battler.enemy_id
    @original_hide = false if $game_party.defeated_enemies.include?(enemy_id)
  end
  
  #--------------------------------------------------------------------------
  # update_position
  #--------------------------------------------------------------------------
  def update_position
    dx = @battler.screen_x - @start_width / 2
    dy = @battler.screen_y
    self.rect.x = dx
    self.rect.y = dy
    dh = self.rect.height + 1
    dh += 2 unless @type == :back
    dy = [@battler.screen_y, Graphics.height - dh - 120].min
    dy += 1 unless @type == :back
    self.rect.y = dy
  end
  
  #--------------------------------------------------------------------------
  # update_gauge
  #--------------------------------------------------------------------------
  def update_gauge
    return if @gauge_width == @target_gauge_width
    rate = 3
    @target_gauge_width = target_gauge_width
    if @gauge_width > @target_gauge_width
      @gauge_width = [@gauge_width - rate, @target_gauge_width].max
    elsif @gauge_width < @target_gauge_width
      @gauge_width = [@gauge_width + rate, @target_gauge_width].min
    end
    @visible_counter = @gauge_width == 0 ? 10 : 60
    return if @type == :back
    self.rect.width = @gauge_width
  end
  
  #--------------------------------------------------------------------------
  # target_gauge_rate
  #--------------------------------------------------------------------------
  def target_gauge_rate
    return @current_hp.to_f / @current_mhp.to_f
  end
  
  #--------------------------------------------------------------------------
  # target_gauge_width
  #--------------------------------------------------------------------------
  def target_gauge_width
    return [@current_hp * @start_width / @current_mhp, @start_width].min
  end
  
end # Enemy_HP_Gauge_Viewport

end # $imported["YEA-BattleEngine"]

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================