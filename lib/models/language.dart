enum Language {
  english(code: 'en', name: 'English'),
  french(code: 'fr', name: 'Français'),
  spanish(code: 'es', name: 'Español');

  const Language({required this.code, required this.name});

  final String code;
  final String name;
}