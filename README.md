# AeroGear iOS Differential Synchronization Client Engine
This project represents a client side implementation for [AeroGear Differential 
Synchronization (DS) Server](https://github.com/aerogear/aerogear-sync-server/tree/differential-synchronization).

## Prerequisites 
This project requires Xcode6.0 to run.

This project used [CocoaPods](http://cocoapods.org/) to managed its dependencies. The following command 
must be run prior to building:
    
    sudo gem install cocoapods --pre
    pod install

This project is also a Cocoapod and can be pushed to the Cocoapods specs repository.
Currently we are using a private/local Cocoapods repo before publishing the real ones. This is only for testing. Please
follow the instructions [here](https://github.com/danbev/Cocoapods-repo) to set up a local repo.

    pod spec lint AeroGearSync.podspec --sources='https://github.com/danbev/Cocoapods-repo.git' --verbose --allow-warnings

## Building

Building can be done by opening the project in Xcode:

    open AeroGearSync.xcworkspace

or you can use the command line.
Make sure you are using Xcode6.0: 

    sudo xcode-select -s /Applications/Xcode.app/Contents/Developer

    xcodebuild -workspace AeroGearSync.xcworkspace -scheme AeroGearSync build

## Testing
Tests can be run from with in Xcode using Product->Test menu option (CMD+U).  
You can also run test from the command:

    xcodebuild -workspace AeroGearSync.xcworkspace -scheme AeroGearSync -destination 'platform=iOS Simulator,name=iPhone 5s' test


