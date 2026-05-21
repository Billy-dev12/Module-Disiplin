#!/system/bin/sh
# Magisk Service Monitor & Focus Script
# Memantau aplikasi aktif, service background, dan membatasi sosmed

# Tunggu sampai booting selesai
until [ "$(getprop sys.boot_completed)" -eq 1 ]; do
    sleep 3
done

LOG_FILE="/sdcard/monitor.txt"
TIME_FILE="/data/local/tmp/socmed_time.txt"
DATE_FILE="/data/local/tmp/socmed_date.txt"
LIMIT=1800 # 30 menit (dalam detik)

TARGET_APPS="com.google.android.youtube app.revanced.android.youtube com.instagram.android com.instagram.lite com.zhiliaoapp.musically com.ss.android.ugc.trill"

# Inisialisasi file time dan date jika belum ada
if [ ! -f "$TIME_FILE" ]; then
    echo "0" > $TIME_FILE
fi

current_date=$(date '+%Y-%m-%d')
if [ ! -f "$DATE_FILE" ]; then
    echo "$current_date" > $DATE_FILE
fi

# Loop utama
while true; do
    # 1. Reset harian pada tengah malam
    now_date=$(date '+%Y-%m-%d')
    saved_date=$(cat $DATE_FILE)
    if [ "$now_date" != "$saved_date" ]; then
        echo "0" > $TIME_FILE
        echo "$now_date" > $DATE_FILE
    fi
    
    # Baca waktu sosmed terpakai saat ini
    used_time=$(cat $TIME_FILE)
    if ! [ "$used_time" -eq "$used_time" ] 2>/dev/null; then
        used_time=0
        echo "0" > $TIME_FILE
    fi
    
    # 2. Deteksi Top Activity (Aplikasi Aktif)
    top_app_full=$(dumpsys activity activities | grep -E "mResumedActivity" | head -n 1 | grep -oE "[a-zA-Z0-9._]+/[a-zA-Z0-9._]+")
    top_pkg=""
    if [ -n "$top_app_full" ]; then
        top_pkg=$(echo "$top_app_full" | cut -d'/' -f1)
    fi
    
    # Jika tidak terdeteksi via mResumedActivity, coba mCurrentFocus
    if [ -z "$top_pkg" ]; then
        top_focus=$(dumpsys window | grep -E 'mCurrentFocus|mFocusedApp' | head -n 1 | grep -oE "[a-zA-Z0-9._]+/[a-zA-Z0-9._]+")
        if [ -n "$top_focus" ]; then
            top_pkg=$(echo "$top_focus" | cut -d'/' -f1)
        fi
    fi
    
    # 3. Hitung waktu jika membuka aplikasi target
    is_target=false
    for app in $TARGET_APPS; do
        if [ "$top_pkg" = "$app" ]; then
            is_target=true
            break
        fi
    done
    
    if [ "$is_target" = true ]; then
        # Tambah waktu (interval sleep adalah 5 detik)
        used_time=$((used_time + 5))
        echo "$used_time" > $TIME_FILE
        
        # Cek jika melebihi limit
        if [ "$used_time" -ge "$LIMIT" ]; then
            # Kill aplikasi
            am force-stop "$top_pkg"
            
            # Kirim notifikasi ke user
            cmd notification post -S bigtext -t "⚠️ WAKTU SOSMED HABIS!" "socmed_block" "Ingat bro, kamu sudah buka sosmed selama 30 menit! Kembali fokus ke terminal!"
        fi
    fi
    
    # 4. Tulis hasil pemantauan ke file log /sdcard/monitor.txt
    used_min=$((used_time / 60))
    used_sec=$((used_time % 60))
    limit_min=$((LIMIT / 60))
    
    echo "=== MONITOR LOG: $(date '+%Y-%m-%d %H:%M:%S') ===" > $LOG_FILE
    echo "" >> $LOG_FILE
    
    echo "[ 🎯 FOKUS TERMINAL MONITOR ]" >> $LOG_FILE
    echo "  Status Hari Ini: ${used_min}m ${used_sec}s terpakai dari ${limit_min}m limit" >> $LOG_FILE
    if [ "$used_time" -ge "$LIMIT" ]; then
        echo "  Status Sosmed  : 🔴 DIBLOKIR (Limit Habis!)" >> $LOG_FILE
    else
        echo "  Status Sosmed  : 🟢 AKTIF (Sisa $(( (LIMIT - used_time) / 60 ))m $(( (LIMIT - used_time) % 60 ))s)" >> $LOG_FILE
    fi
    echo "" >> $LOG_FILE
    
    echo "[ Aplikasi Aktif di Layar (Top Activity) ]" >> $LOG_FILE
    if [ -n "$top_app_full" ]; then
        echo "  Aplikasi: $top_app_full" >> $LOG_FILE
    else
        echo "  Tidak terdeteksi aplikasi aktif" >> $LOG_FILE
    fi
    echo "" >> $LOG_FILE
    
    echo "[ Service yang Sedang Berjalan (Background) ]" >> $LOG_FILE
    services=$(dumpsys activity services | grep -E "ServiceRecord" | grep "com." | grep -oE "[a-zA-Z0-9._]+/[a-zA-Z0-9._]+" | sort -u)
    if [ -n "$services" ]; then
        echo "$services" | while read -r service; do
            echo "  - $service" >> $LOG_FILE
        done
    else
        echo "  Tidak ada service background yang terdeteksi" >> $LOG_FILE
    fi
    
    sleep 5
done
