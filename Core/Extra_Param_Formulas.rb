#==============================================================================
# 
# ▼ Yanfly Engine Ace - Extra Param Formulas v1.00
# -- Last Updated: 2012.01.10
# -- Level: Hard
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-ExtraParamFormulas"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.10 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# RPG Maker VX Ace certainly gives a lot of control to developers over many
# aspects of designing their RPG including custom formulas for individual items
# and skills. However, the program does not offer custom formulas for some of
# the more unique parameters such as hit rates, evasion rates, critical rates,
# etc. This script provides the ability to alter those extra parameters with
# primary stats altering them such as LUK affecting critical, DEF affecting PDR
# and whatnot.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# Modify the formulas in the script module to your liking.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module XPARAM
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Formula Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This hash allows you to adjust all of extra parameters to gain extra
    # bonuses based on primary stats (such as ATK, DEF, MAT, MDF, AGI, LUK).
    # You can define what stats affect these extra parameters and the formulas
    # that affect them, as well.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    FORMULA ={
    # This adjusts the formula for HIT. HIT is the physical accuracy rate.
    # This provided formula uses the average of the user's ATK and AGI as a
    # bonus contributing factor to increasing the user's HIT. If you do not
    # wish to use this formula, change it to "base_hit" to have it use
    # whatever the original HIT rate is.
      :hit_n_value => "(atk + agi) / 2",
      :hit_formula => "(n / (100.0 + n)) * 0.250 + 0.050 + base_hit * 2/3",
    
    # This adjusts the formula for EVA. EVA is the physical evasion rate.
    # This provided formula uses the average of the user's AGI and LUK as a
    # bonus contributing factor to increasing the user's EVA. If you do not
    # wish to use this formula, change it to "base_eva" to have it use
    # whatever the original EVA rate is.
      :eva_n_value => "(agi + luk) / 2",
      :eva_formula => "(n / (256.0 + n)) * 0.250 + 0.000 + base_eva",
      
    # This adjusts the formula for CRI. CRI is the critical hit rate.
    # This provided formula uses the user's flat total amount of LUK as a
    # bonus contributing factor to increasing the user's CRI. If you do not
    # wish to use this formula, change it to "base_cri" to have it use
    # whatever the original CRI rate is.
      :cri_n_value => "luk",
      :cri_formula => "(n / (100.0 + n)) * 0.333 + 0.000 + base_cri",
      
    # This adjusts the formula for CEV. CEV is the critical evasion rate.
    # This provided formula uses a shifted percentage of LUK and AGI as a
    # bonus contributing factor to increasing the user's CRI. If you do not
    # wish to use this formula, change it to "base_cev" to have it use
    # whatever the original CRI rate is.
      :cev_n_value => "agi * 0.75 + luk * 0.25",
      :cev_formula => "(n / (512.0 + n)) * 0.167 + 0.000 + base_cev",
      
    # This adjusts the formula for MEV. MEV is the magical evasion rate.
    # This provided formula uses the average of the user's MDF and LUK as a
    # bonus contributing factor to increasing the user's MEV. If you do not
    # wish to use this formula, change it to "base_mev" to have it use
    # whatever the original MEV rate is.
      :mev_n_value => "(mdf + luk) / 2",
      :mev_formula => "(n / (256.0 + n)) * 0.250 + 0.000 + base_mev",
      
    # This adjusts the formula for MRF. MRF is the magical reflect rate.
    # This script does not provide any default stat bonuses that alter MRF.
      :mrf_n_value => "0",
      :mrf_formula => "base_mrf",
      
    # This adjusts the formula for CNT. CNT is the counter attack rate.
    # This script does not provide any default stat bonuses that alter CNT.
      :cnt_n_value => "0",
      :cnt_formula => "base_cnt",
      
    # This adjusts the formula for HRG. HRG is the HP Regeneration Rate.
    # This script does not provide any default stat bonuses that alter HRG.
      :hrg_n_value => "0",
      :hrg_formula => "base_hrg",
      
    # This adjusts the formula for MRG. MRG is the MP Regeneration Rate.
    # This script does not provide any default stat bonuses that alter MRG.
      :mrg_n_value => "0",
      :mrg_formula => "base_mrg",
      
    # This adjusts the formula for TRG. TRG is the TP Regeneration Rate.
    # This script does not provide any default stat bonuses that alter TRG.
      :trg_n_value => "0",
      :trg_formula => "base_trg",
      
    # This adjusts the formula for TGR. TGR is the Target Likelihood Rate.
    # This script does not provide any default stat bonuses that alter TGR.
      :tgr_n_value => "0",
      :tgr_formula => "base_tgr",
      
    # This adjusts the formula for GRD. GRD is the guard reduce defense rate.
    # This provided formula uses the average of the user's DEF and MDF as a
    # bonus contributing factor to increasing the user's GRD. If you do not
    # wish to use this formula, change it to "base_grd" to have it use
    # whatever the original GRD rate is.
      :grd_n_value => "(self.def + mdf) / 2",
      :grd_formula => "(n / (256.0 + n)) * 0.333 + 0.000 + base_grd",
      
    # This adjusts the formula for REC. REC is the Recovery Effect Rate.
    # This script does not provide any default stat bonuses that alter REC.
      :rec_n_value => "0",
      :rec_formula => "base_rec",
      
    # This adjusts the formula for PHA. PHA is the Pharmacology Effect Rate.
    # This script does not provide any default stat bonuses that alter PHA.
      :pha_n_value => "0",
      :pha_formula => "base_pha",
      
    # This adjusts the formula for MCR. MCR is the MP Cost Rate Rate.
    # This script does not provide any default stat bonuses that alter MCR.
      :mcr_n_value => "0",
      :mcr_formula => "base_mcr",
      
    # This adjusts the formula for TCR. TCR is the TP Charge Rate Rate.
    # This script does not provide any default stat bonuses that alter TCR.
      :tcr_n_value => "0",
      :tcr_formula => "base_tcr",
      
    # This adjusts the formula for PDR. PDR is the Physical Damage Reduce Rate.
    # This provided formula uses the user's flat total amount of DEF as a
    # bonus contributing factor to increasing the user's PDR. If you do not
    # wish to use this formula, change it to "base_pdr" to have it use
    # whatever the original PDR rate is.
      :pdr_n_value => "self.def",
      :pdr_formula => "base_pdr - (n / (256.0 + n)) * 0.500 - 0.000",
      
    # This adjusts the formula for MDR. MDR is the Magical Damage Reduce Rate.
    # This provided formula uses the user's flat total amount of MDF as a
    # bonus contributing factor to increasing the user's MDR. If you do not
    # wish to use this formula, change it to "base_pdr" to have it use
    # whatever the original PDR rate is.
      :mdr_n_value => "mdf",
      :mdr_formula => "base_mdr - (n / (256.0 + n)) * 0.500 - 0.000",
      
    # This adjusts the formula for FDR. FDR is the Floor Damage Rate.
    # This script does not provide any default stat bonuses that alter FDR.
      :fdr_n_value => "0",
      :fdr_formula => "base_fdr",
      
    # This adjusts the formula for EXR. EXR is the Experience Gain Rate.
    # This script does not provide any default stat bonuses that alter EXR.
      :exr_n_value => "0",
      :exr_formula => "base_exr",
    
    } # Do not remove this.
    
  end # XPARAM
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

#==============================================================================
# ■ Game_BattlerBase
#==============================================================================

class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # mass alias methods
  #--------------------------------------------------------------------------
  alias_xparam = ["hit", "eva", "cri", "cev", "mev", "mrf", "cnt", "hrg", "mrg",
    "trg", "tgr", "grd", "rec", "pha", "mcr", "tcr", "pdr", "mdr", "fdr", "exr"]
  alias_xparam.each { |xparam|
  aStr = %Q(
  alias game_battlerbase_#{xparam}_epf #{xparam}
  def #{xparam}
    base_#{xparam} = game_battlerbase_#{xparam}_epf
    n = eval(YEA::XPARAM::FORMULA[:#{xparam}_n_value])
    return eval(YEA::XPARAM::FORMULA[:#{xparam}_formula])
  end
  )
  module_eval(aStr)
  } # Do not remove this.
  
end # Game_BattlerBase

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================