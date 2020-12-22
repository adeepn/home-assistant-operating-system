################################################################################
#
# jethome secure boot loader
#
################################################################################

JETHOME_BOOT_SOURCE = ${JETHOME_BOOT_VERSION).tar.gz
JETHOME_BOOT_SITE = https://github.com/adeepn/jethome-uboot

JETHOME_BOOT_LICENSE = Free binary use
#JETHOME_BOOT_LICENSE_FILES = Licenses/gpl-2.0.txt
JETHOME_BOOT_INSTALL_IMAGES = YES
#JETHOME_BOOT_DEPENDENCIES = uboot


ifeq ($(BR2_PACKAGE_JETHOME_BOOT_JETHUB_D1),y)
JETHOME_BOOT_VERSION = latest

JETHOME_BOOT_BINS += bootloader.PARTITION \
                        DDR.USB \
                        platform.conf \
                        UBOOT.USB
define JETHOME_BOOT_BUILD_CMDS
        curl -L -o $(@D)/jethome-uboot.tgz $(JETHOME_BOOT_SITE)/$(JETHOME_BOOT_SOURCE)
        tar --strip-components=1 -zxvf $(JETHOME_BOOT_SOURCE)  --exclude=.github
endef

else ifeq ($(BR2_PACKAGE_JETHOME_BOOT_JETHUB_H1),y)
#WIP. Not ready
endef
endif


define JETHOME_BOOT_INSTALL_IMAGES_CMDS
	$(foreach f,$(JETHOME_BOOT_BINS), \
			cp -dpf $(@D)/$(f) $(BINARIES_DIR)/
	)
endef

$(eval $(generic-package))
