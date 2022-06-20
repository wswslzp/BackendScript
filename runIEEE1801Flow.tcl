source ../INPUT/dma_mac.globals
init_design

##############################
### load and commit IEEE1801
##############################

read_power_intent -1801 ../INPUT/dma_mac.1801
commit_power_intent

verifyPowerDomain -isoNetPD
verifyPowerDomain -xNetPD

##########################
# floorplan & powerplan
##########################

floorPlan -b 0 0 2560 2560 0 0 2560 2560 100 100 2460 2460

# Assign IO pins
loadIoFile ../INPUT/dma_mac.io

# floorplan power domain

setObjFPlanBox Group PDmac1 200 1580 2160 2360
modifyPowerDomainAttr PDmac1 -minGaps 50 50 50 50
modifyPowerDomainAttr PDmac1 -rsExts 50 50 50 50

setObjFPlanBox Group PDmac2 200 200 2160 980
modifyPowerDomainAttr PDmac2 -minGaps 50 50 50 50
modifyPowerDomainAttr PDmac2 -rsExts 50 50 50 50

# place three RAMs in the power domains
relativeFPlan --place ethernet_mac_2/tx_fifo_module_from_dma/fifo1/dual_port_ram_4_tx_fifo/ram2P1024x32 \
  TR 200 200 50 50
relativeFPlan --place ethernet_mac_2/rx_fifo_module_to_dma/data/dual_port_ram_4_tx_fifo/ram2P1024x32 \
  BR 200 980 50 50
relativeFPlan --place ethernet_mac_2/rx_fifo_module_to_dma/pkt_cntr/dual_port_ram_4_tx_fifo/a \
  TR 200 200 1000 50

relativeFPlan --place ethernet_mac_1/tx_fifo_module_from_dma/fifo1/dual_port_ram_4_tx_fifo/ram2P1024x32 \
  TR 200 1580 50 50
relativeFPlan --place ethernet_mac_1/rx_fifo_module_to_dma/data/dual_port_ram_4_tx_fifo/ram2P1024x32 \
  BR 200 2360 50 50
relativeFPlan --place  ethernet_mac_1/rx_fifo_module_to_dma/pkt_cntr/dual_port_ram_4_tx_fifo/a \
  TR 200 1580 1000 50

relativeFPlan --place  dma_dut/dmamaster_dut/internal_memory/RAM4096x32 \
  TR 200 980 1000 100 R90

addHaloToBlock  10 10 10 10 ethernet_mac_2/tx_fifo_module_from_dma/fifo1/dual_port_ram_4_tx_fifo/ram2P1024x32
addHaloToBlock  10 10 10 10 ethernet_mac_2/rx_fifo_module_to_dma/data/dual_port_ram_4_tx_fifo/ram2P1024x32
addHaloToBlock  10 10 10 10 ethernet_mac_2/rx_fifo_module_to_dma/pkt_cntr/dual_port_ram_4_tx_fifo/a 

addHaloToBlock  10 10 10 10 ethernet_mac_1/tx_fifo_module_from_dma/fifo1/dual_port_ram_4_tx_fifo/ram2P1024x32
addHaloToBlock  10 10 10 10 ethernet_mac_1/rx_fifo_module_to_dma/data/dual_port_ram_4_tx_fifo/ram2P1024x32
addHaloToBlock  10 10 10 10 ethernet_mac_1/rx_fifo_module_to_dma/pkt_cntr/dual_port_ram_4_tx_fifo/a

addHaloToBlock  10 10 10 10 dma_dut/dmamaster_dut/internal_memory/RAM4096x32

# add power switches for PDmac1 and PDmac2
addPowerSwitch -column  \
    -powerDomain PDmac1 \
    -enableNetOut ethernet_mac_1/switch_enable_out_PDmac1 \
    -leftOffset 30 -bottomOffset 0 \
    -horizontalPitch 72 \
    -checkerBoard \
    -loopBackAtEnd \
    -switchModuleInstance ethernet_mac_1

