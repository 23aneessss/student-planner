// lib/data/remote/auth_remote.dart
import '../../domain/models/user_profile.dart';
import 'api_client.dart';

typedef AuthRemoteResponse = ({
  UserProfile user,
  String accessToken,
  String refreshToken,
});

class AuthRemote {
  const AuthRemote(this._client);

  final ApiClient _client;

  Future<AuthRemoteResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic> data =
        (await _client.dio.post<Map<String, dynamic>>(
          '/auth/sign-in',
          data: <String, dynamic>{'email': email, 'password': password},
        )).data ??
        <String, dynamic>{};
    return _parse(data);
  }

  Future<AuthRemoteResponse> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String scholarYear,
  }) async {
    final Map<String, dynamic> data =
        (await _client.dio.post<Map<String, dynamic>>(
          '/auth/sign-up',
          data: <String, dynamic>{
            'email': email,
            'password': password,
            'fullName': fullName,
            'scholarYear': scholarYear,
          },
        )).data ??
        <String, dynamic>{};
    return _parse(data);
  }

  Future<AuthRemoteResponse> signInWithGoogle({
    required String idToken,
    String? accessToken,
  }) async {
    final Map<String, dynamic> data =
        (await _client.dio.post<Map<String, dynamic>>(
          '/auth/google',
          data: <String, dynamic>{
            'idToken': idToken,
            'accessToken': accessToken,
          },
        )).data ??
        <String, dynamic>{};
    return _parse(data);
  }

  AuthRemoteResponse _parse(Map<String, dynamic> data) {
    return (
      user: UserProfile.fromJson(data['user'] as Map<String, dynamic>),
      accessToken: data['accessToken'] as String? ?? '',
      refreshToken: data['refreshToken'] as String? ?? '',
    );
  }
}
