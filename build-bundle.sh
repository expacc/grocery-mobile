#!/bin/bash 
PATH_PROJECT=$(pwd)

# build apk
flutter build appbundle --target-platform android-arm,android-arm64,android-x64 --release

# move file app-release.aab to folder certs
cp "$PATH_PROJECT/build/app/outputs/bundle/release/app-release.aab" "$PATH_PROJECT/bin/app-release.aab"