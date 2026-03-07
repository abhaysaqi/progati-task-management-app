import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object?> get props => [];
}

class ToggleThemeEvent extends SettingsEvent {
  const ToggleThemeEvent();
}

class SetThemeEvent extends SettingsEvent {
  final ThemeMode themeMode;
  const SetThemeEvent(this.themeMode);
  @override
  List<Object?> get props => [themeMode];
}
