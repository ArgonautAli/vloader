import 'package:flutter/material.dart';
import 'package:vloader/screens/WebScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List pages = [BrowserPage()];
  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BrowserPage(),
      bottomNavigationBar: SizedBox(
        child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _navigateBottomBar,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.play_arrow, size: 32), label: "Video"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.download, size: 32), label: "Downloads"),
            ]),
      ),
      drawer: Drawer(child: _drawerWidget()),
    );
  }
}

_drawerWidget() {
  return Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            title: const Text('Item 1'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
        ],
      ),
    ),
  );
}
