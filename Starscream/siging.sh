#!/bin/bash

# Variables
XCFRAMEWORK_PATH="/private/tmp/xcf/CometChatStarscream.xcframework"
SIGNING_IDENTITY="K456T8RD7Z"
BUNDLE_ID="com.cometchat.starscream"
APPLE_ID="suryansh.bisen@cometchat.com"
APP_SPECIFIC_PASSWORD="abcd-efgh-ijkl-mnop"

# Navigate to the XCFramework directory
cd "$XCFRAMEWORK_PATH"

# Sign each framework within the XCFramework
for framework in $(find . -name '*.framework'); do
    codesign --force --deep --sign "$SIGNING_IDENTITY" "$framework"
done

# Verify the signature
for framework in $(find . -name '*.framework'); do
    codesign --verify --verbose "$framework"
done

# Create a zip archive
zip -r CometChatStarscream.xcframework.zip . -i CometChatStarscream.xcframework

# Submit for notarization
xcrun altool --notarize-app --primary-bundle-id "$BUNDLE_ID" --username "$APPLE_ID" --password "$APP_SPECIFIC_PASSWORD" --file CometChatStarscream.xcframework.zip

# Check notarization status (manual step)
echo "Check notarization status manually using the RequestUUID provided by the altool command."

# Staple the notarization ticket (once notarization is approved)
xcrun stapler staple CometChatStarscream.xcframework

echo "Signing and notarization process completed."
