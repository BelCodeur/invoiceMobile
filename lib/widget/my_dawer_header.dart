import 'package:flutter/material.dart';

class MyHeaderDrawer extends StatefulWidget {
  final String userlName;
  final String userEmail;

  const MyHeaderDrawer({required this.userlName, required this.userEmail});

  @override
  State<MyHeaderDrawer> createState() => __MyHeaderDrawerState();
}

class __MyHeaderDrawerState extends State<MyHeaderDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal[700],
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 70,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/images/profile.png'),
                )),
          ),
          Text(
            widget.userlName,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Text(
            widget.userEmail,
            style: TextStyle(
              color: Colors.grey[200],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}