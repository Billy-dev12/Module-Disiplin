#!/system/bin/sh
# Magisk Service Monitor & Focus Script v2.0 (Anti-Bypass Edition)
# Mematikan total sosmed di jam tidur/rawan dan menggunakan quiz-based unlock sementara.

# Tunggu sampai booting selesai
until [ "$(getprop sys.boot_completed)" -eq 1 ]; do
    sleep 3
done

# Tunggu beberapa detik agar sys package manager siap
sleep 10

LOG_FILE="/sdcard/monitor.txt"
UNLOCKED_FILE="/data/local/tmp/socmed_unlocked"

TARGET_APPS="com.google.android.youtube app.revanced.android.youtube com.instagram.android com.instagram.lite com.zhiliaoapp.musically com.ss.android.ugc.trill"

disable_apps() {
    for app in $TARGET_APPS; do
        if pm list packages | grep -q "$app"; then
            # Cek jika belum di-disable (disabled by user)
            if pm list packages -d | grep -q "$app"; then
                : # Sudah dinonaktifkan
            else
                pm disable-user --user 0 "$app" >/dev/null 2>&1
            fi
        fi
    done
}

enable_apps() {
    for app in $TARGET_APPS; do
        if pm list packages | grep -q "$app"; then
            # Cek jika belum di-enable (enabled)
            if pm list packages -e | grep -q "$app"; then
                : # Sudah aktif
            else
                pm enable "$app" >/dev/null 2>&1
            fi
        fi
    done
}

is_hard_block() {
    local ch cm current_min
    ch=$(date '+%H')
    cm=$(date '+%M')
    ch=$(echo "$ch" | sed 's/^0*//')
    cm=$(echo "$cm" | sed 's/^0*//')
    [ -z "$ch" ] && ch=0
    [ -z "$cm" ] && cm=0
    
    current_min=$(( ch * 60 + cm ))
    
    # 1. Hard block pagi: 04:00 - 07:00 (240 menit s.d. 420 menit)
    if [ "$current_min" -ge 240 ] && [ "$current_min" -lt 420 ]; then
        return 0 # true
    fi
    
    # 2. Hard block malam / jam tidur: 22:30 - 04:00
    # Mulai dari 22:30 (1350 menit) sampai akhir hari (1440 menit), atau awal hari sampai 04:00 (240 menit)
    if [ "$current_min" -ge 1350 ] || [ "$current_min" -lt 240 ]; then
        return 0 # true
    fi
    
    return 1 # false
}

check_bedtime_shutdown() {
    local ch cm current_min
    ch=$(date '+%H')
    cm=$(date '+%M')
    ch=$(echo "$ch" | sed 's/^0*//')
    cm=$(echo "$cm" | sed 's/^0*//')
    [ -z "$ch" ] && ch=0
    [ -z "$cm" ] && cm=0
    
    current_min=$(( ch * 60 + cm ))
    
    # Warning pada 22:25 s.d 22:29 (1345 s.d 1349 menit)
    if [ "$current_min" -ge 1345 ] && [ "$current_min" -lt 1350 ]; then
        local sisa=$(( 1350 - current_min ))
        su -lp 2000 -c "cmd notification post -S bigtext -t '⚠️ WARN: HP SHUTTING DOWN!' 'bedtime_warn' 'Sisa waktu Anda tinggal $sisa menit lagi! HP otomatis mati pada 22:30 untuk memaksa Anda tidur.'"
    fi
    
    # Shutdown pada jam tidur: 22:30 - 04:00
    if [ "$current_min" -ge 1350 ] || [ "$current_min" -lt 240 ]; then
        su -lp 2000 -c "cmd notification post -S bigtext -t '🔴 SLEEP TIME LOCKDOWN' 'bedtime_lock' 'Jam tidur terdeteksi! Mematikan HP secara paksa...'"
        sleep 5
        reboot -p
        svc power shutdown
    fi
}

# Inisialisasi awal pada saat boot: bekukan aplikasi sosmed
disable_apps

# Loop Utama
log_counter=0
while true; do
    # 1. Cek Bedtime & Auto-Shutdown
    check_bedtime_shutdown

    # 2. Cek apakah masuk dalam jam Hard Block
    if is_hard_block; then
        disable_apps
        # Hapus file unlock agar tidak berlaku setelah jam hard block selesai
        rm -f "$UNLOCKED_FILE"
    else
        # 3. Cek Status Unlock Sementara (Kuis)
        now=$(date '+%s')
        is_unlocked=false
        
        if [ -f "$UNLOCKED_FILE" ]; then
            expiry=$(cat "$UNLOCKED_FILE")
            if echo "$expiry" | grep -qE '^[0-9]+$'; then
                if [ "$now" -lt "$expiry" ]; then
                    is_unlocked=true
                    sisa_detik=$(( expiry - now ))
                fi
            fi
        fi
        
        if [ "$is_unlocked" = true ]; then
            enable_apps
        else
            disable_apps
            # Pastikan file kuis bersih jika sudah expired
            [ -f "$UNLOCKED_FILE" ] && rm -f "$UNLOCKED_FILE"
        fi
    fi

    # 4. Tulis log visual berkala ke /sdcard/monitor.txt (setiap 30 detik untuk hemat baterai)
    log_counter=$(( (log_counter + 1) % 3 ))
    if [ "$log_counter" -eq 0 ]; then
        if [ -d "/sdcard" ]; then
            echo "=== MONITOR LOG v2.0: $(date '+%Y-%m-%d %H:%M:%S') ===" > $LOG_FILE
            echo "" >> $LOG_FILE
            echo "[ 🎯 STATUS FOKUS TERMINAL ]" >> $LOG_FILE
            
            if is_hard_block; then
                echo "  Status Sosmed  : 🔴 DIBLOKIR TOTAL (Jam Rawan/Tidur)" >> $LOG_FILE
            elif [ "$is_unlocked" = true ]; then
                echo "  Status Sosmed  : 🟢 UNLOCKED SEMENTARA (Sisa $(( sisa_detik / 60 ))m $(( sisa_detik % 60 ))s)" >> $LOG_FILE
            else
                echo "  Status Sosmed  : 🔴 DIBLOKIR (Kuis belum diselesaikan)" >> $LOG_FILE
            fi
            echo "" >> $LOG_FILE
            
            # Mendeteksi aplikasi aktif untuk logging
            top_app_full=$(dumpsys activity activities | grep -E "mResumedActivity" | head -n 1 | grep -oE "[a-zA-Z0-9._]+/[a-zA-Z0-9._]+")
            if [ -n "$top_app_full" ]; then
                echo "  Top Activity: $top_app_full" >> $LOG_FILE
            else
                echo "  Top Activity: Tidak terdeteksi" >> $LOG_FILE
            fi
        fi
    fi

    sleep 10
done
