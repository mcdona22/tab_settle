# tab_settle

### Commands Look up

`dart run build_runner watch --delete-conflicting-outputs`

## macOS Network Setup (App Sandbox)

When building for macOS, Flutter enforces Apple's App Sandbox. By default,
outbound network requests (HTTPS/Sockets) are blocked, which will result in
`SocketException: Connection failed (OS Error: Operation not permitted, errno = 1)`
when attempting to reach external APIs like Google Gemini.

### Enabling Outbound Network Access

Add the `com.apple.security.network.client` entitlement to both Debug and
Release configurations.

1. Open `macos/Runner/DebugProfile.entitlements` and
   `macos/Runner/Release.entitlements`.
2. Add the `<key>com.apple.security.network.client</key>` entitlement inside the
   `<dict>` block:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "[http://www.apple.com/DTDs/PropertyList-1.0.dtd](http://www.apple.com/DTDs/PropertyList-1.0.dtd)">
<plist version="1.0">
<dict>
    <key>com.apple.security.app-sandbox</key>
    <true/>
    <!-- Enable Outbound Network Access -->
    <key>com.apple.security.network.client</key>
    <true/>
</dict>
</plist>

not that a shutdown of the app is required not merely a hot restart
