#==============================================================================
# 
# ▼ Yanfly Engine Ace - Active Battle Advantage v1.00
# -- Last Updated: 2012.02.01
# -- Level: Easy, Normal, Hard
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-ActiveAdvantage"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.02.01 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Whenever a random encounter initiates, a gauge will appear on screen. And
# depending on the timing regarding a player's button input, the battle will
# start off as a pre-emptive attack for the party, a normal battle, or even a
# surprise attack from the enemy.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# Create or download an image with the filename "BattleAdvantage" within the
# Graphics\Pictures\ folder of your project.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module ACTIVE_ADVANTAGE
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Visual Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These are some visual settings applied to the Active Advantage gauge.
    # Change the colour settings here, the cursor used for indicating the
    # position of the the player advantage, and 
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    PREEMPTIVE_COLOUR =  3    # Text Colour used for pre-emptives.
    NORMAL_COLOUR     =  6    # Text Colour used for normal.
    SURPRISE_COLOUR   = 10    # Text Colour used for surprise attacks.
    BACK_GAUGE_COLOUR = 19    # Text Colour of the back of the gauge.
    
    CURSOR_ICON = 398         # Icon used for the gauge.
    
    # This picture is used for the battle advantage display. The following
    # string below determines what filename is used. Place this file inside of
    # the Graphics\Pictures\ folder.
    ADVANTAGE_PICTURE = "BattleAdvantage"
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Advantage Formulas -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # For those who would like to adjust the encounter advantage formulas, you
    # may do so below. It's highly recommended that you don't touch this unless
    # you are familiar with how encounter rates work.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    USE_CUSTOM_RATES = true   # Must be enabled to use formulas below.
    
    # This is the formula used for pre-emptive advantage.
    PRE_RATE = "(agi >= troop_agi ? 0.40 : 0.25) * (raise_preemptive? ? 2 : 1)"
    
    # This is the formula used for surprise attack.
    BAD_RATE = "cancel_surprise? ? 0 : (agi >= troop_agi ? 0.25 : 0.50)"
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Other Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These are some other settings used for this script. You can change the
    # sound played when the gauge appears, the flash colour, and the flash
    # length. Adjust them as you see fit.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    APPEAR_SOUND = RPG::SE.new("Battle2", 150)    # Sound played for advantage.
    FLASH_COLOUR = Color.new(255, 255, 255, 255)  # Flash colour for advantage.
    FLASH_LENGTH = 20                             # Duration of flash.
    
    # If for some reason, you wish to disable Active Advantage from occuring,
    # set the following value to a Switch ID you want to use. If it is 0, then
    # Active Advantage will always be on for random encounters.
    SWITCH = 0
    
  end # ACTIVE_ADVANTAGE
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

#==============================================================================
# ■ Switch
#==============================================================================

module Switch
  
  #--------------------------------------------------------------------------
  # self.active_advantage
  #--------------------------------------------------------------------------
  def self.active_advantage
    return true if YEA::ACTIVE_ADVANTAGE::SWITCH <= 0
    return $game_switches[YEA::ACTIVE_ADVANTAGE::SWITCH]
  end
  
end # Switch

#==============================================================================
# ■ BattleManager
#==============================================================================

module BattleManager
  
  #--------------------------------------------------------------------------
  # overwrite method: on_encounter
  #--------------------------------------------------------------------------
  def self.on_encounter
    if SceneManager.scene_is?(Scene_Map) && Switch.active_advantage
      SceneManager.scene.process_active_battle_advantage
    else
      @preemptive = (rand < rate_preemptive)
      @surprise = (rand < rate_surprise && !@preemptive)
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: set_advantage
  #--------------------------------------------------------------------------
  def self.set_advantage(preemptive, surprise)
    @preemptive = preemptive
    @surprise = surprise
  end
  
end # BattleManager

#==============================================================================
# ■ Game_Party
#==============================================================================

class Game_Party < Game_Unit
  
  if YEA::ACTIVE_ADVANTAGE::USE_CUSTOM_RATES
  #--------------------------------------------------------------------------
  # overwrite method: rate_preemptive
  #--------------------------------------------------------------------------
  def rate_preemptive(troop_agi)
    return [eval(YEA::ACTIVE_ADVANTAGE::PRE_RATE), 0.90].min
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: rate_surprise
  #--------------------------------------------------------------------------
  def rate_surprise(troop_agi)
    return [eval(YEA::ACTIVE_ADVANTAGE::BAD_RATE), 0.90].min
  end
  end # YEA::ACTIVE_ADVANTAGE::USE_CUSTOM_RATES
  
end # Game_Party

#==============================================================================
# ■ Sprite_BattleAdvantage
#==============================================================================

