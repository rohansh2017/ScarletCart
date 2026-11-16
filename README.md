# ScarletCart

A student-to-student grocery delivery app for Rutgers. A student who is already going to the store picks up items for students who are not, and gets paid once both sides confirm the handoff. Think carpooling, but for groceries.

Built in the RUMAD (Rutgers Mobile App Development) incubator, Spring 2025, by a team of five.

<!-- TODO: add 2 or 3 phone screenshots here (home, nearby requests map, order confirmation) -->

## What it does

- **Two roles in one app.** A requester builds a shopping list and places an order; a shopper sees open orders and accepts one.
- **Nearby requests on a map.** Shoppers see active requests around them on Google Maps.
- **Two-step confirmation.** The shopper marks an order delivered, then the requester marks it received. Payment is tied to the second confirmation, so neither side has to trust the other blindly.
- **Order tracking.** Each order moves through its states in Firestore, and both sides see updates as they happen.
- **Sign-in with Google**, through Firebase Authentication.

## Stack

| Layer | Tools |
|---|---|
| App | Flutter, Dart |
| Auth | Firebase Authentication, Google Sign-In |
| Data | Cloud Firestore |
| Notifications | Firebase Cloud Messaging |
| Payments | Stripe (`flutter_stripe`) |
| Maps | Google Maps (`google_maps_flutter`) |

## Project layout

| Path | What it is |
|---|---|
| `lib/main.dart` | App entry point and Firebase setup |
| `lib/frontend/` | Screens and widgets: home, cart, shopping list, shopper view, nearby requests, order tracking, confirmation |
| `lib/backend/` | Firebase options and the Stripe payment service |

## Run it

You need the [Flutter SDK](https://docs.flutter.dev/get-started/install) and your own Firebase project.

```bash
git clone https://github.com/rohansh2017/ScarletCart.git
cd ScarletCart
flutter pub get
flutter run
```

Before it will work end to end:

1. Point the app at your Firebase project with `flutterfire configure`, and enable Google sign-in and Firestore.
2. Put your Stripe test keys in `lib/backend/keys.dart`. The file ships with empty values.
3. Add a Google Maps API key for Android and iOS.

## Status and limitations

This is an incubator prototype, not a production app.

- Stripe is called from the client for demonstration. A real deployment would move payment logic to a server.
- There are no automated tests beyond the default Flutter widget test.
- It has not been released on the App Store or Play Store.
