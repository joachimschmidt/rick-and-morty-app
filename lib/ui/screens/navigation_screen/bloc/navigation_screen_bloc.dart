import 'dart:async';

import 'package:bloc/bloc.dart';

import 'bloc.dart';

class NavigationScreenBloc
    extends Bloc<NavigationScreenEvent, NavigationScreenState> {
  bool hasInternetConnection;

  NavigationScreenBloc(this.hasInternetConnection)
      : super(MainPage(hasInternetConnection));

  NavigationScreenState get initialState => MainPage(hasInternetConnection);

  @override
  Stream<NavigationScreenState> mapEventToState(
    NavigationScreenEvent event,
  ) async* {
    if (event is SwitchToScreen)
      switch (event.screenIndex) {
        case 0:
          yield FirstPage();
          break;
        case 2:
          yield ThirdPage();
          break;
        case 1:
          yield MainPage(hasInternetConnection);
          break;
      }
  }
}
