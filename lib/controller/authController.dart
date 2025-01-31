import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:empoderaecommerce/const/hashedPassword.dart';
import 'package:empoderaecommerce/helper/databaseHelper.dart';
import 'package:empoderaecommerce/models/userModel.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<Database> get database async {
    return await DatabaseHelper.instance.database;
  }

  // ========================
  //  🔹 LOGIN COM EMAIL/SENHA
  // ========================
  Future<bool> loginWithEmailAndPassword() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final hashedPassword = hashPassword(password);

    final user = await getUserByEmail(email);
    
    if (user != null) {
      if (user.isGoogleUser && (user.password == null || user.password!.isEmpty)) {
        print("❌ Usuário do Google sem senha definida.");
        return false;
      }
      
      if (user.password == hashedPassword) {
        await saveUserSession(user);
        print('✅ Usuário logado com e-mail/senha: ${user.toMap()}');
        return true;
      } else {
        print("❌ Senha incorreta.");
        return false;
      }
    }

    print("❌ Usuário não encontrado.");
    return false;
  }

  // ========================
  //  🔹 LOGIN COM GOOGLE
  // ========================
  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('⚠️ Login com Google cancelado.');
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // Verifica se o usuário já existe no SQLite
        UserModel? existingUser = await getUserByEmail(firebaseUser.email ?? "");
        int userId = existingUser?.id ?? 0;

        if (existingUser == null) {
          userId = await insertUser(UserModel(
            id: null, // SQLite gera o ID automaticamente
            firebaseUid: firebaseUser.uid,
            name: firebaseUser.displayName ?? "Usuário Google",
            email: firebaseUser.email ?? "Sem Email",
            password: null,
            isGoogleUser: true,
          ));
        }

        UserModel user = UserModel(
          id: userId, // Agora está preenchido corretamente
          firebaseUid: firebaseUser.uid,
          name: firebaseUser.displayName ?? "Usuário Google",
          email: firebaseUser.email ?? "Sem Email",
          password: null,
          isGoogleUser: true,
        );

        await saveUserSession(user);
        print('✅ Usuário logado via Google: ${user.toMap()}');
        Get.offAllNamed('/home');
      }
    } catch (e) {
      print('❌ Erro ao logar com Google: $e');
    }
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<void> setUserPassword(String email, String newPassword) async {
    final db = await database;
    final hashedPassword = hashPassword(newPassword);

    final user = await getUserByEmail(email);
    if (user == null) {
      print("❌ Usuário não encontrado.");
      return;
    }

    await db.update(
      'users',
      {
        'password': hashedPassword,
        'isGoogleUser': 0,
      },
      where: 'email = ?',
      whereArgs: [email],
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGoogleUser', false);
    
    print("✅ Senha definida com sucesso!");
  }

  // ========================
  //  🔹 SALVAR/RECUPERAR SESSÃO
  // ========================
  Future<void> saveUserSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', user.id ?? 0);
    await prefs.setString('userName', user.name);
    await prefs.setString('userEmail', user.email);
    await prefs.setBool('isLoggedIn', true);
    await prefs.setBool('isGoogleUser', user.isGoogleUser);
    print('💾 Sessão salva: ${user.toMap()}');
  }

  Future<UserModel?> getUserFromSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    final userName = prefs.getString('userName');
    final userEmail = prefs.getString('userEmail');
    final isGoogleUser = prefs.getBool('isGoogleUser') ?? false;

    if (userId != null && userName != null && userEmail != null) {
      return UserModel(
        id: userId,
        name: userName,
        email: userEmail,
        isGoogleUser: isGoogleUser, 
      );
    }

    print("⚠️ Nenhum usuário na sessão.");
    return null;
  }

  Future<void> checkUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/login');
    }
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("🗑️ Sessão apagada!");
  }

  // ========================
  //  🔹 LOGOUT
  // ========================
  Future<void> logout() async {
    await clearSession();
    await _auth.signOut();
    await _googleSignIn.signOut();
    print('🚪 Usuário deslogado');
    Get.offAllNamed('/login');
  }
}