addPowerSwitch -column \
    -powerDomain PDmac2 \
    -enableNetOut ethernet_mac_2/switch_enable_out_PDmac2 \
    -leftOffset 30 -bottomOffset 0 \
    -horizontalPitch 72 \
    -checkerBoard \
    -loopBackAtEnd \
    -switchModuleInstance ethernet_mac_2

# power planning
addRing -center 1 -stacked_via_top_layer Metal11 -type core_rings -jog_distance 0.24 -threshold 0.24 \
  -nets {VDD VSS VDDm} -stacked_via_bottom_layer Metal1 \
  -layer {bottom Metal7 top Metal7 right Metal8 left Metal8} -width 10 -spacing 8 -offset 0.24

deselectAll
selectObject Group PDmac1
addRing -stacked_via_top_layer Metal11 -around power_domain -jog_distance 0.24 -threshold 0.24 \
  -type block_rings -nets {VDDau VDDm VSS VDD} -stacked_via_bottom_layer Metal1 \
  -layer {bottom Metal7 top Metal7 right Metal8 left Metal8} -width 5 -spacing 5 -offset 7.5

deselectAll
selectObject Group PDmac2
addRing -stacked_via_top_layer Metal11 -around power_domain -jog_distance 0.24 -threshold 0.24 \
  -type block_rings -nets {VDDlu VDDm VSS VDD} -stacked_via_bottom_layer Metal1 \
  -layer {bottom Metal7 top Metal7 right Metal8 left Metal8} -width 5 -spacing 5 -offset 7.5

# add stripes

deselectAll
selectInst dma_dut/dmamaster_dut/internal_memory/RAM4096x32
setAddStripeMode -ignore_nondefault_domains 1
addStripe -block_ring_top_layer_limit Metal9 -max_same_layer_jog_length 0.44 \
  -padcore_ring_bottom_layer_limit Metal7 -set_to_set_distance 144 \
  -break_at_selected_blocks 1 -stacked_via_top_layer Metal11 \
  -padcore_ring_top_layer_limit Metal9 -spacing 2 -xleft_offset 22 \
  -merge_stripes_value 0.24 -layer Metal8 -block_ring_bottom_layer_limit Metal7 \
  -width 5 -nets {VDD VSS} -stacked_via_bottom_layer Metal1
setAddStripeMode -ignore_nondefault_domains 0


# add stripes for VDDm, VDDau and VSS for PDmac1
# add VDDm rings for each RAMs
deselectAll
selectInst ethernet_mac_1/rx_fifo_module_to_dma/data/dual_port_ram_4_tx_fifo/ram2P1024x32
addRing -stacked_via_top_layer Metal11 -around selected -jog_distance 0.24 -threshold 0.24 \
  -type block_rings -nets VDDm -stacked_via_bottom_layer Metal1 \
  -layer {bottom Metal7 top Metal7 right Metal8 left Metal8} -width 3 -spacing 3.5

deselectAll
selectInst ethernet_mac_1/tx_fifo_module_from_dma/fifo1/dual_port_ram_4_tx_fifo/ram2P1024x32
addRing -stacked_via_top_layer Metal11 -around selected -jog_distance 0.24 -threshold 0.24 \
  -type block_rings -nets VDDm -stacked_via_bottom_layer Metal1 \
  -layer {bottom Metal7 top Metal7 right Metal8 left Metal8} -width 3 -spacing 3.5

deselectAll
selectInst ethernet_mac_1/rx_fifo_module_to_dma/pkt_cntr/dual_port_ram_4_tx_fifo/a
addRing -stacked_via_top_layer Metal11 -around selected -jog_distance 0.24 -threshold 0.24 \
  -type block_rings -nets VDDm -stacked_via_bottom_layer Metal1 \
  -layer {bottom Metal7 top Metal7 right Metal8 left Metal8} -width 3 -spacing 3.5

