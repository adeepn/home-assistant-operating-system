#!/bin/bash
# shellcheck disable=SC2155

# bootloader.PARTITION \
# DDR.USB \
# platform.conf \
# UBOOT.USB

set -e # Exit immediately if a command exits with a non-zero status
set -u # Treat unset variables and parameters as an error

# some functions
print_var() {
  if [ -n "$1" ] ; then
    echo "-- ${1}==${!1}"
  else
    echo "${FUNCNAME[0]}(): Null parameter passed to this function"
  fi
}

print_cmd_title() {
    if [ -n "$1" ] ; then
    echo "###### ${1} ######"
  else
    echo "${FUNCNAME[0]}(): Null parameter passed to this function"
  fi
}

self_name() {
  echo ${0##*/}
}


# Change size partitions
BOOT_SIZE=(64M 64M)
BOOTSTATE_SIZE=8M
SYSTEM_SIZE=256M
KERNEL_SIZE=64M
OVERLAY_SIZE=128M
DATA_SIZE=1G

function hassos_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"
    #local BL1="${BINARIES_DIR}/bl1.bin.hardkernel"
    #local UBOOT_GXBB="${BINARIES_DIR}/u-boot.gxbb"
    #local SPL_IMG="$(path_spl_img)"

    #cp "${BINARIES_DIR}/boot.scr" "${BOOT_DATA}/boot.scr"
    #cp "${BINARIES_DIR}/meson-gxbb-odroidc2.dtb" "${BOOT_DATA}/meson-gxbb-odroidc2.dtb"

    echo "console=tty0 console=ttyAML0,115200n8" > "${BOOT_DATA}/cmdline.txt"
    cp "${BINARIES_DIR}/meson-axg-jethome-jethub-j100.dtb" "${BOOT_DATA}/meson-axg-jethome-jethub-j100.dtb"

    # SPL
    #create_spl_image

    #dd if="${BL1}" of="${SPL_IMG}" conv=notrunc bs=1 count=440
    #dd if="${BL1}" of="${SPL_IMG}" conv=notrunc bs=512 skip=1 seek=1
    #dd if="${UBOOT_GXBB}" of="${SPL_IMG}" conv=notrunc bs=512 seek=97
}

function hassos_post_image() {
    #convert_disk_image_j100
}



