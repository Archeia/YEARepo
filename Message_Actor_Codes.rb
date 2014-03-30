#==============================================================================
# 
# ▼ Yanfly Engine Ace - Ace Message System Add-On: Message Actor Codes v1.01
# -- Last Updated: 2012.01.13
# -- Level: Normal
# -- Requires: Yanfly Engine Ace - Ace Message System v1.03+
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-MessageActorCodes"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.13 - Bug Fixed: Negative tags didn't display other party members.
# 2012.01.12 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This is an add-on for the Ace Message System. For those who would like to
# write out the stats of an actor using codes, insert any of the following
# codes below to write out their values.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Message Window text Codes - These go inside of your message window.
# -----------------------------------------------------------------------------
#  Code:        Effect:
#    \level[x]  - Writes the level value of actor x. *Note
# 
#    \maxhp[x]  - Writes the MaxHP value of actor x. *Note
#    \maxmp[x]  - Writes the MaxMP value of actor x. *Note
#    \atk[x]    - Writes the ATK value of actor x. *Note
#    \def[x]    - Writes the DEF value of actor x. *Note
#    \mat[x]    - Writes the MAT value of actor x. *Note
#    \mdf[x]    - Writes the MDF value of actor x. *Note
#    \agi[x]    - Writes the AGI value of actor x. *Note
#    \luk[x]    - Writes the LUK value of actor x. *Note
# 
#    \hit[x]    - Writes the HIT value of actor x. *Note
#    \eva[x]    - Writes the EVA value of actor x. *Note
#    \cri[x]    - Writes the CRI value of actor x. *Note
#    \cev[x]    - Writes the CEV value of actor x. *Note
#    \mev[x]    - Writes the MEV value of actor x. *Note
#    \mrf[x]    - Writes the MRG value of actor x. *Note
#    \cnt[x]    - Writes the CNT value of actor x. *Note
#    \hrg[x]    - Writes the HRG value of actor x. *Note
#    \mrg[x]    - Writes the MRG value of actor x. *Note
#    \trg[x]    - Writes the TRG value of actor x. *Note
# 
#    \tgr[x]    - Writes the TGR value of actor x. *Note
#    \grd[x]    - Writes the GRD value of actor x. *Note
#    \rec[x]    - Writes the REC value of actor x. *Note
#    \pha[x]    - Writes the PHA value of actor x. *Note
#    \mcr[x]    - Writes the MCR value of actor x. *Note
#    \tcr[x]    - Writes the TCR value of actor x. *Note
#    \pdr[x]    - Writes the PDR value of actor x. *Note
#    \mdr[x]    - Writes the MDR value of actor x. *Note
#    \fdr[x]    - Writes the FDR value of actor x. *Note
#    \exr[x]    - Writes the EXR value of actor x. *Note
# 
#               *Note: If x is 0 or negative, it will show the respective
#               party member's face instead.
#                   0 - Party Leader
#                  -1 - 1st non-leader member.
#                  -2 - 2nd non-leader member. So on.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
# This script requires Yanfly Engine Ace - Ace Message System v1.03+. To ensure
# compatibility, place this script under Ace Message System in the script list.
# 
#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

if $imported["YEA-MessageSystem"]

#==============================================================================
# ■ Window_Base
#==============================================================================

