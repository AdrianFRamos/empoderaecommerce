import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> loginWithGoogle() async {
  try {
    // Inicia o fluxo de autenticação
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      // Login cancelado pelo usuário
      print('Login com o Google cancelado pelo UsuarioS');
      return;
    }

    // Obtem o token de autenticação do Google
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Cria uma credencial para o Firebase
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Realiza o login no Firebase
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    // Obtém informações do usuário logado
    User? user = userCredential.user;
    print('Usuário logado: ${user?.displayName}');
    print('Email: ${user?.email}');

    Get.offAllNamed('/home');
  } catch (e) {
    print('Erro ao fazer login com o Google: $e');
  }
}

void logout_Google() async {
  await FirebaseAuth.instance.signOut();
  await GoogleSignIn().signOut();
  print('Usuário deslogado');
}

