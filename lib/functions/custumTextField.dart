import 'package:flutter/material.dart';

class CustomTextField {
  final String title;
  final String placeholder;
  final bool ispass;
  String err;
  String _value = "";

  CustomTextField(
      {this.title = "",
      this.placeholder = "",
      this.ispass = false,
      this.err = "Veillez Specifier ce champ"});
  TextFormField textFormField() {
    return TextFormField(
      
      onChanged: (e) {
        _value = e;
      },
      
      validator: (e) =>
          e == null || e.isEmpty ? this.err : null, // Improved validation
      obscureText: this.ispass,
      decoration: InputDecoration(
        hintText: this.placeholder,
        labelText: this.title,
        labelStyle: TextStyle(color: Colors.orange),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.orange,
        )),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  String get value {
    return _value;
  }
}
