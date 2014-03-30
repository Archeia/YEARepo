#==============================================================================
# 
# ▼ Yanfly Engine Ace - Call Event v1.00
# -- Last Updated: 2011.12.14
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-CallEvent"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.14 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This is a reproduced method from RPG Maker 2000 and RPG Maker 2003. It allows
# the game to call a page's events as if it were a common event. These events
# can be drawn from any event on any map within the game.
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
# call_event(event_id)
# call_event(event_id, page_id)
# call_event(event_id, page_id, map_id)
# 
# Replace event_id, page_id, and map_id with the ID's of the actual events.
# To find out the event_id, double click the event to open up the event editor
# window. The ID should show up in the upper left corner. The page_id is the
# page the event is on. The first page is 1, not 0. The map_id can be found by
# opening the map properties window and it'll show up in the title bar.
# 
# If the page ID is not present in the call event, the page will automatically
# be assumed to be page 1.
# 
# If the map ID is not present in the call event, the map the player is
# currently on will be used instead.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module CALL_EVENT
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Print Errors -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # If you're in test mode, produce an error from a called event, this will
    # print out what part of the call event produced a script error.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    PRINT_ERROR = true
    
  end # CALL_EVENT
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

#==============================================================================
# ■ Game_Interpreter
#==============================================================================

class Game_Interpreter
  
  #--------------------------------------------------------------------------
  # new method: call_event
  #--------------------------------------------------------------------------
  def call_event(event_id, page_id = 1, map_id = nil)
    page_id = [page_id, 1].max
    event_id = [event_id, 1].max
    map_id = $game_map.map_id if map_id.nil?
    return if call_event_fail?(event_id, page_id, map_id)
    map = load_data(sprintf("Data/Map%03d.rvdata2", map_id))
    event = map.events[event_id].pages[page_id-1]
    child = Game_Interpreter.new(@depth + 1)
    child.setup(event.list, same_map? ? @event_id : 0)
    child.run
  end
  
  #--------------------------------------------------------------------------
  # new method: call_event_fail?
  #--------------------------------------------------------------------------
  def call_event_fail?(event_id, page_id, map_id)
    print_error = YEA::CALL_EVENT::PRINT_ERROR
    map = load_data(sprintf("Data/Map%03d.rvdata2", map_id))
    if map.nil?
      puts "Map:" + map_id.to_s + " isn't a callable map." if print_error
      return true
    end
    event = map.events[event_id]
    if event.nil?
      puts "Event:" + event_id.to_s + " isn't a callable event." if print_error
      return true
    end
    page = event.pages[page_id-1]
    if page.nil?
      puts "Page:" + page_id.to_s + " isn't a callable page." if print_error
      return true
    end
    return false
  end
  
end # Game_Interpreter

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================