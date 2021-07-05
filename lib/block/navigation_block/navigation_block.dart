import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_delivery/Condition & rules/C&R.dart';
import 'package:on_delivery/home/Home.dart';
import 'package:on_delivery/plans/plans_screen.dart';
import 'package:on_delivery/profiles/profile.dart';

enum NavigationEvents {
  HomePageClickedEvent,
  ProfilePageClickedEvent,
  ConditionRulesPageClickedEvent,
  PlansPageClickedEvent
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  NavigationBloc(NavigationStates initialState) : super(initialState);

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.HomePageClickedEvent:
        yield Home();
        break;
      case NavigationEvents.ProfilePageClickedEvent:
        yield Profile();
        break;
      case NavigationEvents.ConditionRulesPageClickedEvent:
        yield CR();
        break;
      case NavigationEvents.PlansPageClickedEvent:
        yield Plans();
        break;
    }
  }
}
