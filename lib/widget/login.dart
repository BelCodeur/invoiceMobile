import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:invoicehub/functions/custumTextField.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:invoicehub/functions/publics_functions.dart';
import 'package:invoicehub/widget/dashboard_page.dart';
import 'package:invoicehub/widget/home_page.dart';

class Login extends StatefulWidget {
  final void Function()? visible;
  Login(this.visible);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  CustomTextField usernameText =
      new CustomTextField(title: "Name", placeholder: "Enter name");
  CustomTextField passText = new CustomTextField(
      title: "Password", placeholder: "*********", ispass: true);

  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    usernameText.err = "entrez le nom";
    passText.err = "entrez le mot de passe";
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
                    "Login",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  usernameText.textFormField(),
                  SizedBox(
                    height: 10,
                  ),
                  passText.textFormField(),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_key.currentState?.validate() ?? false) {
                        login();
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
                        'Connecte toi',
                        textAlign: TextAlign.center,
                        softWrap: false,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: widget.visible,
                    child: Text(
                      "Mot de passe oublié ?",
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

  void login() async {
    String Url = "http://invoiceshub.imagic-community.com/api/user.php";

    final Map<String, dynamic> jsonData = {
      "username": usernameText.value,
      "password": passText.value,
    };

    final Map<String, dynamic> queryParams = {
      "operation": "login",
      "json": jsonEncode(jsonData),
    };

    try {
      http.Response response =
          await http.get(Uri.parse(Url).replace(queryParameters: queryParams));

      if (response.statusCode == 200) {
        var user = jsonDecode(response.body); // retourne type list<map>
        if (user.isNotEmpty) {
          showMessageBox(
              context, "success!", "You have successfully registred!");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AcceilPage(
                      userId: user[0]['ID'],
                      userlName: user[0]['nom'],
                      userEmail: user[0]['email'])));
          // usernameText.value = " ";
          // passText.value = " ";
        } else {
          showMessageBox(context, "Error!", "Invalid Username or Password!");
          // setState(() {
          //   _msg = "Invalid Username or Password";
          // });
        }
      } else {
        showMessageBox(context, "Error!", "${response.statusCode}!");
        // print("Error : ${response.statusCode}");
      }
    } catch (error) {
      showMessageBox(context, "Error!", "$error");
      // setState(() {
      //   _msg = "$error";
      // });
    }
  }
}
