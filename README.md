# moneypoo

Track your breaks at work and calculate how much money you're being paid.

# TODO list

- [x] Sort breaks by last added to the list first on top

- [x] Refacto dashboard.dart so that the file is smaller and cleaner

- [x] Create a new view Break to focus on one break and modify and/or delete it

- [x] Change FloatingActionButton for adding breaks color

- [x] Customize currency

- [x] Add reset button at the end of the list

- [x] Translate text in several languages

- [x] Add an icon to the project to make it more professional

- [ ] Add CI/CD to deploy Android app to the Play Store

# Useful commands

### Code generator for Flutter Riverpod

```bash
dart run build_runner watch
dart run build_runner build # One time
```

### Riverpod lint

```bash
dart run custom_lint
```

### Generate translations

```bash
flutter gen-l10n
```

### Generate icons

```bash
flutter pub run flutter_launcher_icons
```

### Complete command to start a clean app

```bash
flutter clean && flutter pub get && dart run build_runner build --delete-conflicting-outputs && flutter run
```
