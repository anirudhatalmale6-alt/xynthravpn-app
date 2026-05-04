import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthState { loggedOut, guest, loggedIn }

class AuthProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  AuthState _authState = AuthState.loggedOut;
  String _email = '';
  bool _hasSeenOnboarding = false;

  AuthProvider(this._prefs) {
    _loadState();
  }

  AuthState get authState => _authState;
  String get email => _email;
  bool get isLoggedIn => _authState == AuthState.loggedIn;
  bool get isGuest => _authState == AuthState.guest;
  bool get hasSeenOnboarding => _hasSeenOnboarding;

  void _loadState() {
    _hasSeenOnboarding = _prefs.getBool('has_seen_onboarding') ?? false;
    final savedAuth = _prefs.getString('auth_state');
    _email = _prefs.getString('user_email') ?? '';
    if (savedAuth == 'loggedIn' && _email.isNotEmpty) {
      _authState = AuthState.loggedIn;
    } else if (savedAuth == 'guest') {
      _authState = AuthState.guest;
    } else {
      _authState = AuthState.loggedOut;
    }
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _hasSeenOnboarding = true;
    await _prefs.setBool('has_seen_onboarding', true);
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    // Simulated login - accept any valid-looking credentials
    if (email.contains('@') && password.length >= 4) {
      _authState = AuthState.loggedIn;
      _email = email;
      await _prefs.setString('auth_state', 'loggedIn');
      await _prefs.setString('user_email', email);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String email, String password) async {
    // Simulated registration
    if (email.contains('@') && password.length >= 6) {
      _authState = AuthState.loggedIn;
      _email = email;
      await _prefs.setString('auth_state', 'loggedIn');
      await _prefs.setString('user_email', email);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> continueAsGuest() async {
    _authState = AuthState.guest;
    _email = '';
    await _prefs.setString('auth_state', 'guest');
    notifyListeners();
  }

  Future<void> logout() async {
    _authState = AuthState.loggedOut;
    _email = '';
    await _prefs.remove('auth_state');
    await _prefs.remove('user_email');
    notifyListeners();
  }
}
