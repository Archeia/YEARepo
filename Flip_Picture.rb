#==============================================================================
# 
# ▼ Yanfly Engine Ace - Flip Picture v1.00
# -- Last Updated: 2011.12.03
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-FlipPicture"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.03 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# RPG Maker VX Ace lacks the ability to flip pictures and show a mirrored
# version of them. Now, through the aid of a switch, you can mirror pictures
# once that switch is on, and unmirror pictures once that switch is off.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# Go to the module and bind FLIP_PICTURE_SWITCH to a switch you want to
# designate for picture flipping.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module UTILITY
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Flip Picture Switch -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # When this switch is ON, any picture events following will be mirrored.
    # Once this switch is OFF, any picture events following will be normal.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    FLIP_PICTURE_SWITCH = 21
    
  end # UTILITY
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
  # self.Switch
  #--------------------------------------------------------------------------
  def self.flip_picture
    return $game_switches[YEA::UTILITY::FLIP_PICTURE_SWITCH]
  end
    
end # Switch

#==============================================================================
# ■ Game_Picture
#==============================================================================

class Game_Picture
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :mirror
  
  #--------------------------------------------------------------------------
  # alias method: initialize
  #--------------------------------------------------------------------------
  alias game_picture_initialize_fp initialize
  def initialize(number)
    game_picture_initialize_fp(number)
    @mirror = false
  end
  
  #--------------------------------------------------------------------------
  # alias method: show
  #--------------------------------------------------------------------------
  alias game_picture_show_fp show
  def show(*args)
    game_picture_show_fp(*args)
    @mirror = Switch.flip_picture
  end
  
  #--------------------------------------------------------------------------
  # alias method: move
  #--------------------------------------------------------------------------
  alias game_picture_move_fp move
  def move(*args)
    game_picture_move_fp(*args)
    @mirror = Switch.flip_picture
  end
  
  #--------------------------------------------------------------------------
  # alias method: rotate
  #--------------------------------------------------------------------------
  alias game_picture_rotate_fp rotate
  def rotate(speed)
    game_picture_rotate_fp(speed)
    @mirror = Switch.flip_picture
  end
  
  #--------------------------------------------------------------------------
  # alias method: start_tone_change
  #--------------------------------------------------------------------------
  alias start_tone_change_fp start_tone_change
  def start_tone_change(tone, duration)
    @mirror = Switch.flip_picture
  end
  
end # Game_Picture

#==============================================================================
# ■ Sprite_Picture
#==============================================================================

class Sprite_Picture < Sprite
  
  #--------------------------------------------------------------------------
  # alias method: update
  #--------------------------------------------------------------------------
  alias sprite_picture_update_fp update
  def update
    sprite_picture_update_fp
    self.mirror = @picture.mirror
  end
  
end # Sprite_Picture

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================