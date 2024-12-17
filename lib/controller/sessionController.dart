import 'package:empoderaecommerce/models/userModel.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveUserSession {
  static Future<User?> getUserFromSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    final userName = prefs.getString('userName');
    final userEmail = prefs.getString('userEmail');

    print('Sessão carregada: userId: $userId, userName: $userName, userEmail: $userEmail');

    if (userId != null && userName != null && userEmail != null) {
      return User(id: userId, name: userName, email: userEmail, password: '');
    }
    return null;
  }

  static Future<void> checkUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Get.offAllNamed('/home'); // Redireciona para home se logado
    } else {
      Get.offAllNamed('/login'); // Redireciona para login se não logado
    }
  }


  static Future<void> saveUserSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', user.id ?? 0);
    await prefs.setString('userName', user.name);
    await prefs.setString('userEmail', user.email);
    await prefs.setBool('isLoggedIn', true); 
    print('Sessão salva: userId: ${user.id}, userName: ${user.name}, userEmail: ${user.email}');
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userName');
    await prefs.remove('userEmail');
  }
}
