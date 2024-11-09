import 'package:flutter/material.dart';

class BottomNavWithBottomSheet extends StatefulWidget {
  @override
  _BottomNavWithBottomSheetState createState() =>
      _BottomNavWithBottomSheetState();
}

class _BottomNavWithBottomSheetState extends State<BottomNavWithBottomSheet> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showBottomSheetMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {},
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bottom Nav with Bottom Sheet')),
      body: Center(child: Text('Page index: $_selectedIndex')),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'More',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 2) {
            _showBottomSheetMenu();
          } else {
            _onItemTapped(index);
          }
        },
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: BottomNavWithBottomSheet()));
