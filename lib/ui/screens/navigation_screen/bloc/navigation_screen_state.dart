import 'package:equatable/equatable.dart';

abstract class NavigationScreenState extends Equatable {
  final int index = 0;
  final bool hasConnection = false;
}

class MainPage extends NavigationScreenState {
  final int index = 1;
  final bool hasConnection;

  MainPage(this.hasConnection);

  @override
  List<Object> get props => [];
}

class FirstPage extends NavigationScreenState {
  final int index = 0;
  final bool hasConnection = false;

  @override
  List<Object> get props => [];
}

class ThirdPage extends NavigationScreenState {
  final int index = 2;
  final bool hasConnection = false;

  @override
  List<Object> get props => [];
}
