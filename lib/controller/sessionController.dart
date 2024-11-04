import 'package:empoderaecommerce/models/userModel.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserSession(User user) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('isLoggedIn', true);
  prefs.setInt('userId', user.id);
  prefs.setString('userName', user.name);
  prefs.setString('userEmail', user.email);
}

Future<void> checkUserSession() async {
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  if (isLoggedIn) {
    Get.offAllNamed('/home'); // Redireciona para home se logado
  } else {
    Get.offAllNamed('/login'); // Redireciona para login se não logado
  }
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
