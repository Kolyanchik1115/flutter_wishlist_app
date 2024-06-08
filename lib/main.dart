import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_wishlist_app/pages/wishlist_page/wishlist_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'models/item.dart';
import 'pages/add_item/add_item_page.dart';
import 'pages/add_item/add_item_view_model.dart';
import 'pages/edit_item/edit_item_page.dart';
import 'pages/edit_item/edit_item_view_model.dart';
import 'pages/landing/landing_page.dart';
import 'pages/landing/landing_view_model.dart';
import 'pages/wishlist_page/wishlist_page.dart';
import 'services/authorization_service.dart';
import 'services/secure_storage_service.dart';
import 'services/wishlist_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const FlutterSecureStorage secureStorage = FlutterSecureStorage();
  final SecureStorageService secureStorageService = SecureStorageService(secureStorage);
  final String? refreshToken = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Imc4WlNHMlRuOHJ3VGd0NTBIU1lGQSJ9.eyJpc3MiOiJodHRwczovL2Rldi0zOGh5bHRhYmQzZHh0MXFqLnVzLmF1dGgwLmNvbS8iLCJzdWIiOiJaQTZaVUNMaERoYW9ORzNwN3gxY2Jtc29tT1BNOVlIRkBjbGllbnRzIiwiYXVkIjoiaHR0cHM6Ly93aXNobGlzdC5leGFtcGxlLmNvbSIsImlhdCI6MTcxNzg3Mzk4NCwiZXhwIjoxNzE3OTYwMzg0LCJndHkiOiJjbGllbnQtY3JlZGVudGlhbHMiLCJhenAiOiJaQTZaVUNMaERoYW9ORzNwN3gxY2Jtc29tT1BNOVlIRiJ9.MCP9clqy8CTY3_tty_O3EeODTuQIC1bWH7wD6tlF81udVhkvoYZvsrHn1IPdVa0Fw9kMd3B9n_XriMGg3xT7_oZ1vjym7rL1qVPmMen2nz-qDJy3IxHHukcQ2RjFPiBcfF0g13X_GNMUOL8dfPHKy-EuZlfu1Gzp1YMgFUHwKhTlh4IxA2qN2IYjG66zCsD1EKkdg6I1ED7xbZD8ZV4NHmclMJsmqLbQacdzlVrDq_BpP9yq2VEFgpv6sAe6MIgnTPLuJ4gIQg8p6JDVlG-h4BfhLMSgu-WGEA3mt0_LTBDqDlgvWuJaShWGx967Q8jIZ_5bhq0ombgemTm3088HOg';
  // final String? refreshToken = null;
  final String initialRoute = refreshToken == null ? LandingPage.route : WishlistPage.route;
  runApp(
    MultiProvider(
      providers: <SingleChildWidget>[
        Provider<FlutterAppAuth>(
          create: (_) => FlutterAppAuth(),
        ),
        ProxyProvider<FlutterAppAuth, AuthorizationService>(
          update: (_, FlutterAppAuth appAuth, __) => AuthorizationService(appAuth, secureStorageService),
        ),
        ProxyProvider<AuthorizationService, WishlistService>(
          update: (_, AuthorizationService authorizationService, __) => WishlistService(authorizationService),
        ),
        ChangeNotifierProvider<LandingViewModel>(
          create: (BuildContext context) => LandingViewModel(
            Provider.of<AuthorizationService>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider<WishlistViewModel>(
          create: (BuildContext context) {
            return WishlistViewModel(Provider.of<WishlistService>(context, listen: false), secureStorageService);
          },
        ),
        ChangeNotifierProvider<AddItemViewModel>(
          create: (BuildContext context) {
            return AddItemViewModel(Provider.of<WishlistService>(context, listen: false), secureStorageService);
          },
        ),
        ChangeNotifierProvider<EditItemViewModel>(
          create: (BuildContext context) {
            return EditItemViewModel(Provider.of<WishlistService>(context, listen: false), secureStorageService);
          },
        ),
      ],
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wishlist',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: initialRoute,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case LandingPage.route:
            return MaterialPageRoute(
              builder: (_) => Consumer<LandingViewModel>(
                builder: (_, LandingViewModel viewModel, __) => LandingPage(viewModel: viewModel),
              ),
            );
          case WishlistPage.route:
            return MaterialPageRoute(
              builder: (_) => Consumer<WishlistViewModel>(
                builder: (_, WishlistViewModel viewModel, __) => WishlistPage(viewModel: viewModel),
              ),
            );
          case AddItemPage.route:
            return MaterialPageRoute(
              builder: (_) => Consumer<AddItemViewModel>(
                builder: (_, AddItemViewModel viewModel, __) => AddItemPage(viewModel: viewModel),
              ),
            );
          case EditItemPage.route:
            final Item item = settings.arguments as Item;
            return MaterialPageRoute(
              builder: (_) => Consumer<EditItemViewModel>(
                builder: (_, EditItemViewModel viewModel, __) => EditItemPage(item: item, viewModel: viewModel),
              ),
            );
        }
        return null;
      },
    );
  }
}
