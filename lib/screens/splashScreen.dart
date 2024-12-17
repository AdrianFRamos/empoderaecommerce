import 'package:flutter/material.dart';
import 'package:empoderaecommerce/controller/sessionController.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay de 3 segundos antes de checar a sessão
    Future.delayed(const Duration(seconds: 3), () {
      SaveUserSession.checkUserSession(); // Chama a função após o delay
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
