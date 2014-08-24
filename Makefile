GO_EASY_ON_ME=1
export DEBUG=1
export SDKVERSION=4.3
FW_DEVICE_IP=apple-tv.local
#THEOS_DEVICE_IP=testtv.local
#FW_DEVICE_IP=testtv.local
include theos/makefiles/common.mk


BUNDLE_NAME = HW
HW_FILES = Classes/HWAppliance.xm Classes/HWBasicMenu.xm
HW_INSTALL_PATH = /Applications/Lowtide.app/Appliances
HW_BUNDLE_EXTENSION = frappliance
HW_LDFLAGS = -undefined dynamic_lookup #-L$(FW_PROJECT_DIR) -lBackRow

include $(FW_MAKEDIR)/bundle.mk

HW_PATH = $(FW_STAGING_DIR)$(HW_INSTALL_PATH)/$(BUNDLE_NAME).$(HW_BUNDLE_EXTENSION)/$(BUNDLE_NAME)


after-HW-stage:: 
	mkdir -p $(FW_STAGING_DIR)/Applications/AppleTV.app/Appliances; ln -f -s /Applications/Lowtide.app/Appliances/HW.frappliance $(FW_STAGING_DIR)/Applications/AppleTV.app/Appliances/
	$(FAKEROOT) chown -R root:wheel $(FW_STAGING_DIR)
	$(PREFIX)dsymutil $(HW_PATH) -o $(BUNDLE_NAME).dSYM
	cp $(HW_PATH) $(BUNDLE_NAME)_unstripped
	$(PREFIX)strip -x $(HW_PATH)
	$(_THEOS_CODESIGN_COMMANDLINE) $(HW_PATH)
	
	
after-install::
	install.exec "killall -9 AppleTV"
	
	
