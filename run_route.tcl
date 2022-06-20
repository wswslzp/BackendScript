############################################
# route the design
############################################
# secondary power pin connection
setPGPinUseSignalRoute PBUFX2:ExtVDD PINVX1:ExtVDD LSLH_ISONL_X1_TO_ON:ExtVDD SRDFF*:ExtVDD
setNanoRouteMode -routeStripeLayerRange 4:8
setNanoRouteMode -drouteUseMultiCutViaEffort medium
#setNanoRouteMode  -drouteEndIteration 5

routePGPinUseSignalRoute
setNanoRouteMode -routeStripeLayerRange ""

verifyConnectivity -nets {VDD VDDm VDDau VDDlu VSS} -type special -error 1000 -warning 50

setNanoRouteMode -routeWithTimingDriven true

routeDesign
setExtractRCMode -engine postRoute
saveDesign DBS/route.enc -compress
verifyPowerDomain -bind -gconn -isoNetPD RPT/route.isonets.rpt -xNetPD RPT/route.xnets.rpt

############################################
# post-route optimization
#############################################
setAnalysisMode -analysisType onChipVariation -cppr none
setDelayCalMode -siAware false
optDesign -postRoute -outDir RPT -prefix postroute
saveDesign DBS/postroute.enc -compress
verifyPowerDomain -bind -gconn -isoNetPD RPT/postroute.isonets.rpt -xNetPD RPT/postroute.xnets.rpt
verifyConnectivity -nets {VDD VDDm VDDau VDDlu VSS} -type special -error 1000 -warning 50

