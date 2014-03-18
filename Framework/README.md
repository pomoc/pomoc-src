# Pomoc Framework
SDK for talking to backend woots

## Building the SDK Framework
1. Open the Framework XCode Project
2. Change the Target to BuildPomoc
3. Build for Device
4. Build for any simulator
5. The framework file built will be copied to `${SRCROOT}/Distribution/Pomoc.framework`

It is important to run the Build command for *BOTH* device and simulator. If you do not build
for both device/simulator, the resulting `Pomoc.framework` file will only contain the binary for
either the device or simulator (as opposed to a 'fat' binary that will work for both device and
simulator)

If the project is building out of date binaries, you can try the following: 

1. Clean for device
2. Clean for any simulator
3. Go to `~/Library/Developer/Xcode/DerivedData/`, and delete the `Pomoc-<gibberish>` folder
4. Rebuild for Device
5. Rebuild for any simulator

## Reference
https://github.com/jverkoey/iOS-Framework#walkthrough