class Sprite_AdvantageTitle < Sprite
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(viewport = nil)
    super(viewport)
    create_bitmap
    reposition
  end
  
  #--------------------------------------------------------------------------
  # create_bitmap
  #--------------------------------------------------------------------------
  def create_bitmap
    self.bitmap = Cache.picture(YEA::ACTIVE_ADVANTAGE::ADVANTAGE_PICTURE)
  end
  
  #--------------------------------------------------------------------------
  # create_bitmap
  #--------------------------------------------------------------------------
  def reposition
    self.z = 800
    self.ox = self.bitmap.width / 2
    self.oy = self.bitmap.height
    self.x = Graphics.width / 2
    self.y = Graphics.height / 2 - 16
  end
  
  #--------------------------------------------------------------------------
  # dispose
  #--------------------------------------------------------------------------
  def dispose
    self.bitmap.dispose
    super
  end
  
end # Sprite_AdvantageTitle

#==============================================================================
# ■ Sprite_BattleAdvantage
#==============================================================================

class Sprite_BattleAdvantage < Sprite
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(viewport = nil)
    super(viewport)
    create_bitmap
    reposition
  end
  
  #--------------------------------------------------------------------------
  # create_bitmap
  #--------------------------------------------------------------------------
  def create_bitmap
    self.bitmap = Bitmap.new(450, 26)
    back_colour = text_colour(YEA::ACTIVE_ADVANTAGE::BACK_GAUGE_COLOUR)
    self.bitmap.fill_rect(self.bitmap.rect, back_colour)
    colour1 = text_colour(YEA::ACTIVE_ADVANTAGE::PREEMPTIVE_COLOUR)
    colour2 = text_colour(YEA::ACTIVE_ADVANTAGE::NORMAL_COLOUR)
    colour3 = text_colour(YEA::ACTIVE_ADVANTAGE::SURPRISE_COLOUR)
    #---
    @dw1 = (BattleManager.rate_preemptive * 200).to_i
    @dw3 = (BattleManager.rate_surprise * 200).to_i
    @dw2 = 400 - @dw1 - @dw3
    #---
    rect = Rect.new(1, 1, @dw1, 24)
    self.bitmap.fill_rect(rect, colour1)
    #---
    rect = Rect.new(rect.x + rect.width, 1, 24, 24)
    self.bitmap.gradient_fill_rect(rect, colour1, colour2)
    #---
    rect = Rect.new(rect.x + rect.width, 1, @dw2, 24)
    self.bitmap.fill_rect(rect, colour2)
    #---
    rect = Rect.new(rect.x + rect.width, 1, 24, 24)
    self.bitmap.gradient_fill_rect(rect, colour2, colour3)
    #---
    rect = Rect.new(rect.x + rect.width, 1, @dw3, 24)
    self.bitmap.fill_rect(rect, colour3)
  end
  
  #--------------------------------------------------------------------------
  # reposition
  #--------------------------------------------------------------------------
  def reposition
    self.z = 800
    self.ox = self.bitmap.width / 2
    self.oy = self.bitmap.height / 2
    self.x = Graphics.width / 2
    self.y = Graphics.height / 2 + 32
  end
  
  #--------------------------------------------------------------------------
  # text_colour
  #--------------------------------------------------------------------------
  def text_colour(n)
    windowskin = Cache.system("Window")
    windowskin.get_pixel(64 + (n % 8) * 8, 96 + (n / 8) * 8)
  end
  
  #--------------------------------------------------------------------------
  # dispose
  #--------------------------------------------------------------------------
  def dispose
    self.bitmap.dispose
    super
  end
  
end # Sprite_BattleAdvantage

#==============================================================================
# ■ Sprite_AdvantageCursor
#==============================================================================