class Window_Base < Window
  
  #--------------------------------------------------------------------------
  # alias method: convert_escape_characters
  #--------------------------------------------------------------------------
  alias window_base_convert_escape_characters_mac convert_escape_characters
  def convert_escape_characters(text)
    result = window_base_convert_escape_characters_mac(text)
    result = convert_message_actor_codes_new_escape_characters(result)
    return result
  end
  
  #--------------------------------------------------------------------------
  # new method: convert_message_actor_codes_new_escape_characters
  #--------------------------------------------------------------------------
  def convert_message_actor_codes_new_escape_characters(result)
    result.gsub!(/\eLEVEL\[([-+]?\d+)\]/i) { actor_level($1.to_i) }
    #---
    result.gsub!(/\eMAXHP\[([-+]?\d+)\]/i) { actor_param($1.to_i, 0) }
    result.gsub!(/\eMHP\[([-+]?\d+)\]/i)   { actor_param($1.to_i, 0) }
    result.gsub!(/\eMAXMP\[([-+]?\d+)\]/i) { actor_param($1.to_i, 1) }
    result.gsub!(/\eMMP\[([-+]?\d+)\]/i)   { actor_param($1.to_i, 1) }
    result.gsub!(/\eATK\[([-+]?\d+)\]/i)   { actor_param($1.to_i, 2) }
    result.gsub!(/\eDEF\[([-+]?\d+)\]/i)   { actor_param($1.to_i, 3) }
    result.gsub!(/\eMAT\[([-+]?\d+)\]/i)   { actor_param($1.to_i, 4) }
    result.gsub!(/\eINT\[([-+]?\d+)\]/i)   { actor_param($1.to_i, 4) }
    result.gsub!(/\eSPI\[([-+]?\d+)\]/i)   { actor_param($1.to_i, 4) }
    result.gsub!(/\eMDF\[([-+]?\d+)\]/i)   { actor_param($1.to_i, 5) }
    result.gsub!(/\eRES\[([-+]?\d+)\]/i)   { actor_param($1.to_i, 5) }
    result.gsub!(/\eAGI\[([-+]?\d+)\]/i)   { actor_param($1.to_i, 6) }
    result.gsub!(/\eSPD\[([-+]?\d+)\]/i)   { actor_param($1.to_i, 6) }
    result.gsub!(/\eLUK\[([-+]?\d+)\]/i)   { actor_param($1.to_i, 7) }
    #---
    result.gsub!(/\eHIT\[([-+]?\d+)\]/i)   { actor_xparam($1.to_i, 0) }
    result.gsub!(/\eEVA\[([-+]?\d+)\]/i)   { actor_xparam($1.to_i, 1) }
    result.gsub!(/\eCRI\[([-+]?\d+)\]/i)   { actor_xparam($1.to_i, 2) }
    result.gsub!(/\eCEV\[([-+]?\d+)\]/i)   { actor_xparam($1.to_i, 3) }
    result.gsub!(/\eMEV\[([-+]?\d+)\]/i)   { actor_xparam($1.to_i, 4) }
    result.gsub!(/\eMRF\[([-+]?\d+)\]/i)   { actor_xparam($1.to_i, 5) }
    result.gsub!(/\eCNT\[([-+]?\d+)\]/i)   { actor_xparam($1.to_i, 6) }
    result.gsub!(/\eHRG\[([-+]?\d+)\]/i)   { actor_xparam($1.to_i, 7) }
    result.gsub!(/\eMRG\[([-+]?\d+)\]/i)   { actor_xparam($1.to_i, 8) }
    result.gsub!(/\eTRG\[([-+]?\d+)\]/i)   { actor_xparam($1.to_i, 9) }
    #---
    result.gsub!(/\eTGR\[([-+]?\d+)\]/i)   { actor_sparam($1.to_i, 0) }
    result.gsub!(/\eGRD\[([-+]?\d+)\]/i)   { actor_sparam($1.to_i, 1) }
    result.gsub!(/\eREC\[([-+]?\d+)\]/i)   { actor_sparam($1.to_i, 2) }
    result.gsub!(/\ePHA\[([-+]?\d+)\]/i)   { actor_sparam($1.to_i, 3) }
    result.gsub!(/\eMCR\[([-+]?\d+)\]/i)   { actor_sparam($1.to_i, 4) }
    result.gsub!(/\eTCR\[([-+]?\d+)\]/i)   { actor_sparam($1.to_i, 5) }
    result.gsub!(/\ePDR\[([-+]?\d+)\]/i)   { actor_sparam($1.to_i, 6) }
    result.gsub!(/\eMDR\[([-+]?\d+)\]/i)   { actor_sparam($1.to_i, 7) }
    result.gsub!(/\eFDR\[([-+]?\d+)\]/i)   { actor_sparam($1.to_i, 8) }
    result.gsub!(/\eEXR\[([-+]?\d+)\]/i)   { actor_sparam($1.to_i, 9) }
    return result
  end
  
  #--------------------------------------------------------------------------
  # new method: actor_level
  #--------------------------------------------------------------------------
  def actor_level(actor_id)
    actor_id = $game_party.members[actor_id.abs].id if actor_id <= 0
    return "" if $game_actors[actor_id].nil?
    return $game_actors[actor_id].level.group
  end
  
  #--------------------------------------------------------------------------
  # new method: actor_param
  #--------------------------------------------------------------------------
  def actor_param(actor_id, param_id)
    actor_id = $game_party.members[actor_id.abs].id if actor_id <= 0
    return "" if $game_actors[actor_id].nil?
    return $game_actors[actor_id].param(param_id).group
  end
  
  #--------------------------------------------------------------------------
  # new method: actor_xparam
  #--------------------------------------------------------------------------
  def actor_xparam(actor_id, param_id)
    actor_id = $game_party.members[actor_id.abs].id if actor_id <= 0
    return "" if $game_actors[actor_id].nil?
    case param_id
    when 0; stat = $game_actors[actor_id].hit
    when 1; stat = $game_actors[actor_id].eva
    when 2; stat = $game_actors[actor_id].cri
    when 3; stat = $game_actors[actor_id].cev
    when 4; stat = $game_actors[actor_id].mev
    when 5; stat = $game_actors[actor_id].mrf
    when 6; stat = $game_actors[actor_id].cnt
    when 7; stat = $game_actors[actor_id].hrg
    when 8; stat = $game_actors[actor_id].mrg
    when 9; stat = $game_actors[actor_id].trg
    else; return ""
    end
    return sprintf("%d%%", stat * 100)
  end
  
  #--------------------------------------------------------------------------
  # new method: actor_sparam
  #--------------------------------------------------------------------------
  def actor_sparam(actor_id, param_id)
    actor_id = $game_party.members[actor_id.abs].id if actor_id <= 0
    return "" if $game_actors[actor_id].nil?
    case param_id
    when 0; stat = $game_actors[actor_id].tgr
    when 1; stat = $game_actors[actor_id].grd
    when 2; stat = $game_actors[actor_id].rec
    when 3; stat = $game_actors[actor_id].pha
    when 4; stat = $game_actors[actor_id].mcr
    when 5; stat = $game_actors[actor_id].tcr
    when 6; stat = $game_actors[actor_id].pdr
    when 7; stat = $game_actors[actor_id].mdr
    when 8; stat = $game_actors[actor_id].fdr
    when 9; stat = $game_actors[actor_id].exr
    else; return ""
    end
    return sprintf("%d%%", stat * 100)
  end

end # Window_Base

end # $imported["YEA-MessageSystem"]

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================