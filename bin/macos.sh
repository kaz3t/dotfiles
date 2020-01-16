#!/usr/bin/env bash

declare -r PROJECTS_DIR=~/projects

function set_the_stage() {
    # Close any open System Preferences panes, to prevent them from overriding settings we’re about to change
    osascript -e 'tell application "System Preferences" to quit'

    # Ask for the administrator password upfront
    sudo -v

    # Keep-alive: update existing `sudo` time stamp until `macos.sh` has finished
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
}

function set_up_projects() {
    if [[ ! -d ${PROJECTS_DIR} ]]; then
        mkdir ${PROJECTS_DIR};
    fi;
}

function configure_system() {
    # Disable the sound effects on boot
    sudo nvram SystemAudioVolume=" "
    # Disable Gatekeeper for getting rid of unknown developers error
    sudo spctl --master-disable
    # Set computer name (as done via System Preferences -> Sharing)
    sudo scutil --set ComputerName "KZ's MBP"
    sudo scutil --set HostName "KZ's MBP"
    sudo scutil --set LocalHostName "kz-mbp"
    sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "KZ's MBP"
    # Increase sound quality for Bluetooth headphones/headsets
    defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40
    # Show language menu in the top right corner of the boot screen
    sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true
    # System menu bar
    quit "SystemUIServer"
    defaults write com.apple.systemuiserver menuExtras -array \
        "/System/Library/CoreServices/Menu Extras/User.menu", \
        "/System/Library/CoreServices/Menu Extras/Clock.menu", \
        "/System/Library/CoreServices/Menu Extras/Battery.menu", \
        "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
        "/System/Library/CoreServices/Menu Extras/AirPort.menu", \
        "/System/Library/CoreServices/Menu Extras/Volume.menu"
    defaults write com.apple.menuextra.battery ShowPercent -string "YES"
    defaults write com.apple.TextInputMenu visible -bool true
    open "SystemUIServer"
}

function configure_dock() {
    quit "Dock"

    # Hot corners
    # Possible values:
    #  0: no-op
    #  2: Mission Control
    #  3: Show application windows
    #  4: Desktop
    #  5: Start screen saver
    #  6: Disable screen saver
    #  7: Dashboard
    # 10: Put display to sleep
    # 11: Launchpad
    # 12: Notification Center
    # 13: Lock Screen
    # Top left screen corner - lock screen
    defaults write com.apple.dock wvous-tl-corner -int 13
    defaults write com.apple.dock wvous-tl-modifier -int 0
    # Top right screen corner - desktop
    defaults write com.apple.dock wvous-tr-corner -int 4
    defaults write com.apple.dock wvous-tr-modifier -int 0
    # Bottom left screen corner → nothing
    defaults write com.apple.dock wvous-bl-corner -int 0
    defaults write com.apple.dock wvous-bl-modifier -int 0
    # Bottom right screen corner - nothing
    defaults write com.apple.dock wvous-br-corner -int 0
    defaults write com.apple.dock wvous-br-modifier -int 0
    open "Dock"
}

function configure_finder() {
    # Allow quitting via ⌘ + Q; doing so will also hide desktop icons
    defaults write com.apple.finder QuitMenuItem -bool true
    # Save screenshots to Downloads folder
    defaults write com.apple.screencapture location -string "${HOME}/Downloads"
    # Require password immediately after sleep or screen saver begins
    defaults write com.apple.screensaver askForPassword -int 1
    defaults write com.apple.screensaver askForPasswordDelay -int 0
    # Keep folders on top when sorting by name
    defaults write com.apple.finder _FXSortFoldersFirst -bool true
    # Show icons for hard drives, servers, and removable media on the desktop
    defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
    defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
    defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
    defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
    # Show hidden files by default
    defaults write com.apple.finder AppleShowAllFiles -bool true
    # Show all filename extensions
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    # Show path bar
    defaults write com.apple.finder ShowPathbar -bool true
    # Allow text selection in Quick Look
    defaults write com.apple.finder QLEnableTextSelection -bool true
    # Display full POSIX path as Finder window title
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
    # Avoid creating .DS_Store files on network volumes
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    # Disable disk image verification
    defaults write com.apple.frameworks.diskimages skip-verify -bool true
    defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
    defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
    # Automatically open a new Finder window when a volume is mounted
    defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
    defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
    defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true
    # Use list view in all Finder windows by default
    # Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
    defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
    # Disable the warning before emptying the Trash
    defaults write com.apple.finder WarnOnEmptyTrash -bool false
    # Empty Trash securely by default
    defaults write com.apple.finder EmptyTrashSecurely -bool true
    # Show the ~/Library folder
    chflags nohidden ~/Library
}

function configure_trackpad() {
    # Trackpad: enable tap to click for this user and for the login screen
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    # Enable most of the gestures
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad DragLock -int 0;
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Dragging -int 0;
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 0;
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFiveFingerPinchGesture -int 2;
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerHorizSwipeGesture -int 2;
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerPinchGesture -int 2;
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerVertSwipeGesture -int 2;
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadHandResting -int 1;
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadHorizScroll -int 1;
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadMomentumScroll -int 1;
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadPinch -int 1;
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -int 1;
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRotate -int 1;
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadScroll -int 1;
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -int 1;
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 0;
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture -int 0;
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 0;
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerDoubleTapGesture -int 1;
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 3;
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad USBMouseStopsTrackpad -int 0;
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad UserPreferences -int 1;
}

function configure_keyboard() {
    # Disable "Correct spelling automatically"
    defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
    # Enable full keyboard access for all controls which enables Tab selection in modal dialogs
    defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
    # Set a blazingly fast keyboard repeat rate
    defaults write NSGlobalDomain KeyRepeat -int 1
    defaults write NSGlobalDomain InitialKeyRepeat -int 15
    # Set language and text formats
    defaults write NSGlobalDomain AppleLanguages -array "en" "en-US" "pl"
    defaults write NSGlobalDomain AppleLocale -string "en_US@currency=USD"
}

function add_to_login_items() {
    osascript << EOM
# "¬" charachter tells osascript that the line continues
set login_item_list to {¬
    "Alfred 4",¬
    "BarracudaVPNClient",¬
    "Calendars",¬
    "Docker",¬
    "Egnyte Connect",¬
    "Flux",¬
    "Spectacle",¬
    "Tunnelblick"¬
}

tell application "System Events" to delete every login item

repeat with login_item in login_item_list
    tell application "System Events"
        make login item with properties {name: login_item, path: ("/Applications/" & login_item & ".app"), hidden: true }
    end tell
end repeat
EOM
}

function quit() {
    app=$1
    killall "$app" > /dev/null 2>&1
}

function open() {
    app=$1
    osascript << EOM
tell application "$app" to activate
tell application "System Events" to tell process "iTerm2"
set frontmost to true
end tell
EOM
}

function main() {
    set_up_projects;
    set_the_stage;
    configure_system
    configure_finder;
    configure_dock;
    configure_trackpad;
    configure_keyboard;
    add_to_login_items;
}

main "$@"
