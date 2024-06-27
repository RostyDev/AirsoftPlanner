import 'user_model.dart';

class UserManager {
  static User? _loggedInUser;

  // Getter to access logged-in user information
  static User? get loggedInUser => _loggedInUser;

  // Method to set logged-in user information
  static void setUser(User user) {
    _loggedInUser = user;
  }

  // Method to clear logged-in user information (on logout)
  static void clearUser() {
    _loggedInUser = null;
  }

  // Add more methods as needed to manage user state
}
