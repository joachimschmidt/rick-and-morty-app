import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/ui/common/theme/bloc/bloc.dart';

class ThemeSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DayNightSwitcher(
      isDarkModeEnabled:
          BlocProvider.of<ThemeBloc>(context).state.themeMode == ThemeMode.dark,
      onStateChanged: (bool isDarkModeEnabled) =>
          BlocProvider.of<ThemeBloc>(context)
              .add(ThemeChanged(isDarkModeEnabled)),
    );
  }
}
