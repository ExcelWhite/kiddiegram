import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/foundation.dart';
import 'package:kiddiegram/appwrite/client_service.dart';
import 'package:kiddiegram/appwrite/user_service.dart';
import 'package:kiddiegram/functions/exceptions.dart';

enum AuthStatus {
  uninitialized,
  unauthenticated,
  authenticated,
}

class AuthService extends ChangeNotifier {
  final Account account = AccountService.instance.account;
  late User _currentUser;
  late final UserService userService;

  AuthStatus _status = AuthStatus.uninitialized;

  User get currentUser => _currentUser;
  AuthStatus get status => _status;
  String? get username => _currentUser.name;
  String? get email => _currentUser.email;
  String? get id => _currentUser.$id;

  AuthService() {
    _initialize();
  }

  Future<void> _initialize() async {
    init();
    await loadUser();
  }

  void init() {
    final database = Databases(ClientService.instance.client);
    userService = UserService(database);
  }

  Future<void> loadUser() async {
    try {
      print('Loading user...');
      final user = await account.get();
      _status = AuthStatus.authenticated;
      _currentUser = user;
      print('User loaded: ${_currentUser.name}');
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      print('Error loading user: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<User> createUser({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      // Check if the username exists
      if (await userService.isUsernameTaken(username)) {
        throw UsernameAlreadyExistsException('Username already exists');
      }

      // Register user
      final user = await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: username,
      );

      // Login user
      // await createEmailPasswordSession(email: email, password: password);

      // _status = AuthStatus.authenticated;

      // Create new record in users collection
      await userService.addUser(
        username: username,
        email: email,
      );

      return user;
    } finally {
      notifyListeners();
    }
  }

  Future<Session> createEmailPasswordSession({
    required String email,
    required String password,
  }) async {
    try {
      final session = await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      _currentUser = await account.get();
      _status = AuthStatus.authenticated;

      return session;
    } finally {
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await account.deleteSession(sessionId: 'current');
      _status = AuthStatus.unauthenticated;
    } finally {
      notifyListeners();
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      await account.createRecovery(
        email: email,
        url: 'https://kiddiegram.com/reset-password',
      );
    } catch (e) {
      throw ForgotPasswordException('Failed to send password reset email');
    } finally {
      notifyListeners();
    }
  }

  Future<void> resetPassword({
    required String userId,
    required String password,
    required String secret,
  }) async {
    try {
      await account.updateRecovery(
        userId: userId,
        secret: secret,
        password: password,
      );
    } catch (e) {
      throw ResetPasswordException('Failed to reset password');
    } finally {
      notifyListeners();
    }
  }
}
