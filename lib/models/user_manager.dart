class UserManager {
  static Map<String, dynamic>? _loggedInUser;

  // Getter to access logged-in user information
  static Map<String, dynamic>? get loggedInUser => _loggedInUser;

  // Method to set logged-in user information
  static void setUser(Map<String, dynamic> user) {
    _loggedInUser = user;
  }

  // Method to clear logged-in user information (on logout)
  static void clearUser() {
    _loggedInUser = null;
  }

  // Add more methods as needed to manage user state
}
