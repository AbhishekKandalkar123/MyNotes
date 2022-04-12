
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
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
      appBar: AppBar(title: const Text('Register'),
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
              try{
                final userCredential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                    email: email, password: password);
              }on FirebaseAuthException catch(e){
                if(e.code == 'weak-password'){
                  print('Weak Password');
                }else if(e.code == 'email-already-in-use'){
                  print('Email is already in use');
                }else if(e.code == 'invalid-email'){
                  print('Invalid Email');
                }
              }
            },
            child: const Text('Register'),
          ),
          TextButton(onPressed: (){
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/login/',
                    (route) => false);
          },
            child: const Text('Already registered? Login here!'),
          )
        ],
      ),
    );
  }
}

