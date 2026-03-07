import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  static const String _themeModeKey = 'theme_mode_key';

  SettingsBloc() : super(const SettingsState()) {
    on<ToggleThemeEvent>(_onToggle);
    on<SetThemeEvent>(_onSet);
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themeModeKey);
    if (isDark != null) {
      add(SetThemeEvent(isDark ? ThemeMode.dark : ThemeMode.light));
    }
  }

  Future<void> _saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeModeKey, mode == ThemeMode.dark);
  }

  void _onToggle(ToggleThemeEvent event, Emitter<SettingsState> emit) {
    final newMode = state.isDark ? ThemeMode.light : ThemeMode.dark;
    emit(state.copyWith(themeMode: newMode));
    _saveThemeMode(newMode);
  }

  void _onSet(SetThemeEvent event, Emitter<SettingsState> emit) {
    emit(state.copyWith(themeMode: event.themeMode));
    _saveThemeMode(event.themeMode);
  }
}
