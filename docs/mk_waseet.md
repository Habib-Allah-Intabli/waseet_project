
# 📱 Project: Waseet App (Ride & Package Sharing)

---

## 🧾 Overview

Waseet is a Flutter mobile app that connects travelers with users who want to:

* book seats
* send parcels between cities

The traveler is already traveling and shares the trip.

---

## ⚙️ Tech Stack

* Flutter
* Firebase:

  * Authentication
  * Firestore
  * FCM

---

## 🧠 Architecture (MANDATORY)

Use Clean Architecture:

Layers:

* presentation
* domain
* data

---

## 🧠 State Management (MANDATORY)

Use BLoC (flutter_bloc)

Each feature MUST include:

* bloc/

  * events.dart
  * states.dart
  * bloc.dart

UI:

* BlocBuilder
* BlocListener

Do NOT use Provider or Riverpod

---

## 🌍 Localization (MANDATORY)

Use easy_localization

Languages:

* Arabic (default, RTL)
* English (LTR)

Rules:

* No hardcoded text
* Use JSON files:

  * assets/translations/ar.json
  * assets/translations/en.json

Usage:
Text('login'.tr())

---

## 📱 Responsive Design (MANDATORY)

Use flutter_screenutil

Requirements:

* Wrap app with ScreenUtilInit
* Use:

  * .w for width
  * .h for height
  * .sp for font size

Example:
SizedBox(height: 20.h)
Text('login'.tr(), style: TextStyle(fontSize: 16.sp))

Do NOT use fixed sizes.

---

## 📂 Project Structure

lib/
├── core/
├── features/
│    ├── auth/
│    ├── home/
│    ├── trips/
│    ├── requests/
│    ├── chat/
│    ├── profile/
│    └── settings/
├── models/
├── services/
├── routes/
└── main.dart

---

## 🧩 Entities (STRICT)

User:

* id
* name
* phone
* avatarUrl
* rating
* tripsCount
* isVerified
* createdAt

Trip:

* id
* userId
* fromCity
* toCity
* date
* availableSeats
* allowParcel
* notes
* status

Request:

* id
* type (person / parcel)
* tripId
* userId
* seats
* parcelDescription
* parcelWeight
* parcelImage
* price
* status
* notes
* createdAt

Conversation:

* id
* participants
* tripId
* lastMessage
* lastMessageAt

Message:

* id
* conversationId
* senderId
* message
* type
* createdAt

Rating:

* id
* fromUserId
* toUserId
* tripId
* rating
* comment
* createdAt

Notification:

* id
* userId
* title
* body
* type
* isRead
* createdAt

---

## 🗄️ Firestore

Collections:

* users
* trips
* requests
* conversations
* ratings
* notifications

Subcollection:

* messages (inside conversations)

---

## 🧭 Navigation (MANDATORY)

Use named routes:

/splash
/onboarding
/login
/register
/home
/add_trip
/add_request
/trip_details
/chat
/my_requests
/profile
/settings
/edit_profile

Use:
Navigator.pushNamed()

---

## 🎨 UI Rules

* Arabic RTL
* Clean modern design
* Colors:

  * Blue (primary)
  * White (background)
  * Amber (accent)
* Material 3

---

## 🔗 Stitch UI Integration

Use existing UI from:

stitch_wasset_ride_package_sharing/

Rules:

* Reuse UI
* Convert to Flutter widgets
* Do NOT redesign

---

## 🔥 Business Rules

* User creates trips
* Trip has many requests
* Chat between users
* Rating after trip ends

---

## 💬 Chat

* Realtime
* messages subcollection
* update lastMessage

---

## 🔔 Notifications

Trigger on:

* new request
* accepted request
* new message

---

## 🚫 Strict Rules

* No isolated screens
* No hardcoded text
* No fixed sizes
* No changing entities
* Must use Bloc
* Must use localization
* Must use screenutil

---

## 🎯 Goal

Build a scalable, production-ready Flutter app.
