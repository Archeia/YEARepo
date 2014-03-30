#==============================================================================
# 
# ▼ Yanfly Engine Ace - Base Troop Events v1.00
# -- Last Updated: 2011.12.06
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-BaseTroopEvents"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.06 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# For all the eventers out there who love to customize their battles through
# custom event pages, you can now save yourself some time by drawing all the
# event pages from a base troop event to occur in every fight. All of the
# events will be present in every single battle.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# Edit the settings in the module below.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module BASE_TROOP_EVENTS
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Recurring Troop Event Setting -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Change the value below to the Troop ID that you want all of the
    # recurring troop events to draw from. All of the pages, conditions, and
    # spans will be copied over.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    BASE_TROOP_ID = 1
    
  end # BASE_TROOP_EVENTS
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_bte load_database; end
  def self.load_database
    load_database_bte
    load_troop_events
  end
  
  #--------------------------------------------------------------------------
  # new method: load_troop_events
  #--------------------------------------------------------------------------
  def self.load_troop_events
    for troop in $data_troops
      next if troop.nil?
      troop.add_pages
    end
  end
  
end # DataManager

#==============================================================================
# ■ RPG::Troop
#==============================================================================

class RPG::Troop
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :pages
  
  #--------------------------------------------------------------------------
  # new method: add_pages
  #--------------------------------------------------------------------------
  def add_pages
    return if self == $data_troops[YEA::BASE_TROOP_EVENTS::BASE_TROOP_ID]
    @pages += $data_troops[YEA::BASE_TROOP_EVENTS::BASE_TROOP_ID].pages.clone
  end
  
end # RPG::Troop

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================