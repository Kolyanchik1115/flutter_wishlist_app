import 'package:flutter/foundation.dart';
import 'package:flutter_wishlist_app/services/secure_storage_service.dart';
import '../../models/item.dart';
import '../../services/wishlist_service.dart';

class AddItemViewModel extends ChangeNotifier {
  final WishlistService wishlistService;
  final SecureStorageService secureStorageService;
  bool _addingItem = false;
  bool get addingItem => _addingItem;
  AddItemViewModel(
      this.wishlistService,
      this.secureStorageService,
      );
  Future<void> addItem(Item item) async {
    try {
      _addingItem = true;
      notifyListeners();
      await wishlistService.addItem(item);
    } finally {
      _addingItem = false;
      notifyListeners();
    }
  }
  Future<void> signOut() {
    return secureStorageService.deleteAll();
  }
}