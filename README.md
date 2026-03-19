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
├── core/            # Common services, utils, network, error handling
├── data/            # Models, datasources (remote/local), repositories
├── domain/          # Entities, repositories (abstract), usecases
├── presentation/    # UI, controllers (GetX), widgets
├── routes/          # App routes and navigation
├── l10n/            # Localization files
├── main.dart        # Entry point
```

---

## ⚙️ Setup Instructions

### 1. Clone the repository

```
git clone <https://github.com/ssinghanand8805/core_app.git>
cd <project-folder>
```

---

### 2. Install dependencies

```
flutter pub get
```

---

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

* App always loads data from **local database first**
* Syncs with API in background
* UI updates automatically

---

## 🎨 Theme Change

* Supports Light & Dark mode
* Persisted using local storage

---

## 🌍 Localization

Supports multiple languages:

* English 🇺🇸
* Hindi 🇮🇳
* Arabic 🇸🇦
* Urdu 🇵🇰

Usage:

```
Text("key".tr)
```

---

## 🚨 Error Handling

Centralized error handling using:

* Custom Exceptions
* Toast messages
* Network / Server / Cache error handling

---

## 📡 Connectivity

* Detects internet status
* Supports offline usage
* Syncs data when online

---

## 🧠 Best Practices Used

* Separation of concerns (Clean Architecture)
* Repository pattern
* Reactive UI with GetX
* Reusable components
* Scalable folder structure

---

## 🛠️ Future Improvements

* Pagination support
* Background sync
* Push notifications
* Unit & integration testing

---

## 🤝 Contribution

Feel free to fork and improve the project.
Pull requests are welcome!

---

## 📄 License

This project is open-source and free to use.
