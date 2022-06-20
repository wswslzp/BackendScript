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
