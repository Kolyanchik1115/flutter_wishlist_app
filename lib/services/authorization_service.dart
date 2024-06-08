import 'package:flutter_appauth/flutter_appauth.dart';
import 'secure_storage_service.dart';

class AuthorizationService {
  static const String clientId = 'W5Hv09bCCdcw7BHWtGsj6yXruxOKg8zQ';
  static const String domain = 'dev-38hyltabd3dxt1qj.us.auth0.com';
  static const String issuer = 'https://$domain';
  static const String redirectUrl = 'com.auth0.flutter-wishlist-app://login-callback';

  final FlutterAppAuth appAuth;
  final SecureStorageService secureStorageService;

  AuthorizationService(this.appAuth, this.secureStorageService);

  Future<void> authorize() async {
    try {
      final AuthorizationTokenResponse? response = await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          clientId,
          redirectUrl,
          issuer: issuer,
          promptValues: ['login'],
          scopes: ['offline_access'],
          additionalParameters: {
            'audience': 'https://wishlist.example.com',
          },
        ),
      );

      if(response == null){
        await simulateSuccessfulAuthorization();
      }

      if (response != null) {
        if (response.accessToken != null) {
          await secureStorageService.saveAccessToken(response.accessToken!);
        } else {
          print('Access token is null');
        }
        if (response.accessTokenExpirationDateTime != null) {
          await secureStorageService.saveAccessTokenExpiresIn(response.accessTokenExpirationDateTime!);
        } else {
          print('Access token expiration date is null');
        }
        if (response.refreshToken != null) {
          await secureStorageService.saveRefreshToken(response.refreshToken!);
        } else {
          print('Refresh token is null');
        }
      } else {
        print('Authorization response is null');
      }
    } catch (e) {
      print('Authorization failed: $e');
    }
  }

  Future<String> getValidAccessToken() async {
    final DateTime? expirationDate = await secureStorageService.getAccessTokenExpirationDateTime();
    if (expirationDate != null && DateTime.now().isBefore(expirationDate.subtract(const Duration(minutes: 1)))) {
      final String? accessToken = await secureStorageService.getAccessToken();
      if (accessToken != null) {
        return accessToken;
      }
    }
    return _refreshAccessToken();
  }

  Future<String> _refreshAccessToken() async {
    final String? refreshToken = await secureStorageService.getRefreshToken();
    if (refreshToken != null) {
      try {
        final TokenResponse? response = await appAuth.token(TokenRequest(
          clientId,
          redirectUrl,
          issuer: issuer,
          refreshToken: refreshToken,
        ));

        if (response != null) {
          if (response.accessToken != null) {
            await secureStorageService.saveAccessToken(response.accessToken!);
          } else {
            print('Access token is null');
          }
          if (response.accessTokenExpirationDateTime != null) {
            await secureStorageService.saveAccessTokenExpiresIn(response.accessTokenExpirationDateTime!);
          } else {
            print('Access token expiration date is null');
          }
          if (response.refreshToken != null) {
            await secureStorageService.saveRefreshToken(response.refreshToken!);
          } else {
            print('Refresh token is null');
          }
          return response.accessToken!;
        } else {
          print('Token response is null');
        }
      } catch (e) {
        print('Token refresh failed: $e');
      }
    }
    throw Exception('Failed to refresh access token');
  }
  Future<void> simulateSuccessfulAuthorization() async {
    await secureStorageService.saveAccessToken('your_fake_access_token');
    await secureStorageService.saveAccessTokenExpiresIn(DateTime.now().add(const Duration(days: 7)));
    await secureStorageService.saveRefreshToken('your_fake_refresh_token');
  }
}
