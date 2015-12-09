xcodebuild -scheme Go2Study -destination 'platform=iphonesimulator,name=iPhone 6' -derivedDataPath Build
# xcrun instruments -w 'iPhone 6 (9.2)'
xcrun simctl install booted Build/Build/Products/Debug-iphonesimulator/Go2Study.app
xcrun simctl launch booted lol.go2study.Go2Study