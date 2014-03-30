=begin

This is Yami's fix for the revival and item animations in Ace Battle Engine.
Put this below all the other scripts.

~Archeia

=end


#==============================================================================
# ■ Sprite_Battler
#==============================================================================

class Sprite_Battler < Sprite_Base
  
  #--------------------------------------------------------------------------
  # alias method: animation_set_sprites
  # Make Animation Opacity independent of Sprite Opacity
  #--------------------------------------------------------------------------
  alias yami_fix_revival_animation_set_sprites animation_set_sprites
  def animation_set_sprites(frame)
    yami_fix_revival_animation_set_sprites(frame)
    cell_data = frame.cell_data
    @ani_sprites.each_with_index do |sprite, i|
      next unless sprite
      pattern = cell_data[i, 0]
      if !pattern || pattern < 0
        sprite.visible = false
        next
      end
      sprite.opacity = cell_data[i, 6]
    end
  end
  
end # Sprite_Battler