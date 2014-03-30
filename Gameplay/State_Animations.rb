#==============================================================================
# 
# ▼ Yanfly Engine Ace - State Animations v1.00
# -- Last Updated: 2011.12.23
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-StateAnimations"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.23 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# A missing feature from RPG Maker XP. Status effects had animations replaying
# on them constantly to indicate that a user was affected by a state. Only the
# state with the highest priority and possesses an animation will be played.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# State Notetags - These notetags go in the states notebox in the database.
# -----------------------------------------------------------------------------
# <state ani: x>
# Causes the status effect to play battle animation x repeatedly on the battler
# if the battler is affected by this state and if this state is the highest
# priority state with an animation.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module STATE_ANIMATION
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Adjust the state animation settings here. -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These settings decide whether or not state animations will cause the
    # screen to flash, play sound effects, and what kinds of zoom levels will
    # be used on actors affected by states with animations.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    PLAY_SOUND = false      # Play sounds for state animations?
    PLAY_FLASH = false      # Use screen flash for state animations?
    
    PLAY_ACTOR = true       # Play animations on the actor?
    ACTOR_ZOOM = 0.25       # Zoom level for animations on actors.
    
  end # STATE_ANIMATION
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module STATE
    
    STATEANI = /<(?:STATE_ANIMATION|state ani|animation|ani):[ ](\d+)>/i
    
  end # STATE
  end # REGEXP
end # YEA

#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_sani load_database; end
  def self.load_database
    load_database_sani
    load_notetags_sani
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_sani
  #--------------------------------------------------------------------------
  def self.load_notetags_sani
    for state in $data_states
      next if state.nil?
      state.load_notetags_sani
    end
  end
  
end # DataManager

#==============================================================================
# ■ RPG::State
#==============================================================================

class RPG::State < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :state_animation
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_sani
  #--------------------------------------------------------------------------
  def load_notetags_sani
    @state_animation = 0
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::STATE::STATEANI
        @state_animation = $1.to_i
      end
    } # self.note.split
    #---
  end
  
end # RPG::State

#==============================================================================
# ■ Sprite_Battler
#==============================================================================

