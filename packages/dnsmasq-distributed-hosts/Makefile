#
# Copyright (C) 2006-2013 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=dnsmasq-distributed-hosts
PKG_VERSION=$(GIT_COMMIT_DATE)-$(GIT_COMMIT_TSTAMP)
GIT_COMMIT_DATE:=$(shell git log -n 1 --pretty=%ad --date=short . )
GIT_COMMIT_TSTAMP:=$(shell git log -n 1 --pretty=%at . )

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
 SECTION:=net
 CATEGORY:=LiMe
 TITLE:=/etc/hosts sharing across mesh
 MAINTAINER:=Gui Iribarren <gui@altermundi.net>
 URL:=http://libremesh.org
 DEPENDS:=+alfred +lua +libuci-lua
 PKGARCH:=all
endef

define Package/$(PKG_NAME)/description
 Share hostnames in /etc/hosts file across nodes of the same mesh cloud
endef

define Build/Prepare
	@cp -r ./src $(PKG_BUILD_DIR)/
endef

define Build/Compile
	@sed -i '/^--!.*/d' $(PKG_BUILD_DIR)/src/*.lua
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/alfred
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/dnsmasq-distributed-hosts.lua $(1)/etc/alfred/dnsmasq-distributed-hosts.lua
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
