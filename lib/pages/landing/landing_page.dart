import 'package:flutter/material.dart';
import '../wishlist_page/wishlist_page.dart';
import 'landing_view_model.dart';

class LandingPage extends StatelessWidget {
  static const String route = '/';
  final LandingViewModel viewModel;

  const LandingPage({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Welcome to your wishlist.',
              textAlign: TextAlign.center,
            ),
            const Text(
              'Sign in to get started.',
              textAlign: TextAlign.center,
            ),
            if (viewModel.signingIn) ...const <Widget>[
              SizedBox(
                height: 32,
              ),
              Center(child: CircularProgressIndicator()),
            ],
            const Expanded(
              child: SizedBox(
                height: 32,
              ),
            ),
            ElevatedButton(
              onPressed: viewModel.signingIn
                  ? null
                  : () async {
                await signIn(context);
              },
              child: const Text('Sign in with Auth0'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signIn(BuildContext context) async {
    await viewModel.signIn();
    await Navigator.of(context)
        .pushNamedAndRemoveUntil(WishlistPage.route, (_) => false);
  }
}
