import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rick_and_morty_app/ui/common/theme/dark_theme.dart';
import 'package:rick_and_morty_app/ui/common/theme/light_theme.dart';
import 'package:rick_and_morty_app/ui/screens/navigation_screen/bloc/bloc.dart';

import 'data/models/character/character.dart';
import 'data/models/character/gender.dart';
import 'data/models/character/status.dart';
import 'data/models/episode/episode.dart';
import 'data/models/location/location.dart';
import 'ui/common/theme/bloc/bloc.dart';
import 'ui/screens/navigation_screen/navigation_screen.dart';

class SimpleBlocDelegate extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    super.onError(cubit, error, stackTrace);
    print(error);
  }
}

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CharacterAdapter());
  Hive.registerAdapter(LocationAdapter());
  Hive.registerAdapter(EpisodeAdapter());
  Hive.registerAdapter(StatusAdapter());
  Hive.registerAdapter(GenderAdapter());
  await Hive.openBox<int>('favorites');
  await Hive.openBox<Character>('characters');
  await Hive.openBox<Episode>('episodes');
  await Hive.openBox<Location>('locations');
  Bloc.observer = SimpleBlocDelegate();
  runApp(BlocProvider(
      create: (BuildContext context) => ThemeBloc()..add(ThemeLoadStarted()),
      child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  NavigationScreenBloc _navigationScreenBloc;
  bool determinedConnection = false;
  var listener;
  Key key = UniqueKey();

  void checkConnection() async {
    var status = await DataConnectionChecker().connectionStatus;
    switch (status) {
      case DataConnectionStatus.connected:
        _navigationScreenBloc = NavigationScreenBloc(true);
        break;
      default:
        _navigationScreenBloc = NavigationScreenBloc(false);
        break;
    }
    setState(() {
      determinedConnection = true;
    });
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          setState(() {
            _navigationScreenBloc = NavigationScreenBloc(true);
            key = UniqueKey();
          });
          break;
        case DataConnectionStatus.disconnected:
          setState(() {
            _navigationScreenBloc = NavigationScreenBloc(false);
            key = UniqueKey();
          });
          break;
      }
    });
  }

  @override
  void initState() {
    checkConnection();
    super.initState();
  }

  @override
  void dispose() {
    listener.cancel();
    _navigationScreenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: BlocBuilder<ThemeBloc, ThemeState>(builder: (context, themeState) {
        return MaterialApp(
          themeMode: themeState.themeMode,
          title: 'Rick And Morty',
          theme: lightTheme,
          darkTheme: darkTheme,
          home: determinedConnection
              ? BlocProvider.value(
                  value: _navigationScreenBloc, child: NavigationScreen())
              : Center(
                  child: CircularProgressIndicator(),
                ),
        );
      }),
    );
  }
}
