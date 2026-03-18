import 'package:get/get.dart';
import 'en.dart';
import 'hi.dart';
import 'ar.dart';
import 'ur.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enTranslations,
    'hi_IN': hiTranslations,
    'ar_SA': arTranslations,
    'ur_PK': urTranslations,
  };
}