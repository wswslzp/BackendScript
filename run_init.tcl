setMultiCpuUsage -localCpu 32 -verbose
source ../INPUT/dma_mac.globals
init_design

##############################
### load and commit IEEE1801
##############################

read_power_intent -1801 ../INPUT/dma_mac.1801
commit_power_intent -verbose

verifyPowerDomain -isoNetPD
verifyPowerDomain -xNetPD
