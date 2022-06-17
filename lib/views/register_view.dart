import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool isPressed = false;
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
                hintText: 'Enter your email here',
                prefixIcon: Icon(Icons.mail)),
          ),
          TextField(
            controller: _password,
            obscureText: isPressed ? false : true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
                hintText: 'Enter your password here',
                suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        if (!isPressed) {
                          isPressed = true;
                        } else {
                          isPressed = false;
                        }
                      });
                    },
                    icon: isPressed
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off)),
                prefixIcon: const Icon(Icons.key)),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on WeakPasswordAuthException{
                await showErrorDialog(context, 'Weak password');
              } on EmailAlreadyInUseAuthException{
                await showErrorDialog(context, 'Email is already in use');
              } on InvalidEmailAuthException{
                 await showErrorDialog(
                      context, 'This is an invalid email address');
              } on GenericAuthException{
                 await showErrorDialog(
                    context,
                    'Failed to Register',
                  );
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text('Already registered? Login here!'),
          )
        ],
      ),
    );
  }
}
