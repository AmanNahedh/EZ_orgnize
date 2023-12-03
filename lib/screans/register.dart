import 'package:ez_orgnize/General/textFormField.dart';
import 'package:ez_orgnize/screans/register_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final firebase = FirebaseAuth.instance;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var scafoldKey = GlobalKey<FormState>();

  var emailCont = TextEditingController();
  var passCont = TextEditingController();

  void _valdiate() async {
    final isValid = scafoldKey.currentState!.validate();

    if (!isValid) {
      return;
    }
    try {
      var userCredintial = await firebase.createUserWithEmailAndPassword(
          email: emailCont.text, password: passCont.text);

      print(userCredintial);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const RegisterInfo(),
      ));
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'auth failde'),
          ),
        );
      } else if (error.code == 'invalid-email') {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'auth failde'),
          ),
        );
      } else {
        print('\' ${error.code} \'');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Form(
        key: scafoldKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextForm(
                controler: emailCont,
                hint: 'Email  Address',
                icon: const Icon(Icons.email),
                valid: (value) {
                  if (value.isEmpty) {
                    return 'pls enter email';
                  } else if (!value.contains('@')) {
                    return 'pls enter valid email';
                  }
                },
              ),
              TextForm(
                hint: 'Password',
                pass: true,
                controler: passCont,
                icon: const Icon(Icons.password),
                valid: (value) {
                  if (value.isEmpty) {
                    return 'pls enter password';
                  } else if (value.length < 6) {
                    return 'pls make the password at least 6 ';
                  }
                },
              ),
              const Divider(),
              ElevatedButton(
                onPressed: _valdiate,
                child: const Text('sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
