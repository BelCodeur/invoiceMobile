import 'package:flutter/material.dart';
import 'package:invoicehub/functions/custumTextField.dart';

class Register extends StatefulWidget {
  final void Function()? visible;
  Register(this.visible);
  // const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  CustomTextField emailText =
      new CustomTextField(title: "Email", placeholder: "Enter email");

  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    emailText.err = "entrez l'email";
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(30),
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Mot de passe oublié ?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange),
                  ),
                  Text(
                    "Entrez votre adresse email nous vous enverons votre mot de passe a cet adresse.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[400]),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  emailText.textFormField(),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_key.currentState?.validate() ?? false) {
                        print(emailText.value);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 12,
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Container(
                      width: 200,
                      child: const Text(
                        'Recevoir',
                        textAlign: TextAlign.center,
                        softWrap: false,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: widget.visible,
                    child: Text(
                      "Login",
                      softWrap: false,
                      style: TextStyle(
                          color: Colors.grey[700], fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
