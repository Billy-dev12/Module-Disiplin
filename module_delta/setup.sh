#!/sbin/sh

###########################
# MMT Reborn Logic
###########################

############
# Config Vars
############

# Set this to true if you want to skip mount for your module
SKIPMOUNT="false"
# Set this to true if you want to clean old files in module before injecting new module
CLEANSERVICE="false"
# Set this to true if you want to load vskel after module info print. If you want to manually load it, consider using load_vksel function
AUTOVKSEL="false"
# Set this to true if you want store debug logs of installation
DEBUG="true"

############
# Replace List
############

# List all directories you want to directly replace in the system
# Construct your list in the following example format
REPLACE_EXAMPLE="
/system/app/Youtube
/system/priv-app/SystemUI
/system/priv-app/Settings
/system/framework
"
# Construct your own list here
REPLACE="
"

############
# Permissions
############

# Set permissions
set_permissions() {
  set_perm_recursive "$MODPATH" 0 0 0777 0755
  set_perm_recursive "$MODPATH/$system" 0 0 0777 0755
  set_perm_recursive "$MODPATH/system/bin/144" 0 0 0777 0755
  set_perm_recursive "$MODPATH/system/bin/165" 0 0 0777 0755
  set_perm_recursive "$MODPATH/system/app/AI/base.apk" 0 0 0755 0755
  set_perm_recursive "$MODPATH/$script" 0 0 0777 0777
  set_perm_recursive "$MODPATH/script/shellscript" 0 0 0777 0777
  set_perm_recursive "$MODPATH/script/shellscript1" 0 0 0777 0777
}

############
# Info Print
############

# Set what you want to be displayed on header of installation process
info_print() {
  ui_print ""
  ui_print "*******************************************"
  ui_print "            Module Gaming"
  ui_print "           6969 Ngefies"
  ui_print "    Subscribe Dwong Bwang"
  ui_print "*******************************************"
  ui_print ""

  sleep 2
}

############
# Main
############

# Change the logic to whatever you want
init_main() {
  ui_print "[*] Installing Module Gaming 6969 Ngefies into system..."
  ui_print ""
  
  sleep 3.0

  ui_print "[*] Gaming Parah Cuy"
  ui_print "@modulegaming6969fps"
  ui_print ""
  
  sleep 5.0

  ui_print "[*] @modulegaming6969fps "
  ui_print "Setting up some"
  ui_print "module executable permissions..."
  ui_print ""

  sleep 6.0
  
  ui_print "[*] Done!"
  ui_print ""

  sleep 0.5
  
  ui_print " --- Notes --- "
  ui_print ""
  ui_print "[*] Reboot is required"
  ui_print ""
  ui_print "[*] Join @modulegaming6969fps"
  ui_print "@modulegaming6969fps"
  ui_print "to get Amazing Modules updates"
  ui_print ""
  ui_print "[*] Thank You!"

  sleep 2.5  
}