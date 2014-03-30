#==============================================================================
# 
# ▼ Yanfly Engine Ace - Party Sized Menu v1.00
# -- Last Updated: 2012.01.05
# -- Level: Easy
# -- Requires: Requires YEA - Ace Menu Engine v1.00+
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-PartySizedMenu"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.05 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This is just a small script to adjust the size of the party window in the
# main menu and other menus to the maximum possible battle members (up to a
# maximum of 5 members) to show up on screen without leaving out vital data.
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
# This script requires Yanfly Engine Ace - Ace Menu Engine v1.00+. Place this
# script under Yanfly Engine Ace - Ace Menu Engine in the script listing.
# 
#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

if $imported["YEA-AceMenuEngine"]

#==============================================================================
# ■ Window_MenuStatus
#==============================================================================

class Window_MenuStatus < Window_Selectable
  
  #--------------------------------------------------------------------------
  # overwrite method: item_height
  #--------------------------------------------------------------------------
  def item_height
    return (height - standard_padding * 2) / member_size
  end
  
  #--------------------------------------------------------------------------
  # new method: member_size
  #--------------------------------------------------------------------------
  def member_size
    return [$game_party.max_battle_members, 5].min
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_face
  #--------------------------------------------------------------------------
  def draw_face(face_name, face_index, dx, dy, enabled = true)
    bitmap = Cache.face(face_name)
    ry = [(96 - item_rect(0).height + 1) / 2, 0].max
    rh = [item_rect(0).height - 2, 96].min
    rect = Rect.new(face_index % 4 * 96, face_index / 4 * 96 + ry, 96, rh)
    contents.blt(dx, dy, bitmap, rect, enabled ? 255 : translucent_alpha)
    bitmap.dispose
  end
  
end # Window_MenuStatus

end # $imported["YEA-AceMenuEngine"]

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================