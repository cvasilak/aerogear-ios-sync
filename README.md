# AeroGear iOS Differential Synchronization Client Engine
This project represents a client side implementation for [AeroGear Differential 
Synchronization (DS) Server](https://github.com/danbev/aerogear-sync-server/tree/differential-synchronization).

## Prerequisites 
This project requires Xcode6-beta7 to run.


## Building

Building can be done by opening the project in Xcode:

    open AeroGearSync.xcodeproj

or you can use the command line.
Make sure you are using Xcode6-beta7: 

    sudo xcode-select -s /Applications/Xcode6-Beta7.app/Contents/Developer

    xcodebuild -scheme AeroGearSync build

## Testing
Tests can be run from with in Xcode using Product->Test menu option (CMD+U).  
You can also run test from the command:

    xcodebuild test -scheme AeroGearSync -destination 'platform=iOS Simulator,name=iPhone 5s'






    

