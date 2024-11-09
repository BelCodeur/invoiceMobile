import 'package:flutter/material.dart';
import 'package:invoicehub/widget/login.dart';
import 'package:invoicehub/widget/register.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool visible = true;
  toggle() {
    setState(() {
      visible = !visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return visible ? Login(toggle) : Register(toggle);
  }
}
