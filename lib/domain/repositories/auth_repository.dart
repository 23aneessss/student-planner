// lib/domain/repositories/auth_repository.dart
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants.dart';
import '../../data/remote/api_client.dart';
import '../../data/remote/auth_remote.dart';
import '../models/user_profile.dart';

class AuthRepository {
  AuthRepository({
    required FlutterSecureStorage secureStorage,
    required SharedPreferences prefs,
    required AuthRemote authRemote,
    required ApiClient apiClient,
    GoogleSignIn? googleSignIn,
  }) : _secureStorage = secureStorage,
       _prefs = prefs,
       _authRemote = authRemote,
       _apiClient = apiClient,
       _googleSignIn =
           googleSignIn ?? GoogleSignIn(scopes: const <String>['email']);

  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _prefs;
  final AuthRemote _authRemote;
  final ApiClient _apiClient;
  final GoogleSignIn _googleSignIn;

  UserProfile? _cachedUser;

  bool isAuthenticated() => _cachedUser != null;

  Future<UserProfile?> restoreSession() async {
    final String? rawProfile = _prefs.getString(kProfileKey);
    if (rawProfile == null || rawProfile.isEmpty) {
      return null;
    }
    _cachedUser = UserProfile.fromJson(
      jsonDecode(rawProfile) as Map<String, dynamic>,
    );
    return _cachedUser;
  }

  Future<UserProfile> signInWithEmail(String email, String password) async {
    if (!AppConfig.remoteServicesEnabled) {
      return _storeProfile(
        UserProfile(
          id: const Uuid().v4(),
          email: email,
          fullName: email.split('@').first,
          scholarYear: kScholarYearOptions.first,
          isLocalOnly: true,
        ),
      );
    }

    final AuthRemoteResponse response = await _authRemote.signInWithEmail(
      email: email,
      password: password,
    );
    await _apiClient.storeTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
    return _storeProfile(response.user);
  }

  Future<UserProfile> signUpWithEmail(
    String email,
    String password,
    String fullName,
    String scholarYear,
  ) async {
    if (!AppConfig.remoteServicesEnabled) {
      return _storeProfile(
        UserProfile(
          id: const Uuid().v4(),
          email: email,
          fullName: fullName,
          scholarYear: scholarYear,
          isLocalOnly: true,
        ),
      );
    }

    final AuthRemoteResponse response = await _authRemote.signUpWithEmail(
      email: email,
      password: password,
      fullName: fullName,
      scholarYear: scholarYear,
    );
    await _apiClient.storeTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
    return _storeProfile(response.user);
  }

  Future<UserProfile> signInWithGoogle() async {
    if (!AppConfig.googleSignInEnabled) {
      throw StateError('Google sign-in is not enabled for this build.');
    }
    final GoogleSignInAccount? account = await _googleSignIn.signIn();
    if (account == null) {
      throw StateError('Google sign-in was canceled.');
    }
    final GoogleSignInAuthentication authentication =
        await account.authentication;
    final String? idToken = authentication.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw StateError('Google did not return an ID token.');
    }

    if (!AppConfig.remoteServicesEnabled) {
      return _storeProfile(
        UserProfile(
          id: const Uuid().v4(),
          email: account.email,
          fullName: account.displayName ?? account.email,
          scholarYear: kScholarYearOptions.first,
          avatarUrl: account.photoUrl,
          isLocalOnly: true,
        ),
      );
    }

    final AuthRemoteResponse response = await _authRemote.signInWithGoogle(
      idToken: idToken,
      accessToken: authentication.accessToken,
    );
    await _apiClient.storeTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
    return _storeProfile(response.user);
  }

  Future<void> signOut() async {
    _cachedUser = null;
    await _apiClient.clearTokens();
    await _prefs.remove(kProfileKey);
    await _googleSignIn.signOut();
    await _secureStorage.deleteAll();
  }

  Future<UserProfile> updateProfile(UserProfile profile) {
    return _storeProfile(profile);
  }

  Future<UserProfile> _storeProfile(UserProfile profile) async {
    _cachedUser = profile;
    await _prefs.setString(kProfileKey, jsonEncode(profile.toJson()));
    return profile;
  }
}
