
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import '../utilities/show_error_dialog.dart';


class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
      appBar: AppBar(title: const Text('Login')),
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
              try{
               await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email,
                    password: password,
               );
               Navigator.of(context).pushNamedAndRemoveUntil(notesRoute,
                        (route) => false,
               );
              }on FirebaseAuthException catch(e){
                if(e.code == 'user-not-found'){
                  await showErrorDialog(
                    context,
                    'User not found',
                  );
                }
                else if(e.code =='wrong-password'){
                  await showErrorDialog(
                    context,
                    'Wrong credentials',
                  );
                }else{
                  await showErrorDialog(
                    context,
                    'Error:${e.code}',
                  );
                }
              }catch(e){
                await showErrorDialog(
                  context,
                  e.toString(),
                );
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
              onPressed: (){
                Navigator.of(context).pushNamedAndRemoveUntil(
                    registerRoute,
                        (route) => false);
              },
              child: const Text('Not registered yet? Register here!'),
          )
        ],
      ),
    );
  }
}

