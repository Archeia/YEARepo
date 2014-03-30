#==============================================================================
# 
# ▼ Yanfly Engine: Area of Effect Add-On by SoulPour77
# -- Last Updated: 2014.03.27
# -- Level: Easy, Normal
# -- Requires: Yanfly Engine Ace - Area of Effect v1.02
#
# Use the notetag <target_animation> so it will display only one animation 
# along with the tag <one animation>.
#
#==============================================================================

class RPG::BaseItem
  
  def only_target_ani?
    if @only_target_ani.nil?
      @only_target_ani = (self.note =~ /<target_animation>/i ? true : false) 
    end
    @only_target_ani
  end
  
end


class Scene_Battle < Scene_Base
  
  alias :show_norm_anim_one_trg :show_normal_animation
  def show_normal_animation(targets, animation_id, mirror = false)
    if @subject.current_action.item.only_target_ani?
      show_only_target_animation(animation_id, mirror)
    else
      show_norm_anim_one_trg(targets, animation_id, mirror)
    end
  end
  
  def show_only_target_animation(animation_id, mirror = false)
    if @subject.current_action.item.for_opponent?
      target = @subject.opponents_unit.smooth_target(@subject.current_action.target_index)
    else
      target = @subject.friends_unit.smooth_target(@subject.current_action.target_index)
    end
    target.animation_id = animation_id
    target.animation_mirror = mirror
    abs_wait_short
  end
  
end