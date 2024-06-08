import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/item.dart';
import '../../models/wishlist.dart';
import '../add_item/add_item_page.dart';
import '../edit_item/edit_item_page.dart';
import '../landing/landing_page.dart';
import 'wishlist_view_model.dart';

class WishlistPage extends StatefulWidget {
  static const String route = 'wishlist';
  final WishlistViewModel viewModel;

  const WishlistPage({super.key, required this.viewModel});

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.loadInitialWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () async {
                await _signOut(context);
              })
        ],
      ),
      body: FutureBuilder<Wishlist>(
        future: widget.viewModel.wishlistFuture,
        builder: (_, AsyncSnapshot<Wishlist> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        const Text('Oops we had trouble loading your wishlist'),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () async {
                            await widget.viewModel.refreshWishlist();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              final List<Item> items = snapshot.data?.items ?? <Item>[];
              if (items.isEmpty) {
                return const Center(
                  child: Text('Your wishlist is empty. Why not add some items'),
                );
              }
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, int index) {
                  final Item item = items[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(item.name),
                                Text(item.description),
                                GestureDetector(
                                  onTap: () => launch(item.url),
                                  child: Text(
                                    item.url,
                                    style: const TextStyle(decoration: TextDecoration.underline),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await _editItem(item);
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () async {
                              await _deleteItem(item);
                            },
                            icon: const Icon(Icons.delete),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            default:
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text('Loading your wishlist'),
                      SizedBox(height: 32),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _addItem(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _deleteItem(Item item) async {
    try {
      await widget.viewModel.deleteItem(item);
    } on Exception catch (e) {
      if (e is PlatformException && e.message!.contains('invalid refresh token')) {
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: const Text('Your session has expired and will need to sign in again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  await _signOut(context);
                },
                child: const Text('OK'),
              )
            ],
          ),
        );
      } else {
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: const Text('Failed to delete the item'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              )
            ],
          ),
        );
      }
    }
  }

  Future<void> _signOut(BuildContext context) async {
    await Navigator.of(context).pushNamedAndRemoveUntil(LandingPage.route, (_) => false);
  }

  Future<void> _addItem(BuildContext context) async {
    final Object? addedItem = await Navigator.of(context).pushNamed(AddItemPage.route);
    if ((addedItem as bool) ?? false) {
      await widget.viewModel.refreshWishlist();
    }
  }

  Future<void> _editItem(Item item) async {
    final Object? addedItem = await Navigator.of(context).pushNamed(EditItemPage.route, arguments: item);
    if ((addedItem as bool) ?? false) {
      await widget.viewModel.refreshWishlist();
    }
  }
}
