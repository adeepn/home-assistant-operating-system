################################################################################
#
# Realtek RTL88x2CS driver
#
################################################################################

RTL88x2CS_VERSION = main
RTL88x2CS_SITE = $(call github,chewitt,RTL8822CS,$(RTL88x2CS_VERSION))
RTL88x2CS_LICENSE = GPL-2.0
RTL88x2CS_LICENSE_FILES = COPYING
#RTL88x2CS_MODULE_SUBDIRS = src

RTL88x2CS_MODULE_MAKE_OPTS = \
	CONFIG_RTL8822C = y \
	KVER=$(LINUX_VERSION_PROBED) \
	KSRC=$(LINUX_DIR)

$(eval $(kernel-module))
$(eval $(generic-package))
