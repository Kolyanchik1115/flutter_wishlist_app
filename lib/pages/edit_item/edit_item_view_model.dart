import 'package:flutter/foundation.dart';
import 'package:flutter_wishlist_app/services/secure_storage_service.dart';
import '../../models/item.dart';
import '../../services/wishlist_service.dart';

class EditItemViewModel extends ChangeNotifier {
  final WishlistService wishlistService;
  final SecureStorageService secureStorageService;
  bool _editingItem = false;
  bool get editingItem => _editingItem;
  EditItemViewModel(
      this.wishlistService,
      this.secureStorageService,
      );
  Future<void> editItem(Item item) async {
    try {
      _editingItem = true;
      notifyListeners();
      await wishlistService.editItem(item);
    } finally {
      _editingItem = false;
      notifyListeners();
    }
  }

  Future<void> signOut() {
    return secureStorageService.deleteAll();
  }
}