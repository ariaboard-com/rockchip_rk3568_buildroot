################################################################################
#
# rk_webui
#
################################################################################

RK_WEBUI_VERSION = 1.0.0
RK_WEBUI_SITE_METHOD = local
RK_WEBUI_SITE = $(TOPDIR)/../external/rk_webui

MAKE_WEB=$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)

define RK_WEBUI_BUILD_CMDS
	rm $(TARGET_DIR)/usr/bin/cgi-bin -rf
	rm $(D)/liboper.so -rf
	rm $(D)/*.cgi -rf
	$(MAKE_WEB) $(@D)/wifi/lollipop_wifiScanAp.c $(@D)/utility/string_ext.c $(@D)/utility/utility.c $(@D)/wifi/list_network.c $(@D)/wifi/operate.c $(@D)/www/html_string.c -fPIC -shared -o $(@D)/liboper.so
	${MAKE_WEB} $(@D)/www/home.c -o $(@D)/home.cgi
	${MAKE_WEB} $(@D)/www/wifi.c liboper.so -o $(@D)/wifi.cgi
	${MAKE_WEB} $(@D)/www/scan.c liboper.so -o $(@D)/scan.cgi
	${MAKE_WEB} $(@D)/www/connect.c liboper.so -o $(@D)/connect.cgi
	${MAKE_WEB} $(@D)/www/add_network.c liboper.so -o $(@D)/add_network.cgi
	${MAKE_WEB} $(@D)/www/add_network_connect.c liboper.so -o $(@D)/add_network_connect.cgi
	${MAKE_WEB} $(@D)/www/disconnect.c liboper.so -o $(@D)/disconnect.cgi
	${MAKE_WEB} $(@D)/www/forget.c liboper.so -o $(@D)/forget.cgi
	${MAKE_WEB} $(@D)/www/dialog.c liboper.so -o $(@D)/dialog.cgi
	${MAKE_WEB} $(@D)/www/connectSavedAp.c liboper.so -o $(@D)/connectSavedAp.cgi
	${MAKE_WEB} $(@D)/www/key.c liboper.so -o $(@D)/key.cgi
	${MAKE_WEB} $(@D)/www/settings.c liboper.so -o $(@D)/settings.cgi
	${MAKE_WEB} $(@D)/www/overscan.c liboper.so -o $(@D)/overscan.cgi
	${MAKE_WEB} $(@D)/www/language.c liboper.so -o $(@D)/language.cgi
	${MAKE_WEB} $(@D)/www/softap_freq.c liboper.so -o $(@D)/softap_freq.cgi
	${MAKE_WEB} $(@D)/www/password.c liboper.so -o $(@D)/password.cgi
	${MAKE_WEB} $(@D)/www/inputUrl.c liboper.so -o $(@D)/inputUrl.cgi
	${MAKE_WEB} $(@D)/www/debug.c liboper.so -o $(@D)/debug.cgi
endef

define RK_WEBUI_INSTALL_TARGET_CMDS
	mkdir -p  $(TARGET_DIR)/usr/bin/cgi-bin
	mkdir -p  $(TARGET_DIR)/etc/www
	mkdir -p  $(TARGET_DIR)/etc/www/css
	mkdir -p  $(TARGET_DIR)/etc/www/res
	$(INSTALL) -D -m 755 $(@D)/liboper.so  $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 755 $(@D)/*.cgi  $(TARGET_DIR)/usr/bin/cgi-bin/
	$(INSTALL) -D -m 644 $(@D)/www/css/*  $(TARGET_DIR)/etc/www/css/
	$(INSTALL) -D -m 644 $(@D)/www/res/*  $(TARGET_DIR)/etc/www/res/
	$(INSTALL) -D -m 644 $(@D)/www/index.html  $(TARGET_DIR)/etc/www/
	$(INSTALL) -D -m 755 $(@D)/S*  $(TARGET_DIR)/etc/init.d/
endef

$(eval $(generic-package))
