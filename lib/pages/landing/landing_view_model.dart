import 'package:flutter/foundation.dart';
import 'package:flutter_wishlist_app/services/authorization_service.dart';
class LandingViewModel extends ChangeNotifier {
  bool _signingIn = false;
  bool get signingIn => _signingIn;
  final AuthorizationService authorizationService;

  LandingViewModel(this.authorizationService);

  Future<void> signIn() async {
    try {
      _signingIn = true;
      notifyListeners();
      await authorizationService.authorize();
    } finally {
      _signingIn = false;
      notifyListeners();
    }
  }
}