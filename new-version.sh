#!/bin/bash

# Function to display the build output path
display_output() {
    if [ "$1" == "ios" ]; then
        echo "Build output located at: build/ios/ipa"
    elif [ "$1" == "android" ]; then
        echo "Build output located at: build/app/outputs/bundle/release"
    fi
}

# Initial OS variable
OS=""

# Parse the operating system argument
while getopts "o:" opt; do
  case $opt in
    o)
      OS=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# Check if OS variable is set
if [ -z "$OS" ]; then
    echo "No -o option provided. Please specify -o with either 'android' or 'ios'."
    exit 1
fi

# Execute the build command based on the OS
if [ "$OS" == "ios" ]; then
    echo "Building for iOS..."
    flutter build ipa --obfuscate --split-debug-info=./debug-info
    display_output ios
elif [ "$OS" == "android" ]; then
    echo "Building for Android..."
    flutter build appbundle
    display_output android
else
    echo "Unsupported OS. Please specify -o with either 'android' or 'ios'."
    exit 1
fi
