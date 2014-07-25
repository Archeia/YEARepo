#==============================================================================
# 
# ▼ Yanfly Engine Ace - Event Chase Player v1.00
# -- Last Updated: 2012.01.05
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-EventChasePlayer"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.05 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script allows you to make events that will chase the player or flee from
# the player when the player enters within range of the event or when the event
# sees the player. 
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Move Script Call - Open up the script call in the event move menu and use:
# -----------------------------------------------------------------------------
# Add these variable changes to an event's move route to use them.
# 
# @chase_range = x
# Event will chase the player after reaching x range.
# 
# @flee_range = x
# Event will flee from player after reaching x range.
# 
# @chase_speed = x
# Event will move at x speed when chasing.
# 
# @flee_speed = x
# Event will move at x speed when fleeing.
# 
# @sight_lock = x
# Event will chase/flee from player for x frames.
# 
# @alert_balloon = x
# Event will show ballon ID x when chasing or fleeing.
# 
# @alert_sound = x
# Event will play this sound upon sighting the player 
#
# @see_player = true
# For events that require them to see the player first, use this script call
# inside the movement boxes. This does not follow line of sight rules, which
# means if there's a rock blocking you and the event, it will still see you.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module EVENT_CHASE
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - General Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These settings adjust some general settings regarding chasing and fleeing
    # events. Adjust them as you see fit.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # The number of frames before a balloon can show up again on the same
    # event. This is to prevent a massive balloon spamming. 60 frames = 1 sec.
    # By default, 120 frames is 2 seconds.
    ALERT_TIMER = 120
    
    # This is the default number of frames for how long the event will chase or
    # flee from the player if used with @see_player = true. To change the amount
    # individually for each event, use @sight_lock = x where x is a number.
    # By default, 300 frames is 5 seconds.
    SIGHT_LOCK = 300
    
  end # EVENT_CHASE
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

#==============================================================================
# ■ Game_Event
#==============================================================================

class Game_Event < Game_Character
  
  #--------------------------------------------------------------------------
  # alias method: update_self_movement
  #--------------------------------------------------------------------------
  alias game_event_update_self_movement_ecp update_self_movement
  def update_self_movement
    return if $imported["YEA-StopAllMovement"] && Switch.stop_npc_movement
    update_chase_distance
    update_flee_distance
    if @stop_count > 0 && @chase_player
      move_type_toward_player
    elsif @stop_count > 0 && @flee_player
      move_type_away_player
    else
      game_event_update_self_movement_ecp
    end
    update_alert_balloon	
  end
  
  #--------------------------------------------------------------------------
  # new method: update_chase_distance
  #--------------------------------------------------------------------------
  def update_chase_distance
    return if @erased
    return if @chase_range.nil?
    dis = distance_x_from($game_player.x).abs
    dis += distance_y_from($game_player.y).abs
    if chase_conditions
      @chase_player = true
      @move_speed = @chase_speed unless @chase_speed.nil?
    else
      @chase_player = false
      @move_speed = @page.move_speed
      @alert_player = false if @alert_timer <= 0
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: chase_conditions
  #--------------------------------------------------------------------------
  def chase_conditions
    dis = distance_x_from($game_player.x).abs
    dis += distance_y_from($game_player.y).abs
    return true if @alert_lock > 0
    return true if dis <= @chase_range and see_player?
    if dis <= @chase_range && @see_player != true
      @alert_lock = @sight_lock if @sight_lock != nil && @sight_lock > 0
      return true
    end
    return false
  end
  
  #--------------------------------------------------------------------------
  # new method: update_flee_distance
  #--------------------------------------------------------------------------
  def update_flee_distance
    return if @erased
    return if @flee_range.nil?
    dis = distance_x_from($game_player.x).abs
    dis += distance_y_from($game_player.y).abs
    if flee_conditions
      @flee_player = true
      @move_speed = @flee_speed unless @flee_speed.nil?
    else
      @flee_player = false
      @move_speed = @page.move_speed
      @alert_player = false if @alert_timer <= 0
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: flee_conditions
  #--------------------------------------------------------------------------
  def flee_conditions
    dis = distance_x_from($game_player.x).abs
    dis += distance_y_from($game_player.y).abs
    return true if @alert_lock > 0
    return true if dis <= @flee_range and see_player?
    if dis <= @flee_range && @see_player != true
      @alert_lock = @sight_lock if @sight_lock != nil && @sight_lock > 0
      return true
    end
    return false
  end
  
  #--------------------------------------------------------------------------
  # new method: update_alert_balloon
  #--------------------------------------------------------------------------
  def update_alert_balloon
    return if @erased
    @alert_timer = 0 if @alert_timer.nil?
    @alert_lock = 0 if @alert_lock.nil?
    @alert_lock -= 1 if @alert_lock >= 0
    return if @alert_balloon == nil || @alert_balloon == 0
    if (@chase_player || @flee_player) && !@alert_player
      @balloon_id = @alert_balloon
      @alert_player = true
      @alert_timer = YEA::EVENT_CHASE::ALERT_TIMER
	  RPG::SE.new(@alert_sound, 100, 100).play unless @alert_sound.nil?
    end
    @alert_timer -= 1 if @alert_player
  end
  
  #--------------------------------------------------------------------------
  # new method: see_player?
  #--------------------------------------------------------------------------
  def see_player?
    return false if @see_player != true
    sx = distance_x_from($game_player.x)
    sy = distance_y_from($game_player.y)
    if sx.abs > sy.abs
      direction = sx > 0 ? 4 : 6
    else
      direction = sy > 0 ? 8 : 2
    end
    if direction == @direction
      if @sight_lock == nil || @sight_lock <= 0
        @sight_lock = YEA::EVENT_CHASE::SIGHT_LOCK
      end
      @alert_lock = @sight_lock
      return true
    end
    return false
  end
  
  #--------------------------------------------------------------------------
  # new method: move_type_away_player
  #--------------------------------------------------------------------------
  def move_type_away_player
    sx = @x - $game_player.x
    sy = @y - $game_player.y
    if sx.abs + sy.abs >= 20
      move_random
    else
      case rand(6)
      when 0..3;  move_away_from_player
      when 4;     move_random
      when 5;     move_forward
      end
    end
  end
  
end # Game_Event

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================
