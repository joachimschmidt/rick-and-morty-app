import 'package:equatable/equatable.dart';

abstract class NavigationScreenEvent extends Equatable {
  const NavigationScreenEvent();
}

class SwitchToScreen extends NavigationScreenEvent {
  final int screenIndex;

  SwitchToScreen(this.screenIndex);

  @override
  List<Object> get props => [screenIndex];
}
