# fcm_test_flutter

An app that sends and receives messages via Firebase Cloud Messaging (FCM), written using Flutter for Android and iOS.

To run the app (Android only, for now...) - 

1.  Setup Flutter using instructions given at "https://flutter.io/setup"
1.  Clone this repo from GitHub using the following URL "https://github.com/minidez/fcm-test-flutter.git". You can do this directly from Android Studio/IntelliJ if that's what you want to use.
3.  Go to https://console.firebase.google.com, sign up and create a new app.
4.  In your Firebase console, click Settings > Project Settings.
5.  Copy the Web API key
6.  Set the value of the WEB_API_KEY constant in lib/main.dart to the value copied from your Firebase console.
7.  Back in your Firebase console, hit "Add Firebase to your Android app"
8.  Enter the package name uk.co.ianadie.fcmtestflutter
9.  Enter the SHA-1 for your debug certificate (see here: https://developers.google.com/android/guides/client-auth)
10.  Click Add app
11.  Take the google-services.json file and place it in the /app directory
12.  Connect a device or run an emulator
13.  Run the app using "flutter run" or the button in your IDE