function convert_disk_image_j100() {
    local IMG_BOOT=PART.1.boot
    local IMG_OVERLAY=PART.7.overlay
    local IMG_DATA=PART.8.data
    local IMG_KERNELA=PART.2.kernela
    local IMG_SYSTEMA=PART.3.systema
    local IMG_KERNELB=PART.4.kernelb
    local IMG_SYSTEMB=PART.5.systemb
    local IMG_BOOTINFO=PART.6.bootinfo

    local hdd_ext=${1:-img}
    local hdd_img="$(hassos_image_name "${hdd_ext}")"

    #rm -f "${hdd_img}.xz"
    #xz -3 -T0 "${hdd_img}"
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    DETECTED_PARTITIONS=$(fdisk -l -o Device,Start,End,Sectors $INPUT_IMG | grep ${hdd_img}| tail -n +2)

    PART_BOOT=$(echo "$DETECTED_PARTITIONS" |tail -n +1 | head -n 1)
    PART_BOOT_START=$(echo "$PART_BOOT" | awk '{print $2}')      # in sectors. sector size is 512 bytes
    PART_BOOT_SIZE=$(echo "$PART_BOOT" | awk '{print $4}')

    #PART_EXTENDED=`sfdisk -d $1 | grep -P -A 100 ".+start=.+size=.+type=.+" |tail -n +2 | head -n 1`

    PART_OVERLAY=$(echo "$DETECTED_PARTITIONS" |tail -n +3 | head -n 1)
    PART_OVERLAY_START=$(echo "$PART_OVERLAY" | awk '{print $2}')      # in sectors. sector size is 512 bytes
    PART_OVERLAY_SIZE=$(echo "$PART_OVERLAY" | awk '{print $4}')

    PART_DATA=$(echo "$DETECTED_PARTITIONS" |tail -n +4 | head -n 1)
    PART_DATA_START=$(echo "$PART_DATA" | awk '{print $2}')      # in sectors. sector size is 512 bytes
    PART_DATA_SIZE=$(echo "$PART_DATA" | awk '{print $4}')

    PART_KERNELA=$(echo "$DETECTED_PARTITIONS" |tail -n +5 | head -n 1)
    PART_KERNELA_START=$(echo "$PART_KERNELA" | awk '{print $2}')      # in sectors. sector size is 512 bytes
    PART_KERNELA_SIZE=$(echo "$PART_KERNELA" | awk '{print $4}')

    PART_SYSTEMA=$(echo "$DETECTED_PARTITIONS" |tail -n +6 | head -n 1)
    PART_SYSTEMA_START=$(echo "$PART_SYSTEMA" | awk '{print $2}')      # in sectors. sector size is 512 bytes
    PART_SYSTEMA_SIZE=$(echo "$PART_SYSTEMA" | awk '{print $4}')

    PART_KERNELB=$(echo "$DETECTED_PARTITIONS" |tail -n +7 | head -n 1)
    PART_KERNELB_START=$(echo "$PART_KERNELB" | awk '{print $2}')      # in sectors. sector size is 512 bytes
    PART_KERNELB_SIZE=$(echo "$PART_KERNELB" | awk '{print $4}')

    PART_SYSTEMB=$(echo "$DETECTED_PARTITIONS" |tail -n +8 | head -n 1)
    PART_SYSTEMB_START=$(echo "$PART_SYSTEMB" | awk '{print $2}')      # in sectors. sector size is 512 bytes
    PART_SYSTEMB_SIZE=$(echo "$PART_SYSTEMB" | awk '{print $4}')

    PART_BOOTINFO=$(echo "$DETECTED_PARTITIONS" |tail -n +9 | head -n 1)
    PART_BOOTINFO_START=$(echo "$PART_BOOTINFO" | awk '{print $2}')      # in sectors. sector size is 512 bytes
    PART_BOOTINFO_SIZE=$(echo "$PART_BOOTINFO" | awk '{print $4}')

    extract_partition "BOOT" "$INPUT_IMG" "$PART_BOOT_START" "$PART_BOOT_SIZE" "$IMG_BOOT"
    extract_partition "OVERLAY" "$INPUT_IMG" "$PART_OVERLAY_START" "$PART_OVERLAY_SIZE" "$IMG_OVERLAY"
    extract_partition "DATA" "$INPUT_IMG" "$PART_DATA_START" "$PART_DATA_SIZE" "$IMG_DATA"
    extract_partition "KERNELA" "$INPUT_IMG" "$PART_KERNELA_START" "$PART_KERNELA_SIZE" "$IMG_KERNELA"
    extract_partition "SYSTEMA" "$INPUT_IMG" "$PART_SYSTEMA_START" "$PART_SYSTEMA_SIZE" "$IMG_SYSTEMA"
    extract_partition "KERNELB" "$INPUT_IMG" "$PART_KERNELB_START" "$PART_KERNELB_SIZE" "$IMG_KERNELB"
    extract_partition "SYSTEMB" "$INPUT_IMG" "$PART_SYSTEMB_START" "$PART_SYSTEMB_SIZE" "$IMG_SYSTEMB"
    extract_partition "BOOTINFO" "$INPUT_IMG" "$PART_BOOTINFO_START" "$PART_BOOTINFO_SIZE" "$IMG_BOOTINFO"

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
}


extract_partition() {
  if [[ -n "$1" || -n "$2" || -n "$3" || -n "$4" || -n "$5" ]] ; then
    local PART_NAME="$1"
    local INPUT_FILE="$2"
    local SKIP="$3"
    local COUNT="$4"
    local OUTPUT_FILE="$5"

    print_cmd_title "Extracting $PART_NAME partition from $INPUT_FILE to $OUTPUT_FILE ..."
    dd status=progress bs=1b skip=$SKIP count=$COUNT if=$INPUT_FILE of=$OUTPUT_FILE # 1b = 512 bytes
  else
    echo "${FUNCNAME[0]}(): Null parameter passed to this function"
  fi
}

#LOOPDEVICE=`sudo losetup --show -f $INPUT_IMG`
#echo Mounted $LOOPDEVICE



#sudo blkid $LOOPDEVICE*
#sudo lsblk -f
#sudo losetup -d $LOOPDEVICE
