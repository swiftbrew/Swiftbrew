PRODUCT_NAME = swift-brew
VERSION = $(version)

PREFIX ?= /usr/local

CD = cd
CP = $(shell whereis cp) -Rf
GIT = $(shell which git)
HUB = $(shell which hub)
MKDIR = $(shell which mkdir) -p
RM = $(shell whereis rm) -rf
SED = /usr/bin/sed
SWIFT = $(shell which swift)
TAR = $(shell whereis tar) cJf

TARGET_PLATFORM = x86_64-apple-macosx
TARBALL = "swiftbrew-$(VERSION).mojave.tar.xz"

BINARY_DIRECTORY = $(PREFIX)/bin
BUILD_DIRECTORY = $(shell pwd)/.build/$(TARGET_PLATFORM)/release
OUTPUT_EXECUTABLE = $(BUILD_DIRECTORY)/$(PRODUCT_NAME)
INSTALL_EXECUTABLE_PATH = $(BINARY_DIRECTORY)/$(PRODUCT_NAME)

SWIFT_BUILD_FLAGS = --configuration release --disable-sandbox

.PHONY: all
all: build

.PHONY: test
test: clean
	$(SWIFT) test

.PHONY: build
build:
	$(SWIFT) build $(SWIFT_BUILD_FLAGS)

.PHONY: install
install: build
	$(MKDIR) $(BINARY_DIRECTORY)
	$(CP) "$(OUTPUT_EXECUTABLE)" "$(BINARY_DIRECTORY)"

.PHONY: package
package: build
	$(CD) "$(BUILD_DIRECTORY)" && $(TAR) $(TARBALL) "$(PRODUCT_NAME)"
	$(CP) "$(BUILD_DIRECTORY)/$(TARBALL)" $(TARBALL)

.PHONY: release
release: clean package
	$(GIT) --git-dir=../homebrew-tap/.git pull origin master
	$(SED) -i '' '4s/.*/  version "$(VERSION)"/' ../homebrew-tap/swiftbrew.rb
	$(SED) -i '' '6s/.*/  sha256 "$(shell shasum -a 256 "$(TARBALL)" | cut -f 1 -d " ")"/' ../homebrew-tap/swiftbrew.rb
	$(HUB) release create --message $(VERSION) --attach $(TARBALL) $(VERSION)
	$(GIT) --git-dir=../homebrew-tap/.git commit swiftbrew.rb -m "Release version $(VERSION)"
	$(GIT) --git-dir=../homebrew-tap/.git push origin master

.PHONY: xcode
xcode:
	$(SWIFT) package generate-xcodeproj

.PHONY: uninstall
uninstall:
	$(RM) "$(BINARY_DIRECTORY)/$(PRODUCT_NAME)"

.PHONY: clean
clean:
	$(SWIFT) package clean
