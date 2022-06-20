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

