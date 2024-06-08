import 'package:flutter/foundation.dart';
import 'package:flutter_wishlist_app/services/secure_storage_service.dart';
import '../../models/item.dart';
import '../../models/wishlist.dart';
import '../../services/wishlist_service.dart';

class WishlistViewModel extends ChangeNotifier {
  final WishlistService wishlistService;
  final SecureStorageService secureStorageService;

  late Future<Wishlist> _wishlistFuture;

  Future<Wishlist> get wishlistFuture => _wishlistFuture;

  WishlistViewModel(this.wishlistService, this.secureStorageService);

  Future<void> loadInitialWishlist() => _wishlistFuture = wishlistService.getWishList();

  Future<void> refreshWishlist() async {
    _wishlistFuture = wishlistService.getWishList();
    notifyListeners();
    await _wishlistFuture;
  }

  Future<void> deleteItem(Item item) async {
    await wishlistService.deleteItem(item);
    await refreshWishlist();
  }

  Future<void> signOut() {
    return secureStorageService.deleteAll();
  }
}
