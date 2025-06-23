class Language {
  
  //this command is used to generate the language files
  // dart  run easy_localization:generate -h 
  

  //this command is used to generate the codegen file
  // dart run easy_localization:generate -S "assets/languages" -O "lib/source/core/translations"   
  

  //this command is used to generate the key files
  // dart run easy_localization:generate -S "assets/languages" -O "lib/source/core/translations" -o "local_keys.g.dart" -f keys


  static const String englishLocale = 'en';
  static const String arabicLocale = 'ar';
  static const String kurdishLocale = 'fa';
  //this is the default language used in the app
  static const String defaultLanguage = 'en';

  static const String languagePath = 'assets/languages';

}