# add stripes
deselectAll
selectInst ethernet_mac_1/rx_fifo_module_to_dma/data/dual_port_ram_4_tx_fifo/ram2P1024x32
selectInst ethernet_mac_1/tx_fifo_module_from_dma/fifo1/dual_port_ram_4_tx_fifo/ram2P1024x32
selectInst ethernet_mac_1/rx_fifo_module_to_dma/pkt_cntr/dual_port_ram_4_tx_fifo/a
selectObject Group PDmac1

addStripe -block_ring_top_layer_limit Metal3 -max_same_layer_jog_length 0.44 \
  -over_power_domain 1 -padcore_ring_bottom_layer_limit Metal1 -set_to_set_distance 144 \
  -break_at_selected_blocks 1 -stacked_via_top_layer Metal11 -padcore_ring_top_layer_limit Metal3 \
  -spacing 2 -xleft_offset 138 -merge_stripes_value 0.24 -layer Metal8 \
  -block_ring_bottom_layer_limit Metal1 -width 3 -nets {VDDm VSS VDDau} -stacked_via_bottom_layer Metal1

# add stripes for VDDm, VDDlu and VSS for PDmac2
# add VDDm rings for each RAMs
deselectAll
selectInst ethernet_mac_2/rx_fifo_module_to_dma/data/dual_port_ram_4_tx_fifo/ram2P1024x32
addRing -stacked_via_top_layer Metal11 -around selected -jog_distance 0.24 -threshold 0.24 \
  -type block_rings -nets VDDm -stacked_via_bottom_layer Metal1 \
  -layer {bottom Metal7 top Metal7 right Metal8 left Metal8} -width 3 -spacing 3.5

deselectAll
selectInst ethernet_mac_2/tx_fifo_module_from_dma/fifo1/dual_port_ram_4_tx_fifo/ram2P1024x32
addRing -stacked_via_top_layer Metal11 -around selected -jog_distance 0.24 -threshold 0.24 \
  -type block_rings -nets VDDm -stacked_via_bottom_layer Metal1 \
  -layer {bottom Metal7 top Metal7 right Metal8 left Metal8} -width 3 -spacing 3.5

deselectAll
selectInst ethernet_mac_2/rx_fifo_module_to_dma/pkt_cntr/dual_port_ram_4_tx_fifo/a
addRing -stacked_via_top_layer Metal11 -around selected -jog_distance 0.24 -threshold 0.24 \
  -type block_rings -nets VDDm -stacked_via_bottom_layer Metal1 \
  -layer {bottom Metal7 top Metal7 right Metal8 left Metal8} -width 3 -spacing 3.5

# add stripes
deselectAll
selectInst ethernet_mac_2/rx_fifo_module_to_dma/data/dual_port_ram_4_tx_fifo/ram2P1024x32
selectInst ethernet_mac_2/tx_fifo_module_from_dma/fifo1/dual_port_ram_4_tx_fifo/ram2P1024x32
selectInst ethernet_mac_2/rx_fifo_module_to_dma/pkt_cntr/dual_port_ram_4_tx_fifo/a
selectObject Group PDmac2

addStripe -block_ring_top_layer_limit Metal3 -max_same_layer_jog_length 0.44 \
  -over_power_domain 1 -padcore_ring_bottom_layer_limit Metal1 -set_to_set_distance 144 \
  -break_at_selected_blocks 1 -stacked_via_top_layer Metal11 -padcore_ring_top_layer_limit Metal3 \
  -spacing 2 -xleft_offset 138 -merge_stripes_value 0.24 -layer Metal8 \
  -block_ring_bottom_layer_limit Metal1 -width 3 -nets {VDDm VSS VDDlu} -stacked_via_bottom_layer Metal1

