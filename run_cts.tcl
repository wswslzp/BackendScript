#####################################
# CTS
######################################
setDontUse CLKBUF* false
setDontUse CLKINV* false
setDontUse PBUFX2 false
setDontUse PINVX1 false
reportAlwaysOnBuffer -all


set_ccopt_property buffer_cells {CLKBUFX4 CLKBUFX8 CLKBUFX16 PBUFX2}
set_ccopt_property inverter_cells {CLKINVX4 CLKINVX8 CLKINVX16 PINVX1}

setNanoRouteMode -quiet -routeTopRoutingLayer 9

#create_ccopt_clock_tree_spec -immediate
#setDelayCalMode -engine aae
ccopt_design 

saveDesign DBS/cts.enc -compress
verifyPowerDomain -bind -gconn -isoNetPD RPT/cts.isonets.rpt -xNetPD RPT/cts.xnets.rpt

############################################
# postCTS optimization (hold)
############################################
setDontUse DLY* false
optDesign -postCTS -hold -outDir RPT -prefix postcts_hold
saveDesign DBS/postcts_hold.enc -compress
verifyPowerDomain -bind -gconn -isoNetPD RPT/postcts_hold.isonets.rpt -xNetPD RPT/postcts_hold.xnets.rpt

