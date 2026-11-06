import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visioncompanion/core/constants/app_constants.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(SharedPreferences prefs)
      : _prefs = prefs,
        super(_initial(prefs));

  static const List<String> supportedCodes = ['en', 'hi'];

  final SharedPreferences _prefs;

  static Locale _initial(SharedPreferences prefs) {
    final saved = prefs.getString(AppConstants.localePref);
    return Locale(supportedCodes.contains(saved) ? saved! : 'en');
  }

  Future<void> select(String code) async {
    if (!supportedCodes.contains(code) || code == state.languageCode) return;
    emit(Locale(code));
    await _prefs.setString(AppConstants.localePref, code);
  }
}