class Sprite_Battler < Sprite_Base
  
  #--------------------------------------------------------------------------
  # class variables
  #--------------------------------------------------------------------------
  @@state_ani_checker = []
  @@state_ani_spr_checker = []
  @@state_ani_reference_count = {}
  
  #--------------------------------------------------------------------------
  # alias method: initialize
  #--------------------------------------------------------------------------
  alias sprite_battler_initialize_sani initialize
  def initialize(viewport, battler = nil)
    sprite_battler_initialize_sani(viewport, battler)
    @state_ani_duration = 0
  end
  
  #--------------------------------------------------------------------------
  # alias method: dispose
  #--------------------------------------------------------------------------
  alias sprite_battler_dispose_sani dispose
  def dispose
    dispose_state_animation
    sprite_battler_dispose_sani
  end
  
  #--------------------------------------------------------------------------
  # alias method: setup_new_effect
  #--------------------------------------------------------------------------
  alias sprite_battler_setup_new_effect_sani setup_new_effect
  def setup_new_effect
    sprite_battler_setup_new_effect_sani
    setup_state_ani_effect
  end
  
  #--------------------------------------------------------------------------
  # new method: setup_state_ani_effect
  #--------------------------------------------------------------------------
  def setup_state_ani_effect
    return if @battler.state_animation_id.nil?
    if @battler.state_animation_id == 0
      dispose_state_animation
    else
      animation = $data_animations[@battler.state_animation_id]
      start_state_animation(animation)
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: update
  #--------------------------------------------------------------------------
  alias sprite_battler_update_sani update
  def update
    sprite_battler_update_sani
    update_state_animations
  end
  
  #--------------------------------------------------------------------------
  # new method: update_state_animations
  #--------------------------------------------------------------------------
  def update_state_animations
    update_state_animation
    @@state_ani_checker.clear
    @@state_ani_spr_checker.clear
  end
  
  #--------------------------------------------------------------------------
  # new method: state_animation?
  #--------------------------------------------------------------------------
  def state_animation?
    return !@state_animation.nil?
  end
  
  #--------------------------------------------------------------------------
  # new method: start_state_animation
  #--------------------------------------------------------------------------
  def start_state_animation(animation, mirror = false)
    return if !@state_animation.nil? && @state_animation.id == animation.id
    dispose_state_animation
    @state_animation = animation
    return if @state_animation.nil?
    @state_ani_mirror = mirror
    set_animation_rate
    @state_ani_duration = @state_animation.frame_max * @ani_rate + 1
    load_state_animation_bitmap
    make_state_animation_sprites
    set_state_animation_origin
  end
  
  #--------------------------------------------------------------------------
  # new method: load_state_animation_bitmap
  #--------------------------------------------------------------------------
  def load_state_animation_bitmap
    animation1_name = @state_animation.animation1_name
    animation1_hue = @state_animation.animation1_hue
    animation2_name = @state_animation.animation2_name
    animation2_hue = @state_animation.animation2_hue
    @state_ani_bitmap1 = Cache.animation(animation1_name, animation1_hue)
    @state_ani_bitmap2 = Cache.animation(animation2_name, animation2_hue)
    if @@state_ani_reference_count.include?(@state_ani_bitmap1)
      @@state_ani_reference_count[@state_ani_bitmap1] += 1
    else
      @@state_ani_reference_count[@state_ani_bitmap1] = 1
    end
    if @@state_ani_reference_count.include?(@ani_bitmap2)
      @@state_ani_reference_count[@state_ani_bitmap2] += 1
    else
      @@state_ani_reference_count[@state_ani_bitmap2] = 1
    end
    Graphics.frame_reset
  end
  
  #--------------------------------------------------------------------------
  # new method: make_state_animation_sprites
  #--------------------------------------------------------------------------
  def make_state_animation_sprites
    @state_ani_sprites = []
    if @use_sprite && !@@state_ani_spr_checker.include?(@state_animation)
      16.times do
        sprite = ::Sprite.new(viewport)
        sprite.visible = false
        @state_ani_sprites.push(sprite)
      end
      if @state_animation.position == 3
        @@state_ani_spr_checker.push(@animation)
      end
    end
    @state_ani_duplicated = @@state_ani_checker.include?(@state_animation)
    if !@state_ani_duplicated && @state_animation.position == 3
      @@state_ani_checker.push(@state_animation)
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: set_state_animation_origin
  #--------------------------------------------------------------------------
  def set_state_animation_origin
    if @state_animation.position == 3
      if viewport == nil
        @state_ani_ox = Graphics.width / 2
        @state_ani_oy = Graphics.height / 2
      else
        @state_ani_ox = viewport.rect.width / 2
        @state_ani_oy = viewport.rect.height / 2
      end
    else
      @state_ani_ox = x - ox + width / 2
      @state_ani_oy = y - oy + height / 2
      if @state_animation.position == 0
        @state_ani_oy -= height / 2
      elsif @state_animation.position == 2
        @state_ani_oy += height / 2
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: dispose_state_animation
  #--------------------------------------------------------------------------
  def dispose_state_animation
    if @state_ani_bitmap1
      @@state_ani_reference_count[@state_ani_bitmap1] -= 1
      if @@state_ani_reference_count[@state_ani_bitmap1] == 0
        @state_ani_bitmap1.dispose
      end
    end
    if @state_ani_bitmap2
      @@state_ani_reference_count[@state_ani_bitmap2] -= 1
      if @@state_ani_reference_count[@state_ani_bitmap2] == 0
        @state_ani_bitmap2.dispose
      end
    end
    if @state_ani_sprites
      @state_ani_sprites.each {|sprite| sprite.dispose }
      @state_ani_sprites = nil
      @state_animation = nil
    end
    @state_ani_bitmap1 = nil
    @state_ani_bitmap2 = nil
  end
  
  #--------------------------------------------------------------------------
  # new method: update_state_animation
  #--------------------------------------------------------------------------
  def update_state_animation
    return unless state_animation?
    @state_ani_duration -= 1
    if @state_ani_duration % @ani_rate == 0
      if @state_ani_duration > 0
        @state_frame_index = @state_animation.frame_max
        change = (@state_ani_duration + @ani_rate - 1) / @ani_rate
        @state_frame_index -= change
        @state_animation.timings.each do |timing|
          next unless timing.frame == @state_frame_index
          state_animation_process_timing(timing)
        end
      else
        @state_ani_duration = @state_animation.frame_max * @ani_rate + 1
      end
    end
    return if @state_frame_index.nil?
    state_animation_set_sprites(@state_animation.frames[@state_frame_index])
    set_state_animation_origin
  end
  
  #--------------------------------------------------------------------------
  # new method: end_state_animation
  #--------------------------------------------------------------------------
  def end_state_animation
    dispose_state_animation
  end
  
  #--------------------------------------------------------------------------
  # new method: state_animation_set_sprites
  #--------------------------------------------------------------------------
  def state_animation_set_sprites(frame)
    return if @state_animation.nil?
    return if frame.nil?
    cell_data = frame.cell_data
    @state_ani_sprites.each_with_index do |sprite, i|
      next unless sprite
      pattern = cell_data[i, 0]
      if !pattern || pattern < 0
        sprite.visible = false
        next
      end
      sprite.bitmap = pattern < 100 ? @state_ani_bitmap1 : @state_ani_bitmap2
      sprite.visible = true
      sprite.src_rect.set(pattern % 5 * 192,
        pattern % 100 / 5 * 192, 192, 192)
      if @state_ani_mirror
        sprite.x = @state_ani_ox - cell_data[i, 1]
        sprite.y = @state_ani_oy + cell_data[i, 2]
        sprite.angle = (360 - cell_data[i, 4])
        sprite.mirror = (cell_data[i, 5] == 0)
      else
        sprite.x = @state_ani_ox + cell_data[i, 1]
        sprite.y = @state_ani_oy + cell_data[i, 2]
        sprite.angle = cell_data[i, 4]
        sprite.mirror = (cell_data[i, 5] == 1)
      end
      sprite.z = self.z + 250 + i
      sprite.ox = 96
      sprite.oy = 96
      sprite.zoom_x = cell_data[i, 3] / 100.0
      sprite.zoom_y = cell_data[i, 3] / 100.0
      if @battler.actor?
        zoom = YEA::STATE_ANIMATION::ACTOR_ZOOM
        sprite.zoom_x *= zoom
        sprite.zoom_y *= zoom
      end
      sprite.opacity = cell_data[i, 6] * self.opacity / 255.0
      sprite.blend_type = cell_data[i, 7]
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: state_animation_process_timing
  #--------------------------------------------------------------------------
  def state_animation_process_timing(timing)
    timing.se.play if YEA::STATE_ANIMATION::PLAY_SOUND
    case timing.flash_scope
    when 1
      self.flash(timing.flash_color, timing.flash_duration * @ani_rate)
    when 2
      return unless YEA::STATE_ANIMATION::PLAY_FLASH
      if viewport && !@state_ani_duplicated
        flash_amount = timing.flash_duration * @ani_rate
        viewport.flash(timing.flash_color, flash_amount)
      end
    when 3
      self.flash(nil, timing.flash_duration * @ani_rate)
    end
  end
  
end # Sprite_Battler

#==============================================================================
# ■ Game_BattlerBase
#==============================================================================

class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :state_animation_id
  
  #--------------------------------------------------------------------------
  # alias method: refresh
  #--------------------------------------------------------------------------
  alias game_battlerbase_refresh_sani refresh
  def refresh
    game_battlerbase_refresh_sani
    reload_state_animation
  end
  
  #--------------------------------------------------------------------------
  # new method: reload_state_animation
  #--------------------------------------------------------------------------
  def reload_state_animation
    @state_animation_id = 0
    return if actor? && !YEA::STATE_ANIMATION::PLAY_ACTOR
    for state in states
      next unless state.state_animation > 0
      @state_animation_id = state.state_animation
      break
    end
  end
  
end # Game_BattlerBase

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================