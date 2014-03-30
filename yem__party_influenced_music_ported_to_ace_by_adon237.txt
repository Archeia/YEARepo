#===============================================================================
# 
# Yanfly Engine Melody - Party Influenced Music
# Last Date Updated: 2010.06.24
# Level: Normal
# Ported to Ace by Adon237
# No matter how good an RPG's battle music is, players are going to get sick and
# tired of listening to it for the zillionth time. This script won't rid RPG's
# of that problem, but will hopefully stall the process by playing randomized
# music dependent on who the player has in the active party at the start of any
# normal battle.
# 
#===============================================================================
# Updates
# -----------------------------------------------------------------------------
# o 2010.06.24 - Started Script and Finished.
#===============================================================================
# Instructions
# -----------------------------------------------------------------------------
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials but above ▼ Main. Remember to save.
# 
# To use this script, modify the module down below to create the arrays of
# music themes used by each actor. Depending on who is present in the battle,
# a random piece of music will play gathered from the music pool.
# 
# To force a theme to play, just set the battle theme to something else other
# than the default battle theme. It will always choose the selected theme over
# the random themes. Once the battle theme is changed back to the default battle
# theme, then random battle themes will trigger once again.
# 
#===============================================================================

$imported = {} if $imported == nil
$imported["PartyInfluencedMusic"] = true

module YEM
  module BATTLE_THEMES
    
    # This hash adjusts the random battle themes that may be played depending
    # on whether or not the party member is present in the battle when the music
    # loads up. Each array contains possible themes that may play for battle.
    # Actor 0 is the common pool. Inside of that array contains all of the
    # battle themes that can bebe played regardless of who's in the party.
    ACTOR_MUSIC ={ # ActorID 0 must exist.
    # ActorID => [BGM, BGM, BGM]
       0 => [RPG::BGM.new("Battle1", 100, 100)
             ], # End Common
       1 => [RPG::BGM.new("Battle2", 100, 100)
             ], # End Actor1
       2 => [RPG::BGM.new("Town3", 100, 100)
             ], # End Actor2
       3 => [RPG::BGM.new("Dungeon4", 100, 100)
             ], # End Actor3
    } # Do not remove this.
    
  end # BATTLE_THEMES
end # YEM

#===============================================================================
# Editting anything past this point may potentially result in causing computer
# damage, incontinence, explosion of user's head, coma, death, and/or halitosis.
# Therefore, edit at your own risk.
#===============================================================================

#===============================================================================
# Game_System
#===============================================================================

class Game_System

  #--------------------------------------------------------------------------
  # overwrite method: battle_bgm
  #--------------------------------------------------------------------------
  def battle_bgm
    return @battle_bgm if @battle_bgm != nil
    former_in_battle = $game_party.in_battle
    $game_party.in_battle == true
    music_list = YEM::BATTLE_THEMES::ACTOR_MUSIC[0]
    for member in $game_party.battle_members
      next unless YEM::BATTLE_THEMES::ACTOR_MUSIC.include?(member.id)
      result = YEM::BATTLE_THEMES::ACTOR_MUSIC[member.id]
      if result.is_a?(Array)
        music_list |= result
      elsif result.is_a?(RPG::BGM)
        music_list.push(result)
      end
    end
    $game_party.in_battle == former_in_battle
    return music_list[rand(music_list.size)]
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: battle_bgm=
  #--------------------------------------------------------------------------
  def battle_bgm=(battle_bgm)
    @battle_bgm = battle_bgm
    @battle_bgm = nil if @battle_bgm == $data_system.battle_bgm
  end
  
end # Game_System

#===============================================================================
# 
# END OF FILE
# 
#===============================================================================