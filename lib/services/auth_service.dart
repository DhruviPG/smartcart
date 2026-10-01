import 'package:flutter/foundation.dart';

import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  AuthService._() {
    _accounts['demo@smartcart.com'] = _LocalAccount(
      password: '123456',
      user: const UserModel(
        uid: 'demo-user',
        name: 'Demo User',
        email: 'demo@smartcart.com',
        preference: 'Budget',
        address: 'Demo address',
      ),
    );
  }

  static final AuthService instance = AuthService._();

  final Map<String, _LocalAccount> _accounts = {};
  UserModel? _currentUser;

  bool get isSignedIn => _currentUser != null;

  UserModel? get currentUser => _currentUser;

  String? get currentUserEmail => _currentUser?.email;

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (_accounts.containsKey(normalizedEmail)) {
      throw StateError('An account with this email already exists.');
    }

    final user = UserModel(
      uid: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name.trim(),
      email: normalizedEmail,
      preference: 'Budget',
      address: 'Demo address',
    );
    _accounts[normalizedEmail] = _LocalAccount(password: password, user: user);
    _currentUser = user;
    notifyListeners();
  }

  Future<void> signIn({required String email, required String password}) async {
    final account = _accounts[email.trim().toLowerCase()];
    if (account == null || account.password != password) {
      throw StateError('Email or password is incorrect.');
    }

    _currentUser = account.user;
    notifyListeners();
  }

  void updatePreference(String preference) {
    final user = _currentUser;
    if (user == null) {
      return;
    }

    final updatedUser = UserModel(
      uid: user.uid,
      name: user.name,
      email: user.email,
      preference: preference,
      address: user.address,
    );
    _currentUser = updatedUser;
    _accounts[user.email] = _LocalAccount(
      password: _accounts[user.email]!.password,
      user: updatedUser,
    );
    notifyListeners();
  }

  Future<void> signOut() async {
    _currentUser = null;
    notifyListeners();
  }
}

class _LocalAccount {
  const _LocalAccount({required this.password, required this.user});

  final String password;
  final UserModel user;
}
