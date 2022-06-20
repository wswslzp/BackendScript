##################################
# preCTS optimization (gigaOpt)
#################################

# report the available always-on buffers per domain
setOptMode -resizeShifterAndIsoInsts true
reportAlwaysOnBuffer -all -verbose

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
