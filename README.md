# QuizFlow 🧠

A fully responsive, cross-platform Flutter quiz application that lets users test their knowledge across 10 categories using the [Open Trivia Database](https://opentdb.com/) API.

---

## Features

- 🔐 **Demo Login** — email/password auth (demo credentials provided on the login screen)
- 🏠 **Home** — browse 10 quiz categories in a responsive grid (mobile + tablet/web)
- ❓ **Quiz** — 10 multiple-choice questions per category with a 60-second countdown timer
- 📊 **Results** — detailed score breakdown (correct, accuracy, wrong answers)
- 🏆 **Leaderboard** — ranked list of top performers; your entry is highlighted
- 👤 **Profile** — view rank, score, and account info; logout button

---

## Tech Stack

| Layer | Technology |
|--|--|
| Framework | Flutter 3.x |
| State Management | Provider (`ChangeNotifier`) |
| Routing | `auto_route` |
| HTTP | `Dio` |
| Quiz API | [Open Trivia DB](https://opentdb.com/) |
| Localisation | `easy_localization` |
| DI | `get_it` |
| Storage | `shared_preferences` |
| Config | `flutter_dotenv` |

---

## Architecture

```
lib/
├── app/
│   ├── resources/      # AppColors
│   ├── routes/         # AutoRoute config + generated router
│   └── utils/          # AppConstants, SharedPrefsHelper, FormValidator
├── data/
│   ├── datasources/    # AuthRemoteDataSource (Dio)
│   ├── models/         # quiz_models, signup_resp_model, user_model
│   ├── repository/     # AuthRepositoryImpl
│   └── utils/          # ConstantFunc (error extraction, logout)
├── domain/
│   ├── repository/     # AuthRepository (abstract)
│   ├── usecase/        # LoginUser
│   └── utils/          # AppEndpoints (all URL constants)
├── presentation/
│   ├── bloc/           # AuthState
│   ├── pages/          # splash, login, main, home, quiz, profile, ranking
│   ├── providers/      # QuizProvider, UserSessionProvider
│   ├── viewModels/     # AuthViewModel
│   └── widgets/        # CustomTextField
├── injection_container.dart
└── main.dart
```

---

## Getting Started

### Prerequisites
- Flutter SDK ≥ 3.x
- Dart ≥ 3.x
- Android SDK / Xcode (for native builds)

### 1. Clone the repo
```bash
git clone https://github.com/your-org/QuizFlow.git
cd QuizFlow
```

### 2. Configure environment variables
```bash
cp .env.example .env
```
Edit `.env`:
```env
BASE_URL=https://your-backend.com
TRIVIA_API_BASE_URL=https://opentdb.com
```

### 3. Install dependencies
```bash
flutter pub get
```

### 4. Run the app
```bash
flutter run
```

### Demo credentials
| Field | Value |
|--|--|
| Email | `test@gmail.com` |
| Password | `Test@123` |

---

## Package Name

`com.assesment.app`

---

## Running Tests

```bash
flutter test
```
