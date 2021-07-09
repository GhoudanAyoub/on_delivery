import 'package:on_delivery/helpers/locationService.dart';
import 'package:on_delivery/helpers/location_provider.dart';
import 'package:on_delivery/helpers/map_model.dart';
import 'package:on_delivery/models/AgentLocation.dart';
import 'package:on_delivery/viewModel/EditProfileViewModel.dart';
import 'package:on_delivery/viewModel/conversation_view_model.dart';
import 'package:on_delivery/viewModel/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (_) => UserViewModel()),
  ChangeNotifierProvider(create: (_) => EditProfileViewModel()),
  ChangeNotifierProvider(create: (_) => LocationProvider()),
  StreamProvider<AgentLocation>(
    create: (context) => LocationService().locationStream,
  ),
  ChangeNotifierProvider(create: (_) => MyModel()),
  ChangeNotifierProvider(create: (_) => ConversationViewModel()),
  /*
  ChangeNotifierProvider(create: (_) => PostsViewModel()),
  ChangeNotifierProvider(create: (_) => VideoViewModel()),*/
];
