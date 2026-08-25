# Bill Share App Notes

## Deployment

````
flutter build web --release
firebase deploy --only hosting
````

---

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
<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE plist PUBLIC
    "-//Apple//DTD PLIST 1.0//EN"
    "[http://www.apple.com/DTDs/PropertyList-1.0.dtd](http://www.apple.com/DTDs/PropertyList-1.0.dtd)">
<plist version="1.0">
    <dict>
        <key>com.apple.security.app-sandbox</key>
        <true />
        <!-- Enable Outbound Network Access -->
        <key>com.apple.security.network.client</key>
        <true />
    </dict>
</plist>

    not that a shutdown of the app is required not merely a hot restart


    ~/Library/Android/sdk/platform-tools/adb push assets/test_receipts/aldi.png/sdcard/Pictures/


    # TabSettle Setup & Architecture Notes

    ## 1. Firebase Initialization

    ### CLI Authentication & Project SetupTo avoid global project ID collision errors in Google Cloud, create the project in the [Firebase Console](https://console.firebase.google.com/) first, then link it locally:

    ```bash# Force re-authentication if credentials expirefirebase logoutfirebase login

    # Select and configure your existing console projectflutterfire configure
```

### Application Bootstrapping (`main.dart`)

Initialize `firebase_core` using the generated `firebase_options.dart` before
running the Flutter app widget:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}
```

---

## 2. Firestore Data Layer Architecture

### Type-Safe Converters (`withConverter`)

Enforce Freezed model types directly on Firestore collection references to avoid
manual `Map<String, dynamic>` casting:

```dart
CollectionReference<Receipt> get receiptsRef =>
    FirebaseFirestore.instance.collection('receipts').withConverter<Receipt>(
      fromFirestore: (snapshot, _) =>
          Receipt.fromJson(snapshot.data()!
            ..['id'] = snapshot.id),
      toFirestore: (receipt, _) =>
      receipt.toJson()
        ..remove('id'),
    );

CollectionReference<ReceiptLineItem> itemsRef(String receiptId) =>
    receiptsRef.doc(receiptId).collection('items').withConverter<
        ReceiptLineItem>(
      fromFirestore: (snapshot, _) =>
          ReceiptLineItem.fromJson(snapshot.data()!
            ..['id'] = snapshot.id),
      toFirestore: (item, _) =>
      item.toJson()
        ..remove('id'),
    );
```

### Atomic Batch Persistence

Persist root documents and nested subcollections in a single atomic transaction:

```dart
Future<String> saveReceipt(Receipt receipt) async {
  final batch = FirebaseFirestore.instance.batch();

  final docRef = receipt.id == null || receipt.id!.isEmpty
      ? receiptsRef.doc()
      : receiptsRef.doc(receipt.id);

  batch.set(docRef, receipt);

  final subcollection = itemsRef(docRef.id);
  for (final item in receipt.items) {
    final itemRef = item.id.isEmpty ? subcollection.doc() : subcollection.doc(
        item.id);
    batch.set(itemRef, item);
  }

  await batch.commit();
  return docRef.id;
}
```

---

## 3. iOS Platform Configuration

Recent Firebase SDK dependencies require raising the minimum iOS deployment
target from `13.0` to `15.0`.

### Update `ios/Podfile`

```ruby
platform :ios, '15.0'
```

### Re-link CocoaPods Dependencies

```bash
cd ios
pod install
cd ..
flutter clean
flutter pub get
```

---

## 4. macOS App Sandbox Entitlements

To enable Gemini/Firebase network traffic and prevent the UI thread from locking
when launching native file pickers, update **both**
`macos/Runner/DebugProfile.entitlements` and`macos/Runner/Release.entitlements`:

```xml
<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE plist PUBLIC
    "-//Apple//DTD PLIST 1.0//EN"
    "[http://www.apple.com/DTDs/PropertyList-1.0.dtd](http://www.apple.com/DTDs/PropertyList-1.0.dtd)">
<plist version="1.0">
    <dict>
        <key>com.apple.security.app-sandbox</key>
        <true />

        <!-- Outbound HTTP/HTTPS access for Gemini API and Firebase Firestore -->
        <key>com.apple.security.network.client</key>
        <true />

        <!-- Grants access to image files selected via the native file picker -->
        <key>com.apple.security.files.user-selected.read-only</key>
        <true />
    </dict>
</plist>
```