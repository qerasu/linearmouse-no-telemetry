BUILD_DIR = $(CURDIR)/build
XCODEBUILD_ARGS ?=

all: build

build:
	xcodebuild build -project LinearMouse.xcodeproj -scheme LinearMouse -configuration Release -derivedDataPath '$(BUILD_DIR)' -disableAutomaticPackageResolution CODE_SIGN_STYLE=Manual CODE_SIGN_IDENTITY=- CODE_SIGN_INJECT_BASE_ENTITLEMENTS=NO $(XCODEBUILD_ARGS)

.PHONY: all build
