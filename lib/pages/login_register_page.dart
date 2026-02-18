import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() {
    return const Text('Firebase auth');
  }

  Widget _emailEntryField(String title, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      autofillHints: const [AutofillHints.email],
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email',
      ),
    );
  }

  Widget _passwordEntryField(String title, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      autofillHints: [AutofillHints.password],
      obscureText: true,
      decoration: InputDecoration(labelText: 'Password'),
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == "" ? "" : "Error: $errorMessage");
  }

  Widget _summitButton() {
    return ElevatedButton(
      onPressed: isLogin
          ? signInWithEmailAndPassword
          : createUserWithEmailAndPassword,
      child: Text(isLogin ? "Login" : "Register"),
    );
  }

  Widget _loginOrRegistrationButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(
        isLogin
            ? "Don't have account yet? Register"
            : "Already have an account? Login",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _title()),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _emailEntryField('email', _controllerEmail),
            _passwordEntryField('password', _controllerPassword),
            _errorMessage(),
            _summitButton(),
            _loginOrRegistrationButton(),
          ],
        ),
      ),
    );
  }
}
