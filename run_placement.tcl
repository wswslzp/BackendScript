#################
# placement
#################

setPlaceMode -placeIoPins false

setPlaceMode -place_opt_post_place_tcl ../SCRIPTS/preCTS_Opt.tcl
 
setTrialRouteMode -maxRouteLayer Metal9

place_opt_design

# add tie high/low
setTieHiLoMode -cell "TIEHI TIELO" -maxfanout 10
addTieHiLo -powerDomain PDcore
addTieHiLo -powerDomain PDmac1
addTieHiLo -powerDomain PDmac2

reportIsolation -from PDmac1 -to PDcore -highlight
reportIsolation -from PDmac2 -to PDcore -highlight

checkPlace

verifyPowerDomain -isoNetPD
verifyPowerDomain -xNetPD

saveDesign DBS/place.enc -compress
verifyPowerDomain -bind -gconn -isoNetPD RPT/place.isonets.rpt -xNetPD RPT/place.xnets.rpt
