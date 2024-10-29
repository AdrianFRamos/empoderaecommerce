import 'package:empoderaecommerce/models/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserSession(User user) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('isLoggedIn', true);
  prefs.setInt('userId', user.id!);
  prefs.setString('userName', user.name);
  prefs.setString('userEmail', user.email);
}

class SaveUserSession {
  static Future<User?> getUserFromSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    final userName = prefs.getString('userName');
    final userEmail = prefs.getString('userEmail');

    if (userId != null && userName != null && userEmail != null) {
      return User(id: userId, name: userName, email: userEmail, password: '');
    }
    return null; 
  }
}
