# AeroGear iOS Differential Synchronization Client Engine
This project represents a client side implementation for [AeroGear Differential 
Synchronization (DS) Server](https://github.com/danbev/aerogear-sync-server/tree/differential-synchronization).

## Prerequisites 
This project requires Xcode6.0 to run.

This project uses a git submodule of [diffmatchpatch-ios](https://github.com/danbev/diffmatchpatch-ios). 
When this project is first cloned the submodule directory is empty and need to be initialized:

    git submodule init
    git submodule update


## Building

Building can be done by opening the project in Xcode:

    open AeroGearSync.xcodeproj

or you can use the command line.
Make sure you are using Xcode6.0: 

    sudo xcode-select -s /Applications/Xcode.app/Contents/Developer

    xcodebuild -scheme AeroGearSync build

## Testing
Tests can be run from with in Xcode using Product->Test menu option (CMD+U).  
You can also run test from the command:

    xcodebuild test -scheme AeroGearSync -destination 'platform=iOS Simulator,name=iPhone 5s'






    