# add VDDm stripes over power switches
deselectAll
selectInst ethernet_mac_1/rx_fifo_module_to_dma/data/dual_port_ram_4_tx_fifo/ram2P1024x32
selectInst ethernet_mac_1/tx_fifo_module_from_dma/fifo1/dual_port_ram_4_tx_fifo/ram2P1024x32
selectInst ethernet_mac_1/rx_fifo_module_to_dma/pkt_cntr/dual_port_ram_4_tx_fifo/a
selectObject Group PDmac1
addStripe -max_same_layer_jog_length 0.8 -over_power_domain 1\
          -pin_layer TOP -over_pins 1 -skip_via_on_pin {}  -break_at_selected_blocks 1 \
          -master HSWX1 -max_pin_width 5.0 -pin_offset -2.80\
          -stacked_via_top_layer Metal9 -merge_stripes_value 0.1 \
          -layer Metal8 -width 3 -nets {VDDm} -stacked_via_bottom_layer Metal1 -spacing 2.5

deselectAll
selectInst ethernet_mac_2/rx_fifo_module_to_dma/data/dual_port_ram_4_tx_fifo/ram2P1024x32
selectInst ethernet_mac_2/tx_fifo_module_from_dma/fifo1/dual_port_ram_4_tx_fifo/ram2P1024x32
selectInst ethernet_mac_2/rx_fifo_module_to_dma/pkt_cntr/dual_port_ram_4_tx_fifo/a
selectObject Group PDmac2
addStripe -max_same_layer_jog_length 0.8 -over_power_domain 1\
          -pin_layer TOP -over_pins 1 -skip_via_on_pin {}  -break_at_selected_blocks 1 \
          -master HSWX1 -max_pin_width 5.0 -pin_offset -2.80\
          -stacked_via_top_layer Metal9 -merge_stripes_value 0.1 \
          -layer Metal8 -width 3 -nets {VDDm} -stacked_via_bottom_layer Metal1 -spacing 2.5

# conncect VDDm together
addStripe -block_ring_top_layer_limit Metal9 -max_same_layer_jog_length 0.44 \
   -padcore_ring_bottom_layer_limit Metal7 -set_to_set_distance 250 -stacked_via_top_layer Metal11 \
   -padcore_ring_top_layer_limit Metal9 -spacing 0.2 -xleft_offset 150 -merge_stripes_value 0.24 \
   -layer Metal8 -block_ring_bottom_layer_limit Metal7 -width 5 -area {33.1565 27.065 1195.1805 2532.965} \
   -nets VDDm -stacked_via_bottom_layer Metal1

#  route follow pins
sroute -connect { blockPin corePin } -layerChangeRange { Metal1 Metal11 } \
  -blockPinTarget { nearestRingStripe nearestTarget } -padPinPortConnect { allPort oneGeom } \
  -checkAlignedSecondaryPin 1 -powerDomains { PDmac1 } -blockPin useLef -allowJogging 1 \
  -crossoverViaBottomLayer Metal1 -allowLayerChange 1 -targetViaTopLayer Metal11 \
  -crossoverViaTopLayer Metal11 -targetViaBottomLayer Metal1 -nets { VDDau VSS } 

sroute -connect { blockPin corePin } -layerChangeRange { Metal1 Metal11 } \
  -blockPinTarget { nearestRingStripe nearestTarget } -checkAlignedSecondaryPin 1 \
  -powerDomains { PDmac2 } -blockPin useLef -allowJogging 1 -crossoverViaBottomLayer Metal1 \
  -allowLayerChange 1 -targetViaTopLayer Metal11 -crossoverViaTopLayer Metal11 \
  -targetViaBottomLayer Metal1 -nets { VDDlu VSS }

deselectAll
selectInst dma_dut/dmamaster_dut/internal_memory/RAM4096x32
addRing -stacked_via_top_layer Metal11 -around selected -jog_distance 0.24 -threshold 0.24 \
  -type block_rings -nets {VDD VSS} -stacked_via_bottom_layer Metal1 \
  -layer {bottom Metal7 top Metal7 right Metal8 left Metal8} -width 2 -spacing 2

