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
                  icon: Icon(Icons.tab, size: 32), label: "Tabs"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.download, size: 32), label: "Downloads"),
            ]),
      ),
    );
  }
}
