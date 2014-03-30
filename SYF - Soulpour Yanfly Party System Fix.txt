# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# SYF [Soulpour Yanfly Fix] - Party System Swap Fix
# Author: Soulpour777
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # Alias Listings
  #--------------------------------------------------------------------------  
  alias :syf_yanfly_party_swap :swap_order
 
  #--------------------------------------------------------------------------
  # Swap Order
  #--------------------------------------------------------------------------  
  def swap_order(index1, index2)
    id1, id2 = @actors[index1], @actors[index2]
    pos1 = @battle_members_array.index(id1)
    pos2 = @battle_members_array.index(id2)
    @battle_members_array[pos1] = id2 if pos1
    @battle_members_array[pos2] = id1 if pos2
    syf_yanfly_party_swap(index1, index2)
  end
  
end