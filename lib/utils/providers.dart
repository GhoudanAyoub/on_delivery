import 'package:on_delivery/helpers/location_provider.dart';
import 'package:on_delivery/viewModel/EditProfileViewModel.dart';
import 'package:on_delivery/viewModel/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (_) => UserViewModel()),
  ChangeNotifierProvider(create: (_) => EditProfileViewModel()),
  ChangeNotifierProvider(create: (_) => LocationProvider()),
  /*
  ChangeNotifierProvider(create: (_) => PostsViewModel()),
  ChangeNotifierProvider(create: (_) => VideoViewModel()),
  ChangeNotifierProvider(create: (_) => ConversationViewModel()),*/
];
