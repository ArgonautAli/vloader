import 'package:flutter/material.dart';
import 'package:web_browser/web_browser.dart';

class WebScreen extends StatefulWidget {
  WebScreen({super.key});

  @override
  State<WebScreen> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  final _controller = TextEditingController();
  String search = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("web page"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
          ),
          SizedBox(height: 16),
          Expanded(
            child: SafeArea(
              child: Browser(
                initialUriString: 'https://flutter.dev/',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
