import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsState extends Equatable {
  final ThemeMode themeMode;

  const SettingsState({this.themeMode = ThemeMode.light});

  bool get isDark => themeMode == ThemeMode.dark;

  SettingsState copyWith({ThemeMode? themeMode}) {
    return SettingsState(themeMode: themeMode ?? this.themeMode);
  }

  @override
  List<Object?> get props => [themeMode];
}
