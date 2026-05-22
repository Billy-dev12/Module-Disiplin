#!/system/bin/sh

# modulegaming6969fps
wait_until_login() {
  # In case of /data encryption is disabled
  while [[ "$(getprop sys.boot_completed)" != "1" ]]; do
    sleep 3
  done

  # We don't have the permission to rw "/storage/emulated/0" before the user unlocks the screen
  test_file="/storage/emulated/0/Android/.PERMISSION_TEST"
  true >"$test_file"
  while [[ ! -f "$test_file" ]]; do
    true >"$test_file"
    sleep 1
  done
  rm -f "$test_file"
}

wait_until_login

# Sleep some time to make sure init is completed
sleep 5
su -lp 2000 -c "cmd notification post -S bigtext -t 'Run ⚡@modulegaming6969fps' 'Tag' 'Starting Unlocking 120hz.'"
su -lp 2000 -c "am start -a android.intent.action.MAIN -e toasttext '⚡@modulegaming6969fps Starting Unlocking 120hz' -n bellavita.toast/.MainActivity"

nohup sh $MODDIR/script/shellscript > /dev/null &
nohup sh $MODDIR/script/shellscript1 > /dev/null &

# Unlocker
su -c resetprop -n ro.product.system.model V2408A
su -c resetprop -n ro.product.model V2408A

# Qualcomm
su -c resetprop -n Build.BRAND QTI
su -c resetprop -n ro.soc.manufacturer Qualcomm
su -c resetprop -n ro.vendor.soc.manufacturer Qualcomm
su -c resetprop -n ro.hardware.soc.manufacturer Qualcomm
su -c resetprop -n ro.hardware.chipname sun
su -c resetprop -n ro.chipname sun
su -c resetprop -n ro.soc.model SM8750-AC
su -c resetprop -n ro.vendor.soc.model SM8750-AC
su -c resetprop -n ro.vendor.se.chip.model SM8750-AC
su -c resetprop -n ro.vendor.soc.model.external_name sun
su -c resetprop -n ro.vendor.soc.model.part_name sun
su -c resetprop -n ro.vendor.qti.soc_name sun
su -c resetprop -n ro.vendor.qti.soc_model SM8750-AC
su -c resetprop -n ro.vendor.qti.soc_id 618
su -c resetprop -n ro.vendor.mediatek.platform SM8750
su -c resetprop -n ro.product.oplus.cpuinfo SM8750-AC
su -c resetprop -n ro.vendor.soc.model_ready 1

# Tambahan
su -c resetprop -n persist.vendor.connsys.fm_chipid SM8750-AC
su -c resetprop -n ro.board.platform sm8750
su -c resetprop -n ro.boot.hardware sm8750
su -c resetprop -n ro.vendor.fm.platform SM8750-AC

####################################
# Services
####################################
su -c "stop logcat logcatd logd tcpdump cnss_diag statsd traced idd-logreader idd-logreadermain stats dumpstate aplogd tcpdump vendor.tcpdump vendor_tcpdump vendor.cnss_diag"

su -lp 2000 -c "cmd notification post -S bigtext -t 'Run ⚡ @modulegaming6969fps' 'Tag' 'Successfully Unlock 120hz.'"
su -lp 2000 -c "am start -a android.intent.action.MAIN -e toasttext 'Successfully Unlock 120hz' -n bellavita.toast/.MainActivity"
exit 0