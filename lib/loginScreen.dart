import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
                onSaved: (value) => _email = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
                onSaved: (value) => _password = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    // Login logic here
                    _loginUser();
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _loginUser() async {
  // Check if user exists in database
  final database = await DatabaseHelper.instance;
  final user = await database.getUserByEmailAndPassword(_email, _password);

  if (user != null) {
    // Navigate to home screen
    Navigator.pushReplacementNamed(context, '/home');
  } else {
    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Invalid email or password'),
      ),
    );
  }
}
}