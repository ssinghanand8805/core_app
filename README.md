# 🚀 Flutter Scalable App (GetX + Offline First)

A production-ready Flutter starter project built with **GetX**, **Clean Architecture**, **API integration**, and **Offline-first approach**.
This project is designed to be scalable, maintainable, and easy to extend.

---

## 📦 Features

* ✅ Clean Architecture (Core / Data / Domain / Presentation)
* ✅ GetX (State Management + Routing + Dependency Injection)
* ✅ API Integration (Dio)
* ✅ Offline-first support (SQLite / Drift)
* ✅ Theme switching (Light / Dark mode)
* ✅ Localization (Multi-language support)
* ✅ Centralized error handling (Toast / Exceptions)
* ✅ Connectivity handling (Online / Offline detection)

---

## 🧱 Project Structure

```
lib/
│
├── core/
├── data/
├── domain/
├── presentation/
├── routes/
├── l10n/
├── main.dart
```

---

## ⚙️ Setup Instructions

### 1. Clone the repository

```
## Clone the repository

git clone https://github.com/ssinghanand8805/core_app.git
cd <project-folder>
```

### 2. Install dependencies

```
flutter pub get
```

### 3. Run the app

```
flutter run
```

---

## 🔌 Core Technologies

| Feature          | Technology Used   |
| ---------------- | ----------------- |
| State Management | GetX              |
| API              | Dio               |
| Local Storage    | Drift / SQLite    |
| Connectivity     | connectivity_plus |
| Localization     | GetX `.tr`        |

---

## 🔁 Data Flow (Offline First)

```
UI → Controller → Repository
                    ↓
        Local DB (Drift) ←→ Remote API (Dio)
```

* Loads data from **local DB first**
* Syncs with API in background
* UI updates automatically

---

## 🎨 Theme Change

* Light / Dark mode supported
* Preference saved locally

---

## 🌍 Localization

Supported languages:

* English
* Hindi
* Arabic
* Urdu

Usage:

```
Text("key".tr)
```

---

## 🚨 Error Handling

* Centralized exception handling
* Toast-based user feedback
* Handles network, server, and cache errors

---

## 📡 Connectivity

* Detects online/offline state
* Supports offline usage
* Syncs automatically when online

---

## 🧠 Best Practices Used

* Clean Architecture
* Repository Pattern
* Reactive UI (GetX)
* Separation of concerns
* Scalable structure

---

## 🛠️ Future Improvements

* Pagination support
* Background sync
* Push notifications
* Unit & integration testing

---

## 💡 Suggestions & Improvements

We welcome feedback from developers to improve this project.

If you have ideas, feel free to:

* Suggest architectural improvements
* Optimize performance or memory usage
* Improve UI/UX patterns
* Add new features (pagination, caching strategies, etc.)
* Enhance error handling or logging
* Improve code readability and reusability

You can contribute by:

* Opening an issue
* Submitting a pull request
* Sharing feedback or ideas

---

## 🤝 Contribution

Contributions are welcome!
Feel free to fork the repo and submit PRs.

---

## 📄 License

This project is open-source and free to use.
