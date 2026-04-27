#The rtw88 drivers require firmware files not found in
#the "Wireless_Firmware_for_Nethunter" Magisk module.
#
#Run this script in the native Android shell as root
#to install any missing rtw88 firmware.
#
##!/system/bin/sh
if [ "$EUID" != 0 ]; then
    echo "Run it as root"
    exit 1
fi
if [ "$(getprop ro.product.device)" != "surya" ]; then
    echo "Warning: this script has not been tested for your device."
    read -p "Continue anyway? (Y/n)" yorn
    case $yorn in
        [Nn])
            echo "Quitting"
            exit 1
            ;;
           *)
            echo "Continuing"
            ;;
    esac
fi
targetdir="/vendor/firmware/rtw88"
checkdir="/etc/firmware/rtw88"
urlstub="https://github.com/endlessm/linux-firmware/raw/refs/heads/master/rtw88"
mount -o rw,remount /vendor || (echo "Couldn't remount /vendor: quitting" && exit 1)
if [ ! -d "$targetdir" ]; then
    mkdir -p $targetdir
fi
firmwares="rtw8723d_fw rtw8812a_fw rtw8814a_fw rtw8821a_fw rtw8821c_fw rtw8822b_fw rtw8822c_fw rtw8822c_wow_fw rtw8703b_fw rtw8703b_wow_fw"
for f in $firmwares; do
    if [ -f "$targetdir/$f.bin" ]; then
        echo "$f.bin already in $targetdir; skipping"
    elif [ -f "$checkdir/$f.bin" ]; then
        echo "Linking $checkdir/$f.bin to $targetdir/$f.bin"
        ln -s $checkdir/$f.bin $targetdir/$f.bin
    else
        echo "Downloading $f.bin"
        curl -fsSL $urlstub/$f.bin -o $targetdir/$f.bin
        chmod 755 $targetdir/$f.bin
    fi
done
mount -o ro,remount /vendor
echo "Now in $targetdir:"
ls --color $targetdir