class Sprite_AdvantageCursor < Sprite
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(viewport = nil)
    super(viewport)
    create_bitmap
    reposition
    @pos = 0
    @input_advantage = false
  end
  
  #--------------------------------------------------------------------------
  # create_bitmap
  #--------------------------------------------------------------------------
  def create_bitmap
    icon_bitmap = Cache.system("Iconset")
    icon_index = YEA::ACTIVE_ADVANTAGE::CURSOR_ICON
    src_rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
    self.bitmap = Bitmap.new(48, 48)
    self.bitmap.stretch_blt(self.bitmap.rect, icon_bitmap, src_rect)
  end
  
  #--------------------------------------------------------------------------
  # reposition
  #--------------------------------------------------------------------------
  def reposition
    self.x = Graphics.width / 2 - 224
    self.y = Graphics.height / 2 + 32
  end
  
  #--------------------------------------------------------------------------
  # dispose
  #--------------------------------------------------------------------------
  def dispose
    self.bitmap.dispose
    super
  end
  
  #--------------------------------------------------------------------------
  # update
  #--------------------------------------------------------------------------
  def update
    super
    return if end?
    return @input_advantage = true if Input.trigger?(:C)
    self.x += 8
    @pos += 8
  end
  
  #--------------------------------------------------------------------------
  # end?
  #--------------------------------------------------------------------------
  def end?
    return true if @input_advantage
    return @pos >= pos_end
  end
  
  #--------------------------------------------------------------------------
  # pos_end
  #--------------------------------------------------------------------------
  def pos_end
    return 440
  end
  
  #--------------------------------------------------------------------------
  # input_advantage
  #--------------------------------------------------------------------------
  def input_advantage
    dw1 = (BattleManager.rate_preemptive * 200).to_i
    dw3 = (BattleManager.rate_surprise * 200).to_i
    dw2 = 448 - dw1 - dw3
    if @pos <= dw1
      BattleManager.set_advantage(true, false)
    elsif @pos <= dw2
      BattleManager.set_advantage(false, false)
    else
      BattleManager.set_advantage(false, true)
    end
  end
  
end # Sprite_AdvantageCursor

#==============================================================================
# ■ Spriteset_Map
#==============================================================================

class Spriteset_Map
  
  #--------------------------------------------------------------------------
  # new method: create_battle_advantage_sprites
  #--------------------------------------------------------------------------
  def create_battle_advantage_sprites
    @battle_advantage_title  = Sprite_AdvantageTitle.new(@viewport3)
    @battle_advantage_sprite = Sprite_BattleAdvantage.new(@viewport3)
    @battle_advantage_cursor = Sprite_AdvantageCursor.new(@viewport3)
    @battle_advantage_cursor.z = @battle_advantage_sprite.z + 1
  end
  
  #--------------------------------------------------------------------------
  # alias method: dispose
  #--------------------------------------------------------------------------
  alias spriteset_map_dispose_aba dispose
  def dispose
    dispose_battle_advantage_sprites
    spriteset_map_dispose_aba
  end
  
  #--------------------------------------------------------------------------
  # new method: dispose_battle_advantage_sprites
  #--------------------------------------------------------------------------
  def dispose_battle_advantage_sprites
    @battle_advantage_title.dispose unless @battle_advantage_title.nil?
    @battle_advantage_sprite.dispose unless @battle_advantage_sprite.nil?
    @battle_advantage_cursor.dispose unless @battle_advantage_cursor.nil?
  end
  
  #--------------------------------------------------------------------------
  # alias method: update
  #--------------------------------------------------------------------------
  alias spriteset_map_update_aba update
  def update
    spriteset_map_update_aba
    update_battle_advantage_sprites
  end
  
  #--------------------------------------------------------------------------
  # new method: update_battle_advantage_sprites
  #--------------------------------------------------------------------------
  def update_battle_advantage_sprites
    @battle_advantage_title.update unless @battle_advantage_title.nil?
    @battle_advantage_sprite.update unless @battle_advantage_sprite.nil?
    @battle_advantage_cursor.update unless @battle_advantage_cursor.nil?
  end
  
  #--------------------------------------------------------------------------
  # new method: advantage_cursor
  #--------------------------------------------------------------------------
  def advantage_cursor
    return @battle_advantage_cursor
  end
  
end # Spriteset_Map

#==============================================================================
# ■ Scene_Map
#==============================================================================

class Scene_Map < Scene_Base
  
  #--------------------------------------------------------------------------
  # new method: process_active_battle_advantage
  #--------------------------------------------------------------------------
  def process_active_battle_advantage
    @spriteset.create_battle_advantage_sprites
    YEA::ACTIVE_ADVANTAGE::APPEAR_SOUND.play
    flash_colour = YEA::ACTIVE_ADVANTAGE::FLASH_COLOUR
    flash_length = YEA::ACTIVE_ADVANTAGE::FLASH_LENGTH
    $game_map.screen.start_flash(flash_colour, flash_length)
    update_active_battle_advantage
  end
  
  #--------------------------------------------------------------------------
  # new method: update_active_battle_advantage
  #--------------------------------------------------------------------------
  def update_active_battle_advantage
    loop do
      break if @spriteset.advantage_cursor.end?
      update_battle_advantage_graphics
    end
    @spriteset.advantage_cursor.input_advantage
  end
  
  #--------------------------------------------------------------------------
  # new method: update_battle_advantage_graphics
  #--------------------------------------------------------------------------
  def update_battle_advantage_graphics
    Graphics.update
    Input.update
    update_all_windows
    $game_map.update
    @spriteset.update
  end
  
end # Scene_Map

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================