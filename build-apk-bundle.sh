#!/bin/bash 
PATH_PROJECT=$(pwd)

# build apk
flutter build apk --target-platform android-arm,android-arm64,android-x64 --split-per-abi --release

# move file app-release.aab to folder certs
cp "$PATH_PROJECT/build/app/outputs/apk/release/app-arm64-v8a-release.apk" "$PATH_PROJECT/bin/app-arm64-v8a-release.apk"
cp "$PATH_PROJECT/build/app/outputs/apk/release/app-armeabi-v7a-release.apk" "$PATH_PROJECT/bin/app-armeabi-v7a-release.apk"
cp "$PATH_PROJECT/build/app/outputs/apk/release/app-x86_64-release.apk" "$PATH_PROJECT/bin/app-x86_64-release.apk"