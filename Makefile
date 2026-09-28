BUILD_DIR = $(CURDIR)/build
XCODEBUILD_ARGS ?=

all: build

build:
	xcodebuild build -project LinearMouse.xcodeproj -scheme LinearMouse -configuration Release -derivedDataPath '$(BUILD_DIR)' -disableAutomaticPackageResolution CODE_SIGN_STYLE=Manual CODE_SIGN_IDENTITY=- CODE_SIGN_INJECT_BASE_ENTITLEMENTS=NO $(XCODEBUILD_ARGS)

test:
	swift test --package-path Modules/HIDPP
	swift test --package-path Modules/PointerKit
	swift test --package-path Modules/KeyKit
	swift test --package-path Modules/DockKit
	swift test --package-path Modules/GestureKit
	swift test --package-path Modules/ObservationToken
	xcodebuild test -project LinearMouse.xcodeproj -scheme LinearMouse $(XCODEBUILD_ARGS)

.PHONY: all build test