sroute -connect { blockPin corePin } -layerChangeRange { Metal1 Metal11 } \
  -blockPinTarget { nearestRingStripe nearestTarget } -checkAlignedSecondaryPin 1 \
  -powerDomains { PDcore } -blockPin useLef -allowJogging 1 \
  -crossoverViaBottomLayer Metal1 -allowLayerChange 1 -targetViaTopLayer Metal11 \
  -crossoverViaTopLayer Metal11 -targetViaBottomLayer Metal1 -nets { VDD VSS }

verifyConnectivity -nets {VDD VDDm VDDau VDDlu VSS} -type special -error 1000 -warning 50

verifyPowerDomain -isoNetPD
verifyPowerDomain -xNetPD

saveDesign DBS/init.enc -compress
verifyPowerDomain -bind -gconn -isoNetPD RPT/init.isonets.rpt -xNetPD RPT/init.xnets.rpt

#################
# placement
#################

setPlaceMode -placeIoPins false

setTrialRouteMode -maxRouteLayer Metal9

placeDesign

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

##################################
# preCTS optimization (gigaOpt)
#################################

# report the available always-on buffers per domain
setOptMode -resizeShifterAndIsoInsts true
reportAlwaysOnBuffer -all

setDontUse PBUFX2 false
setDontUse PINVX1 false
set_interactive_constraint_modes [all_constraint_modes -active]
set_dont_touch [get_lib_cells PBUFX2] false
set_dont_touch [get_lib_cells PINVX1] false
set_interactive_constraint_modes { }
setDontUse CLKBUF* true
setDontUse CLKINV* true
setDontUse DLY* true

reportAlwaysOnBuffer -all
reportAlwaysOnBuffer -all -verbose

setLimitedAccessFeature ediUsePreRouteGigaOpt 1
optDesign -preCTS -outDir RPT -prefix prects

saveDesign DBS/prects.enc -compress
verifyPowerDomain -bind -gconn -isoNetPD RPT/prects.isonets.rpt -xNetPD RPT/prects.xnets.rpt


#####################################
# iCTS
######################################
setDontUse CLKBUF* false
setDontUse CLKINV* false
setDontUse PBUFX2 false
setDontUse PINVX1 false
reportAlwaysOnBuffer -all


setLimitedAccessFeature ccopt_native_cts 1
set_ccopt_mode -integration native
set_ccopt_property buffer_cells {CLKBUFX4 CLKBUFX8 CLKBUFX16 PBUFX2}
set_ccopt_property inverter_cells {CLKINVX4 CLKINVX8 CLKINVX16 PINVX1}

#setNanoRouteMode -quiet -routeTopRoutingLayer 5
setNanoRouteMode -quiet -routeTopRoutingLayer 9

create_ccopt_clock_tree_spec -immediate
setDelayCalMode -engine aae
ccopt_design -cts

saveDesign DBS/cts.enc -compress
verifyPowerDomain -bind -gconn -isoNetPD RPT/cts.isonets.rpt -xNetPD RPT/cts.xnets.rpt

##########################################
# postCTS optimization (setup)
###########################################
setAnalysisMode -cppr none
optDesign -postCTS -outDir RPT -prefix postcts
saveDesign DBS/postcts.enc -compress
verifyPowerDomain -bind -gconn -isoNetPD RPT/postcts.isonets.rpt -xNetPD RPT/postcts.xnets.rpt

############################################
# postCTS optimization (hold)
############################################
setDontUse DLY* false
optDesign -postCTS -hold -outDir RPT -prefix postcts_hold
saveDesign DBS/postcts_hold.enc -compress
verifyPowerDomain -bind -gconn -isoNetPD RPT/postcts_hold.isonets.rpt -xNetPD RPT/postcts_hold.xnets.rpt

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
#setNanoRouteMode -routeWithSiDriven true

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

