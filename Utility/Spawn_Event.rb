#==============================================================================
# 
# ▼ Yanfly Engine Ace - Spawn Event v1.00
# -- Last Updated: 2012.02.08
# -- Level: Normal, Hard
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-SpawnEvent"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.02.08 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# For those who would like to spawn pre-made events from the current map or
# even other maps, this script allows you to do so. With the option of spawning
# the events at specific locations or a random spot marked by a certain region,
# you can have events spawn using simple script calls. The events remain until
# a map change.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Script Calls - These commands are used with script calls.
# -----------------------------------------------------------------------------
# spawn_event_location(x, y, event_id)
# spawn_event_location(x, y, event_id, map_id)
# This causes a new event to be created at location x and y on the current map.
# The event to be created will use the event data from event_id. If no map_id
# is used, then the current map's event will be used to spawn the new event.
# The event cannot spawn on top of another event or vehicle. If there is an
# event or vehicle in place, then no event will be spawned at all.
# 
# spawn_event_region(region_id, event_id)
# spawn_event_region(region_id, event_id, map_id)
# This causes a new event to be created at a random location with a matching
# region_id. The event to be created will use the event data from event_id. If
# no map_id is used, then the current map's event will be used to spawn the
# new event. If the region_id does not exist on the current map, then no event
# will be spawned. The event will not spawn on top of another event nor on top
# of a vehicle. If there is not enough room to spawn an event, then no event
# will be spawned at all. This process takes slightly longer on larger maps.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

#==============================================================================
# ■ Game_Map
#==============================================================================

class Game_Map
  
  #--------------------------------------------------------------------------
  # new method: spawn_event
  #--------------------------------------------------------------------------
  def spawn_event(dx, dy, event_id, map_id)
    return if $game_player.collide_with_characters?(dx, dy)
    return if dx == $game_player.x && dy == $game_player.y
    map_id = @map_id if map_id == 0
    map = load_data(sprintf("Data/Map%03d.rvdata2", map_id))
    event = generated_event(map, event_id)
    return if event.nil?
    key_id = @events.keys.max || 0 + 1
    @events[key_id] = Game_Event.new(@map_id, event)
    @events[key_id].moveto(dx, dy)
    SceneManager.scene.spriteset.refresh_characters
  end
  
  #--------------------------------------------------------------------------
  # new method: generated_event
  #--------------------------------------------------------------------------
  def generated_event(map, event_id)
    for key in map.events
      event = key[1]
      next if event.nil?
      return event if event.id == event_id
    end
    return nil
  end
  
  #--------------------------------------------------------------------------
  # new method: spawn_event_region
  #--------------------------------------------------------------------------
  def spawn_event_region(reg_id, event_id, map_id)
    tile = get_random_region_tile(reg_id)
    return if tile.nil?
    spawn_event(tile[0], tile[1], event_id, map_id)
  end
  
  #--------------------------------------------------------------------------
  # new method: get_random_region_tile
  #--------------------------------------------------------------------------
  def get_random_region_tile(reg_id)
    tiles = []
    for i in 0...width
      for j in 0...height
        next unless region_id(i, j) == reg_id
        next if $game_player.collide_with_characters?(i, j)
        next if i == $game_player.x && j == $game_player.y
        tiles.push([i, j])
      end
    end
    return tiles.sample
  end
  
end # Game_Map

#==============================================================================
# ■ Game_Interpreter
#==============================================================================

class Game_Interpreter
  
  #--------------------------------------------------------------------------
  # new method: spawn_event_location
  #--------------------------------------------------------------------------
  def spawn_event_location(dx, dy, event_id, map_id = 0)
    return unless SceneManager.scene_is?(Scene_Map)
    $game_map.spawn_event(dx, dy, event_id, map_id)
  end
  
  #--------------------------------------------------------------------------
  # new method: spawn_event_region
  #--------------------------------------------------------------------------
  def spawn_event_region(region_id, event_id, map_id = 0)
    return unless SceneManager.scene_is?(Scene_Map)
    $game_map.spawn_event_region(region_id, event_id, map_id)
  end
  
end # Game_Interpreter

#==============================================================================
# ■ Scene_Map
#==============================================================================

class Scene_Map < Scene_Base
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :spriteset
  
end # Scene_Map

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================
