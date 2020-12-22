#!/bin/bash
# shellcheck disable=SC2155

<<<<<<< HEAD
# bootloader.PARTITION \
# DDR.USB \
# platform.conf \
# UBOOT.USB


function hassos_pre_image() {
    #local BOOT_DATA="$(path_boot_dir)"
    #local BL1="${BINARIES_DIR}/bl1.bin.hardkernel"
    #local UBOOT_GXBB="${BINARIES_DIR}/u-boot.gxbb"
    #local SPL_IMG="$(path_spl_img)"

    #cp "${BINARIES_DIR}/boot.scr" "${BOOT_DATA}/boot.scr"
    #cp "${BINARIES_DIR}/meson-gxbb-odroidc2.dtb" "${BOOT_DATA}/meson-gxbb-odroidc2.dtb"
=======
function hassos_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"
    local BL1="${BINARIES_DIR}/bl1.bin.hardkernel"
    local UBOOT_GXBB="${BINARIES_DIR}/u-boot.gxbb"
    local SPL_IMG="$(path_spl_img)"

    cp "${BINARIES_DIR}/boot.scr" "${BOOT_DATA}/boot.scr"
    cp "${BINARIES_DIR}/meson-gxbb-odroidc2.dtb" "${BOOT_DATA}/meson-gxbb-odroidc2.dtb"
>>>>>>> 21ccf41b19d8d2c52dbdd0a2161c50a387fa7be9

    echo "console=tty0 console=ttyAML0,115200n8" > "${BOOT_DATA}/cmdline.txt"

    # SPL
<<<<<<< HEAD
    #create_spl_image

    #dd if="${BL1}" of="${SPL_IMG}" conv=notrunc bs=1 count=440
    #dd if="${BL1}" of="${SPL_IMG}" conv=notrunc bs=512 skip=1 seek=1
    #dd if="${UBOOT_GXBB}" of="${SPL_IMG}" conv=notrunc bs=512 seek=97
=======
    create_spl_image

    dd if="${BL1}" of="${SPL_IMG}" conv=notrunc bs=1 count=440
    dd if="${BL1}" of="${SPL_IMG}" conv=notrunc bs=512 skip=1 seek=1
    dd if="${UBOOT_GXBB}" of="${SPL_IMG}" conv=notrunc bs=512 seek=97
>>>>>>> 21ccf41b19d8d2c52dbdd0a2161c50a387fa7be9
}


function hassos_post_image() {
<<<<<<< HEAD
    convert_disk_image_j100()
}



function convert_disk_image_j100() {
    local hdd_ext=${1:-img}
    local hdd_img="$(hassos_image_name "${hdd_ext}")"

    rm -f "${hdd_img}.xz"
    xz -3 -T0 "${hdd_img}"
}
=======
    convert_disk_image_xz
}

>>>>>>> 21ccf41b19d8d2c52dbdd0a2161c50a387fa7be9
